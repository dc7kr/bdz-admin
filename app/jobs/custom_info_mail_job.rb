class CustomInfoMailJob < ApplicationJob

  include Rails.application.routes.url_helpers

  include PdfHelper
  include BulkMailHelper
  include UploadHelper


  def default_url_options
    {
      :host =>  ActionMailer::Base.default_url_options[:host],
      :protocol => ActionMailer::Base.default_url_options[:protocol]
    }
  end


  def perform(user_id,letterfile_hash, attachment_hash, subject, body, event_id, grp, via_paper)

    fa = FileArchiveTool.new(DOCS_CONFIG)

    triggered_by = User.find(user_id)

    letterfile = MailingFile.from_hash(letterfile_hash)
    attachment = MailingFile.from_hash(attachment_hash)

    datePrefix = Time.now.strftime '%Y%m%d_'

    orchestra=false
    em=false
    test=false
    festival=false
  
    if ( grp == 'A') then
      orchestra = true
      em = true
    elsif ( grp =='O') then
      orchestra = true
    elsif ( grp == 'E') then 
      em = true
    elsif ( grp == 'T') then
      test = true 
    elsif ( grp == 'F') then
      festival = true
    end

    cur_year = Time.now.year
    date_prefix =  Time.now.strftime("%Y%d%m%H%M_")

    testCount =0;
    testFailCount=0;
    orchCount =0;
    orchFailCount=0;

    personCount = 0;
    personFailCount=0;
    results =  Array.new

    att_file=nil
    att_data=nil

    tool = MailingTool.new(cur_year.to_s,"gs",event_id,subject);

    letterArray = Array.new 

    mailer_params = { :subject => subject, :body=> body}

    if ( orchestra ) then
      orchestras = Orchestra.mailForEvent(event_id,via_paper)

      orchestras.each do |orchestra| 

        addr = orchestra.to_addressee
        Rails.logger.debug("Generating for: #{addr.id}")
        filled_template = customize_letter(date_prefix, cur_year.to_s,"gs", addr, event_id, letterfile)
        o_result = tool.deliver_mailing(CustomInfoMail,addr, filled_template, attachment , letterArray,mailer_params)  
        results.push(o_result) 
      end
    end
    if ( test ) then
      addrs = Array.new

      addrs << Addressee.dummy_for_mail
      addrs << Addressee.dummy_for_letter

      addrs.each do |addr|
        filled_template = customize_letter(date_prefix, cur_year.to_s,"gs", addr,event_id, letterfile)
        o_result = tool.deliver_mailing(CustomInfoMail,addr, filled_template, attachment , letterArray,mailer_params)  
        results.push(o_result) 
      end
    end

    if ( em ) then
      persons = PersonMember.mailForEvent(event_id, via_paper) 

      persons.each do |person| 
        addr = person.to_addressee

        Rails.logger.debug("Generating for: EM #{addr.id}")
        filled_template = customize_letter(date_prefix, cur_year.to_s,"gs", addr,event_id, letterfile)
        o_result = tool.deliver_mailing(CustomInfoMail,addr, filled_template, attachment , letterArray,mailer_params)  
        results.push(o_result) 
      end
    end

    if via_paper then
      pdf_filename = "#{date_prefix}#{event_id}_letters.pdf"
      pdf_merged_file = MailingFile.new(pdf_filename,pdf_filename)
      fa.merge_pdfs(letterArray, pdf_merged_file)
    end

    send_admin_mail(pdf_merged_file,triggered_by,results)
  end
end
