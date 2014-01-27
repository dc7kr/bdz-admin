module BulkMailHelper

  def is_mail_blacklisted?(mail) 
    mail.include?("aol.com") 
  end

  def recordMailSuccess(event_id,entity,subject,filename=nil)
    Rails.logger.debug("Mail success  : "+entity.class.name )
    Rails.logger.debug("Festival class: "+FestivalApplication.class.name)

    if ( entity.class.name == ContactPerson.new.class.name ) then 
      event = ContactEvent.newEmail(event_id,entity.id,subject)
    else
      event = MemberEvent.newEmail(event_id,entity.id,subject)
    end

    if filename then
      event.filename=filename
    end
    event.save
  end

  def recordMailFailure(event_id,entity, result)
    event = nil
    if (entity.class.name == ContactPerson.new.class.name ) then
      event = ContactEvent.newFailedEmail(event_id,entity.id,result.to_s)
    else
      event = MemberEvent.newFailedEmail(event_id,entity.id,result.to_s)
    end
    event.save
  end

  def recordLetter(event_id,entity,subject,filename)
	  event = MemberEvent.newLetter(event_id,entity.id,subject)
	  event.filename=filename
	  event.save
  end

  def deliver_letter(rcpt,event_id,subject,letter)
    recordLetter(event_id, rcpt, subject, letter.filename)
  end

  def move_attachment(date_prefix, att_file,rcpt)
      #FileUtils.cp(att_file,
  end
 
  def deliver_mailing(datePrefix, year, our_contact, rcpt, mail_params, template, attachment, letterArray)  
    rel_path = nil 
    doc=nil
    filled_template = nil 

    event_id = mail_params[:event_id]
    subject = mail_params[:subject]
    body = mail_params[:body]

    doc = prepare_pdf(rcpt,our_contact,File.join(BDZ_SETTINGS["invoice_archive_dir"],template.filename))
    suffix=event_id+"_"+rcpt.mglnr.to_s
    rel_path = store_pdf(datePrefix, year, suffix, doc)
    filled_template = MailingFile.new(rel_path,template.filename)
    att_data = doc.render

    if not rcpt.has_email? then
      result = deliver_letter(rcpt,event_id,subject,filled_template)
      letterArray << filled_template.filename
      Rails.logger.info("Created letter for " << rcpt.mglnr.to_s)
      return result
    else 
      o_result = deliver_email(rcpt,subject, body, 
        event_id, filled_template,attachment)
      if o_result[:success]!= true then
        Rails.logger.info("Mail delivery failed: "+rcpt.email)
        result = deliver_letter(rcpt, event_id,subject, filled_template)
        letterArray << filled_template.filename
        return result
      else
        return o_result
      end
    end
  end

  def deliver_email(rcpt,subject, body, event_id, letter,attachment)
    begin
      type = rcpt.class
      if not is_mail_blacklisted?(rcpt.email) then
        CustomInfoMail.notify(rcpt.email,subject, body, letter,attachment).deliver
        recordMailSuccess(event_id,rcpt, subject)
        result = { :success=>true, :mode => "E" ,:entity=>rcpt}
        return result
      else 
        recordMailFailure(event_id,rcpt,"blacklist")
        result = { :err=>"blacklisted", :entity=>rcpt,:type =>type, :mode => "E"}
        return result
       end
    rescue
      recordMailFailure(event_id,rcpt,$!)
      return { :err=>$!, :entity=>rcpt,:type =>type, :mode=> "E"}
    end
  end

  def prepare_pdf(rcpt,our_contact="gs", att_file)
    doc = CompanyPaperDocument.new(att_file)
    doc.print_address(rcpt)
    doc.print_date(BDZ_SETTINGS["contacts"][our_contact]["ort"],Time.now)

    doc
  end

  def store_pdf(date_prefix, year, suffix,doc)
    year = Time.now.year.to_s
    arch_dir = path = File.join(BDZ_SETTINGS['invoice_archive_dir'],year)

    filename = date_prefix+suffix+".pdf"
    filled_template_file = File.join(arch_dir,filename)

    doc.render_file(filled_template_file)
    
    return File.join(year,filename)
  end
  
end
