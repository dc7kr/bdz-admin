module Adm
  class SepaRegenerationController < AuthenticatedNonResourceController
    def index
      authorize! :member, :edit
    end

    def regenerate_by_date_and_type
      authorize! :member, :edit
      booking_date = params[:sepa][:booking_date]
      member_type = params[:sepa][:member_type]
      max_mglnr = params[:sepa][:max_mglnr]
      sub_type = params[:sepa][:member_sub_type]

      datePrefix = Time.zone.now.strftime "%Y%m%d%H%M%S"
      sw = CorikaInvoices::SepaWriter.new(datePrefix, INVOICE_CONFIG)

      logger.debug(params)

      logger.debug("Booking date: #{booking_date}")

      @bookings = if max_mglnr.blank?
                    MemberAccountBooking.includes(:member).where("booking_type= 'L' and DATE(booking_date) = ?",
                                                                 booking_date)
      else
                    MemberAccountBooking.joins(:member).where(
                      "booking_type= 'L' and DATE(booking_date) = ? AND members.mglnr <= ?", booking_date, max_mglnr
                    )
      end

      @bookings.each do |b|
        logger.info("Booking: #{b.member.member_entity}")
        txt = b.booking_txt
        txt = txt.gsub(/^Lastschrift /, "")

        orchestra = false
        orchestra = true if member_type == "Orchestra"

        next unless b.member.member_entity_type == member_type

        entity = b.member.member_entity

        filter = false
        filter = true if orchestra && sub_type.present? && (entity.orch_type != sub_type)

        if filter
          Rails.logger.debug { "Filtered: #{b.member.mglnr}" }
        else
          Rails.logger.debug { "Entity account: #{entity.account_owner} - fullname: #{entity.fullname}" }

          customer = b.member.member_entity.to_customer
          sw.add_direct_debit(customer, b.amount, txt, "RCUR")
        end
      end

      dd_file = sw.generate_file

      send_file(dd_file.full_path, filename: dd_file.orig_filename, type: "application/octet-stream")
    end

    def regenerate
      authorize! :member, :edit
      @bookings = MemberAccountBooking.includes(:member).where(booking_txt: params[:sepa][:booking_txt])

      datePrefix = Time.zone.now.strftime "%Y%m%d%H%M%S"
      sw = CorikaInvoices::SepaWriter.new(datePrefix, INVOICE_CONFIG)

      @bookings.each do |b|
        Member.find(b.member_id)

        orch = Orchestra.find(b.member_entity_id)
        booking_txt = "BDZ-Beitrag #{b.booking_year}"
        currentSheet = orch.currentReportSheet
        invoice = currentSheet.gen_invoice

        mglnr = orch.member.mglnr

        logger.debug("Booking: #{orch.account_owner} #{mglnr} #{orch.iban} #{orch.bic}")
        sw.addDirectDebit(orch, invoice.sum, "#{booking_txt} #{mglnr}", "RCUR") if orch.direct_debit?

        ddFile = sw.generateFile
        send_file(ddFile.full_path, filename: ddFile.orig_filename, type: "application/octet-stream")
      end
    end
  end
end
