class Cron::LvDtausController < AuthenticatedNonResourceController

def index
  	authorize! :member, :edit

	@lvs = RegionalOrganization.all

	@saldi = RegionalOrganizationBooking.where("booking_year = ?",Time.now.year.to_s).group(:regional_organization).sum(:amount)

	@lvHash = Hash.new

	@saldi.each do |s|
		@lvHash[s[0].id]= s[1]
		Rails.logger.debug "Saldo: "+s[0].id.to_s+"->"+s[1].to_s
	end

	@dw = DtausWriter.new

	File.open(@dw.ctlFile,"w") do |dtafile| 
		@dw.outfile(dtafile)
		@dw.writeDtausHeader(false)

		year = Time.now.year.to_s
		@lvs.each do |lv|
			fee_shares = lv.member_fee_share_for_year

      amount = fee_shares[:em_part]+fee_shares[:orch_part]
      logger.debug "Amount: "+lv.id.to_s+"->"+amount.to_s
			saldo = @lvHash[lv.id]
			if saldo == nil then
				saldo=0
			end

			Rails.logger.debug "LV: "+lv.id.to_s+" AMOUNT:"+amount.to_s+" SALDO:"+saldo.to_s
			if ( amount != nil ) then	
				if ( amount >0 ) then
					@booking = RegionalOrganizationBooking.newCredit("Gutschrift Beitragsanteil "+year, amount)
					@dw.writeLvEntry(lv,"LV-Beitragsanteil "+year,amount)
					@booking.regional_organization_id = lv.id
					@booking.save
				else
					Rails.logger.info "Negative amount for LV: "+lv.name
				end
			end
		end
	end
	@dw.genDtaus()
	@dw.moveGeneratedFiles()

	send_mail(@dw.datePrefix)

    respond_to do |format|
      format.html { redirect_to home_cron_path, :notice => 'LV DTAUS erfolgreich generiert.' }
    end

end

 def send_mail(dtausPrefix)

    year = Time.now.strftime('%Y')
    pdf_prefix= Time.now.strftime '%Y%m%d'

    @users = User.where("role like ? or role like ?", "%accounting%", "%admin%")
    base_url = cron_downloads_url
    dtaus_url = base_url+"?year="+year+"&filename="+dtausPrefix+"dtaus.zip"

    @users.each do |user|
        AdminNotifier.new_lv_dtaus_notification(user, dtaus_url,@current_user).deliver
        Rails.logger.info 'sent to %s' % current_user.email
    end
  end
end
