class ReportSheetMailingsController < AuthenticatedNonResourceController

  include PDFHelper
  include BulkMailHelper
  include FileArchiveHelper


  def gen_mailings
    authorize! :index, Orchestra

    @skipCount =0;
    @orchCount =0;
    @orchFailCount=0;
    @letterCount = 0;
    @results =  Array.new

    now = Time.now
    date_prefix = now.strftime '%Y%m%d'
    cur_year = now.strftime "%Y"

    rs_year = nil
    if params[:year].nil? then
      rs_year = Time.now.year
    else
      rs_year = params[:year].to_i
    end

    event_id = "MB_"+rs_year.to_s

    subject="Meldebogen Anschreiben "+rs_year.to_s

    tool = MailingTool.new(cur_year.to_s,"gs",event_id,subject);

    @orchestras = Orchestra.member_next_year

    results = Array.new

    letterArray = Array.new

    @orchestras.each do |orchestra|
      if ( orchestra.has_notify_event?(event_id))
        @skipCount+=1
      elsif not orchestra.report_sheet_required? 
        Rails.logger.info("Skipping #{orchestra.member.mglnr} - no report sheet required")
      else 
        @rsi = ReportSheetInput.for_orchestra_and_year(orchestra,rs_year)
          
        if @rsi.nil? 
          Rails.logger.error("Report sheet input is nil!: #{orchestra.member.mglnr}")
        else
            mailing_pdf = gen_anschreiben(orchestra,@rsi);
            doc_dir = DOCS_CONFIG.archive_dir+"/"
            mailer_params = { :rsi => @rsi }
            result = tool.deliver_mailing(ReportSheetInputMailer, orchestra.to_addressee,  mailing_pdf,  nil, letterArray, mailer_params)  

            results << result

            if result[:success]==true then
                @orchCount+=1;
            else 
                @orchFailCount+=1;
            end
          end
                          end # not yet handled
                  end # orchestras.each 


    pdf_merged_file = nil
    doc_url=nil

    if letterArray.size > 0 then 
      pdf_filename = "#{date_prefix}#{event_id}_meldebogen_anschreiben.pdf"
      pdf_merged_file = MailingFile.new(pdf_filename,pdf_filename,cur_year)
      merge_pdfs(letterArray, pdf_merged_file)
    end


    if not pdf_merged_file.nil? then
   	  base_url = cron_downloads_url
   	  doc_url = base_url+"?year="+cur_year.to_s+"&filename="+pdf_merged_file.orig_filename
    end

		@users = User.for_admin_notify

   	@users.each do |user|
      AdminNotifier.report_sheet_notification(user, doc_url,@current_user).deliver
      Rails.logger.info 'sent to %s' % user.email
   	end
  end

  def test
    date_prefix = Time.now.strftime '%Y%m%d'
    cur_year = Time.now.strftime "%Y"

		rs_year = nil
		if params[:year].nil? then
			rs_year = Time.now.year+1
		else
			rs_year = params[:year].to_i
		end

		event_id = "MB_"+rs_year.to_s
    subject="Meldebogen Anschreiben "+rs_year.to_s

    tool = MailingTool.new(cur_year.to_s,"gs",event_id,subject);

    orchestra = Orchestra.joins(:member).where("members.mglnr = ?",1045).first

    orchestra.member.email = "kr@corika.com"

    @rsi = ReportSheetInput.for_orchestra_and_year(orchestra,rs_year)

    letterArray = Array.new

    mailer_params = { :rsi => @rsi }
    mailing_pdf = gen_anschreiben(orchestra,@rsi)

    result = tool.deliver_mailing(ReportSheetInputMailer, orchestra.to_addressee,  mailing_pdf,  nil, letterArray, mailer_params)  

    send_file(mailing_pdf.full_path, :filename => "meldeboegen_anschreiben.pdf", :type => "application/octet-stream")
  end
end
