class RegionalOrganizationShareBookingJob < ApplicationJob

  def perform

    reg_orgs = RegionalOrganization.all

    year = Time.zone.now.strftime("%Y")

    saldi = RegionalOrganizationBooking.where(booking_year: year).group(:regional_organization).sum(:amount)

    reg_org_hash = {}

    saldi.each do |s|
      reg_org_hash[s[0].id] = s[1]
      Rails.logger.debug { "Saldo: #{s[0].id}->#{s[1]}" }
    end

    date_prefix = Time.zone.now.strftime "%Y%m%d%H%M%S"
    ctw = CreditTransferWriter.new(date_prefix)

    reg_orgs.each do |reg_org|
      fee_shares = reg_org.member_fees_for_year

      fee_shares.corrected_share

      amount = fee_shares.corrected_share - fee_shares.pre_paid

      logger.debug "Pre-paid: #{fee_shares.pre_paid}" if fee_shares.pre_paid != 0

      saldo = reg_org_hash[reg_org.id]

      saldo = 0 if saldo.nil?

      Rails.logger.debug { "LV: #{reg_org.id} AMOUNT:#{amount} SALDO:#{saldo}" }
      unless amount.nil?
        if amount > 0.1
          booking = MemberAccountBooking.new_credit_transfer("Gutschrift Beitragsanteil #{year}", amount)
          ctw.add_credit_transfer(reg_org, "LV-Beitragsanteil #{year}", amount)
          booking.member = reg_org.member
          booking.save
        else
          Rails.logger.info "Negative amount for LV: #{reg_org.name}"
        end
      end
    end

    sepa_file = ctw.generate_file

    send_mail(sepa_file, @current_user)
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
