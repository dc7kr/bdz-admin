class SepaRegenerationController < AuthenticatedNonResourceController

  def index
    authorize! :member, :edit
  end

  def regenerate
      authorize! :member, :edit
      @bookings = MemberAccountBooking.includes(:member).where('booking_txt = ?',params[:sepa][:booking_txt])

      datePrefix = Time.now.strftime '%Y%m%d%H%M%S'
      sw = SEPAWriter.new(datePrefix,BDZ_SETTINGS)

     @bookings.each do |b|

      orch = Orchestra.find_by_member_id(b.member_id)
      booking_txt = "BDZ-Beitrag #{b.booking_year}"
      currentSheet = orch.currentReportSheet
      invoice = currentSheet.gen_invoice

      logger.debug("Booking: #{orch.account_owner} #{orch.mglnr} #{orch.iban} #{orch.bic}")
      if ( orch.is_direct_debit? ) then
        sw.addBooking(orch,invoice.sum,booking_txt+" "+orch.mglnr.to_s,"RCUR")
      end

      ddFile = sw.generateFile
      send_file(ddFile.full_path, :filename => ddFile.orig_filename, :type => "application/octet-stream")
    end
  end
end
