class MailingTool

  def initialize(year, our_contact,event_id, event_title)
    @year = year
    @our_contact = our_contact
    @event_title = event_title
    @event_id = event_id
  end

  def deliver_mailing(mailer, rcpt, letterFile, attachment, letterArray, additionalMailerParams=nil)  
    if not rcpt.has_email? then
      result = deliver_letter(rcpt,letterFile)
      letterArray << letterFile.filename
      Rails.logger.info("Created letter for " << rcpt.mglnr.to_s)
      return result
    else 
      o_result = deliver_email(mailer, rcpt,letterFile,attachment, additionalMailerParams)
      if o_result[:success]!= true then
        Rails.logger.info("Mail delivery failed: "+rcpt.email)
        result = deliver_letter(rcpt, letterFile)
        letterArray << letterFile.filename
        return result
      else
        return o_result
      end
    end
  end


  private 

  def is_mail_blacklisted?(mail) 
    mail.include?("aol.com") 
  end

  def move_attachment(date_prefix, att_file,rcpt)
      #FileUtils.cp(att_file,
  end
 
  def recordMailSuccess(entity,subject,filename=nil)
    Rails.logger.debug("Mail success  : "+entity.class.name )
    Rails.logger.debug("Festival class: "+FestivalApplication.class.name)

    if ( entity.class.name == ContactPerson.new.class.name ) then 
      event = ContactEvent.newEmail(@event_id,entity.id,subject)
    else
      event = MemberEvent.newEmail(@event_id,entity.id,subject)
    end

    if filename then
      event.filename=filename
    end
    event.save
  end

  def recordMailFailure(entity, result)
    event = nil
    if (entity.class.name == ContactPerson.new.class.name ) then
      event = ContactEvent.newFailedEmail(@event_id,entity.id,result.to_s)
    else
      event = MemberEvent.newFailedEmail(@event_id,entity.id,result.to_s)
    end
    event.save
  end

  def recordLetter(entity,subject,filename)
	  event = MemberEvent.newLetter(@event_id,entity.id,subject)
	  event.filename=filename
	  event.save

    { :success=>true, :mode => "L" ,:entity=>entity}
  end

  def deliver_letter(rcpt,letter)
    recordLetter(rcpt, @event_title, letter.filename)
  end

  def deliver_email(mailer, rcpt, letter,attachment,additionalMailerParams)
    begin
      type = rcpt.class
      if not is_mail_blacklisted?(rcpt.email) then
        mailer.notify(rcpt.email, letter,attachment,additionalMailerParams).deliver
        recordMailSuccess(rcpt, @event_title,letter.orig_filename)
        result = { :success=>true, :mode => "E" ,:entity=>rcpt}
        return result
      else 
        recordMailFailure(rcpt,"blacklist")
        result = { :err=>"blacklisted", :entity=>rcpt,:type =>type, :mode => "E"}
        return result
       end
    rescue
      recordMailFailure(rcpt,$!)
      return { :err=>$!, :entity=>rcpt,:type =>type, :mode=> "E"}
    end
  end
end
