class CustomInfoMailWorker

  include Sidekiq::Worker
  include BulkMailHelper
  include FileArchiveHelper
  include Rails.application.routes.url_helpers

  include PDFHelper
  include BulkMailHelper
  include UploadHelper


  def default_url_options
    {
      :host =>  ActionMailer::Base.default_url_options[:host],
      :protocol => ActionMailer::Base.default_url_options[:protocol]
    }
  end


  def perform(user_id,letterfile_hash, attachment_hash, subject, body, event_id, grp, via_paper)

    triggered_by = User.find(user_id)

    letterfile = MailingFile.fromHash(letterfile_hash)
    attachment = MailingFile.fromHash(attachment_hash)

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
    if ( orchestra ) then
      orchestras = Orchestra.mailForEvent(event_id,via_paper)

      mailer_params = { :subject => subject, :body=> body}

      orchestras.each do |orchestra| 

        filled_template = customize_letter(date_prefix, cur_year.to_s,"gs", orchestra,event_id, letterfile)
        o_result = tool.deliver_mailing(CustomInfoMail,orchestra, filled_template, attachment , letterArray,mailer_params)  
        results.push(o_result) 
      end
    end

    if ( test ) then  
      addr1 = DummyAddress.new
      addr2 = DummyAddress.new
      addrs = Array.new

      addr1.company = "Testfirma"
      addr1.fullname = "Karsten Richter"
      addr1.street = "Turmstr. 65"
      addr1.zip = "46539"
      addr1.city = "Dinslaken"
      addr1.country_code="DE"

      addrs << addr1
      addr2.company= "Testfirma2"
      addr2.fullname="Someone Outside Germany"
      addr2.street="Elm Street"
      addr2.zip="12398"
      addr2.city="New York"
      addr2.country_code="US"
      
      addrs << addr2

      addrs.each do |dummy| 

        filled_template = customize_letter(date_prefix, cur_year.to_s,"gs", dummy,event_id, letterfile)
        o_result = tool.deliver_mailing(CustomInfoMail,dummy, filled_template, attachment , letterArray,mailer_params)  
        results.push(o_result) 
      end
      
    end

    if ( em ) then
      persons = PersonMember.mailForEvent(event_id, via_paper) 

      persons.each do |person| 
        filled_template = customize_letter(date_prefix, cur_year.to_s,"gs", person,event_id, letterfile)
        o_result = tool.deliver_mailing(CustomInfoMail,person, filled_template, attachment , letterArray,mailer_params)  
        results.push(o_result) 
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
