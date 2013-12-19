class ReportSheetMailingsController < AuthenticatedNonResourceController

	include PDFHelper
	include NotifyHelper
  include BulkMailHelper


	def gen_mailings
  	authorize! :index, Orchestra

		@skipCount =0;
		@orchCount =0;
		@orchFailCount=0;
		@letterCount = 0;
		@results =  Array.new

		rs_year = nil
		if params[:year]==nil then
			rs_year = Time.now.year+1
		else
			rs_year = params[:year].to_i
		end

		event_id = "MB_"+rs_year.to_s

    @orchestras = Orchestra.includes(:member)

		to_merge = Array.new

    subject="Meldebogen Anschreiben "+rs_year.to_s

		@orchestras.each do |orchestra|
			if ( orchestra.has_notify_event?(event_id))
				@skipCount+=1
			else 
				@rsi = ReportSheetInput.for_orchestra_and_year(orchestra,rs_year)

				mailing_pdf = gen_anschreiben(orchestra,@rsi);

        doc_dir = BDZ_SETTINGS["invoice_archive_dir"]+"/"

	   			@att_file = "Anschreiben_Meldebogen_"+rs_year.to_s+".pdf"
				pdf = File.new(doc_dir+mailing_pdf)
				@att_data = pdf.read
				pdf.close

				if (orchestra.email != nil and orchestra.email.length > 0 ) then
					begin 
						ReportSheetInputMailer.notify(@rsi,rs_year,@att_file,@att_data).deliver

						recordMailSuccess(event_id,orchestra, subject, mailing_pdf)
						@orchCount=@orchCount+1
					rescue
						recordMailFailure(event_id,orchestra,$!)
						@result = { :err=>$!, :entity=>orchestra,:type =>"O"}
						@results.push(@result)
						@orchFailCount+=1
						# if mail fails we send a PDF via snail mail ;)
						to_merge << mailing_pdf
						@letterCount+=1
						recordLetter(event_id,orchestra, subject,mailing_pdf)
					end
				else
					@letterCount+=1
					recordLetter(event_id,orchestra, subject, mailing_pdf)
					to_merge << mailing_pdf
				end # has email 
			end # not yet handled
		end # orchestras.each 
		# POST loop
		if ( to_merge.size > 0 ) then
			docs_dir = BDZ_SETTINGS['docs_archive_dir']+"/"+rs_year.to_s
			date_prefix = Time.now.strftime '%Y%m%d%H%M%S_'
			out_file = date_prefix+"anschreiben_merge.pdf"

    		merge_pdfs(docs_dir, to_merge,out_file)
   			base_url = cron_downloads_url
   			doc_url = base_url+"?year="+rs_year.to_s+"&filename="+out_file

			@users = admin_notify_users

   			@users.each do |user|
       			AdminNotifier.report_sheet_notification(user, doc_url,@current_user).deliver
       			Rails.logger.info 'sent to %s' % user.email
   			end
		end
  end

end
