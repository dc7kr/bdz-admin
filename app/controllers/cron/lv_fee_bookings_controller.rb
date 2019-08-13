class Cron::LvFeeBookingsController < AuthenticatedNonResourceController

  def index
    authorize! :member, :edit

    @lvs = RegionalOrganization.all

    year = Time.now.strftime("%Y")

    @saldi = RegionalOrganizationBooking.where("booking_year = ?",Time.now.year.to_s).group(:regional_organization).sum(:amount)

    @lvHash = Hash.new

    @saldi.each do |s|
      @lvHash[s[0].id]= s[1]
      Rails.logger.debug "Saldo: "+s[0].id.to_s+"->"+s[1].to_s
    end

    datePrefix = Time.now.strftime '%Y%m%d%H%M%S'
    ctw = CreditTransferWriter.new(datePrefix)

    @lvs.each do |lv|
      fee_shares = lv.member_fee_share_for_year

      amount = fee_shares[:em_part]+fee_shares[:orch_part]-fee_shares[:pre_paid]
      logger.debug "Amount: #{lv.id} -> #{amount}"

      if fee_shares[:pre_paid]!=0 
        logger.debug "Pre-paid: #{fee_shares[:pre_paid]}"
      end

      saldo = @lvHash[lv.id]
      if saldo == nil then
        saldo=0
      end

      Rails.logger.debug "LV: "+lv.id.to_s+" AMOUNT:"+amount.to_s+" SALDO:"+saldo.to_s
      if ( amount != nil ) then	
        if ( amount > 0.1 ) then
          booking = MemberAccountBooking.newCreditTransfer("Gutschrift Beitragsanteil "+year, amount)
          ctw.addCreditTransfer(lv, "LV-Beitragsanteil "+year,amount)
          booking.member = lv.member
          booking.save
        else
          Rails.logger.info "Negative amount for LV: "+lv.name
        end
      end
    end

     sepa_file = ctw.generateFile

    send_mail(sepa_file, @current_user)

    respond_to do |format|
      format.html { redirect_to home_cron_path, :notice => 'Landesverbandsgutschriften erfolgreich generiert.' }
    end
 end

 def send_mail(ctFile,triggered_by)

    year = Time.now.strftime('%Y')
    pdf_prefix= Time.now.strftime '%Y%m%d'

    base_url = cron_downloads_url
    dd_url=nil

    if ( ctFile != nil ) then
      dd_url = base_url+"?year="+year+"&filename="+ctFile.orig_filename
    end

    User.for_admin_notify.each do |user|
      AdminNotifier.new_lv_ct_notification(user, dd_url,triggered_by).deliver
      logger.info 'sent to %s' % user.email
    end
  end
end
