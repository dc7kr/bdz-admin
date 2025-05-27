module Cron
  class LvFeeBookingsController < AuthenticatedNonResourceController
    def index
      authorize! :member, :edit

      @lvs = RegionalOrganization.all

      year = Time.zone.now.strftime("%Y")

      @saldi = RegionalOrganizationBooking.where(booking_year: Time.zone.now.year.to_s).group(:regional_organization).sum(:amount)

      @lvHash = {}

      @saldi.each do |s|
        @lvHash[s[0].id] = s[1]
        Rails.logger.debug { "Saldo: #{s[0].id}->#{s[1]}" }
      end

      datePrefix = Time.zone.now.strftime "%Y%m%d%H%M%S"
      ctw = CreditTransferWriter.new(datePrefix)

      @lvs.each do |lv|
        fee_shares = lv.member_fees_for_year

        fee_shares.corrected_share

        amount = fee_shares.corrected_share - fee_shares.pre_paid

        logger.debug "Pre-paid: #{fee_shares.pre_paid}" if fee_shares.pre_paid != 0

        saldo = @lvHash[lv.id]

        saldo = 0 if saldo.nil?

        Rails.logger.debug { "LV: #{lv.id} AMOUNT:#{amount} SALDO:#{saldo}" }
        unless amount.nil?
          if amount > 0.1
            booking = MemberAccountBooking.new_credit_transfer("Gutschrift Beitragsanteil #{year}", amount)
            ctw.add_credit_transfer(lv, "LV-Beitragsanteil #{year}", amount)
            booking.member = lv.member
            booking.save
          else
            Rails.logger.info "Negative amount for LV: #{lv.name}"
          end
        end
      end

      sepa_file = ctw.generateFile

      send_mail(sepa_file, @current_user)

      respond_to do |format|
        format.html { redirect_to home_cron_path, notice: "Landesverbandsgutschriften erfolgreich generiert." }
      end
    end

    def send_mail(ctFile, triggered_by)
      year = Time.zone.now.strftime("%Y")
      Time.zone.now.strftime "%Y%m%d"

      base_url = cron_downloads_url
      dd_url = nil

      dd_url = "#{base_url}?year=#{year}&filename=#{ctFile.orig_filename}" unless ctFile.nil?

      User.for_admin_notify.each do |user|
        AdminNotifier.new_lv_ct_notification(user, dd_url, triggered_by).deliver
        logger.info "sent to %s" % user.email
      end
    end
  end
end
