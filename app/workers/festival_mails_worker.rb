class FestivalMailsWorker

  include Sidekiq::Worker
  include BulkMailHelper
  include FileArchiveHelper
  include Rails.application.routes.url_helpers

  include PDFHelper
  include UploadHelper
  include FestivalMailsHelper

  def perform(user_id,letterfile_hash, attachment_hash, subject, body_template, event_id, group, via_paper)

    successCount=0
    failCount=0
    results = Hash.new

    letterfile = MailingFile.fromHash(letterfile_hash)
    attachment = MailingFile.fromHash(attachment_hash)

    cur_year = Time.now.year

    results = Array.new

    applicants = nil

    if (group == 'FA')  then 
      applicants = FestivalApplication.includes(:contact_person)
    elsif ( group == 'FP') then
      applicants = FestivalApplication.includes(:contact_person).where(:permission=>true)
    elsif ( group == 'FR') then
      applicants = FestivalApplication.includes(:contact_person).where(:permission=>true,:visitor_type=>'R')
    elsif ( group == 'FS') then 
      applicants = FestivalApplication.includes(:contact_person).where(:permission=>true, :visitor_type=>'V')
    elsif ( group == 'FJ') then
      applicants = FestivalApplication.includes(:contact_person).where(:permission=>true,:visitor_type=>'Y')
    elsif ( group == 'FG') then
      applicants = FestivalApplication.includes(:contact_person).where(:permission=>true, :visitor_type=>'G')
    elsif ( group == 'FO') then
      applicants = FestivalApplication.includes(:contact_person).where(:permission=>true, :visitor_type=>'O')
    else 
      logger.error("NO GROUP identified: "+group)
    end

    tool = MailingTool.new(cur_year.to_s,"gs",event_id,subject,via_paper);

    letterArray = Array.new

    applicants.each do |appl|
      contact = appl.contact_person

      body = prepare_body(appl,body_template)
      logger.debug("Result: "+body)
      mailer_params = { :body => body ,:subject => subject }

      result = tool.deliver_mailing(FestivalMail, appl.contact_person, nil, letterfile,  letterArray, mailer_params)  
      results << result

      if result[:success]==true then
          successCount+=1;
      else 
          failCount+=1;
      end
    end

    if via_paper then
      pdf_filename = "#{date_prefix}#{event_id}_letters.pdf"
      pdf_merged_file = MailingFile.new(pdf_filename,pdf_filename,attachment.archive_folder)
      merge_pdfs(letterArray, pdf_merged_file)
    end

    send_admin_mail(pdf_merged_file,triggered_by,results)
  end
 end
end
