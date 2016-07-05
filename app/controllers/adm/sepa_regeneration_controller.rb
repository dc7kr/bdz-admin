class Adm::SepaRegenerationController < AuthenticatedNonResourceController

  def index
    authorize! :member, :edit
  end

  def regenerate_by_date_and_type
    authorize! :member, :edit
    booking_date = params[:sepa][:booking_date]
    member_type = params[:sepa][:member_type]
    max_mglnr = params[:sepa][:max_mglnr]

    datePrefix = Time.now.strftime '%Y%m%d%H%M%S'
    sw = SEPAWriter.new(datePrefix,BDZ_SETTINGS)

    logger.debug(params)

    logger.debug("Booking date: #{booking_date}")

    query = "booking_type= 'L' and DATE(booking_date) = ?";

    if not max_mglnr.nil? then
      @bookings = MemberAccountBooking.joins(:member).where("booking_type= 'L' and DATE(booking_date) = ? AND members.mglnr <= ?", booking_date, max_mglnr)
    else
      @bookings = MemberAccountBooking.includes(:member).where("booking_type= 'L' and DATE(booking_date) = ?", booking_date)
    end

    @bookings.each do |b|
      txt = b.booking_txt
      txt = txt.gsub(/^Lastschrift /,"")

      if b.member.member_entity_type==member_type then
        entity = b.member.member_entity
        Rails.logger.debug("Entity account: #{entity.account_owner} - fullname: #{entity.fullname}")

        customer = b.member.member_entity.to_customer
        sw.addBooking(customer,b.amount,txt,"RCUR")
      end
    end

    dd_file = sw.generateFile

    send_file(dd_file.full_path, :filename => dd_file.orig_filename, :type => "application/octet-stream")
  end

  def regenerate
    authorize! :member, :edit
    @bookings = MemberAccountBooking.includes(:member).where('booking_txt = ?',params[:sepa][:booking_txt])

    datePrefix = Time.now.strftime '%Y%m%d%H%M%S'
    sw = SEPAWriter.new(datePrefix,BDZ_SETTINGS)

    @bookings.each do |b|
      member = Member.find(b.member_id)
        
      orch = Orchestra.find(b.member_entity_id)
      booking_txt = "BDZ-Beitrag #{b.booking_year}"
      currentSheet = orch.currentReportSheet
      invoice = currentSheet.gen_invoice

      mglnr = orch.member.mglnr

      logger.debug("Booking: #{orch.account_owner} #{mglnr} #{orch.iban} #{orch.bic}")
      if ( orch.is_direct_debit? ) then
        sw.addBooking(orch,invoice.sum,booking_txt+" "+mglnr.to_s,"RCUR")
      end

      ddFile = sw.generateFile
      send_file(ddFile.full_path, :filename => ddFile.orig_filename, :type => "application/octet-stream")
    end
  end
end
