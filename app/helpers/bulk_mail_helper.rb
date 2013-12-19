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

  def deliver_mail(rcpt,type,mail_params,att_file,att_data,resultHash)
    begin
      if not is_mail_blacklisted?(rcpt.email) then
        CustomInfoMail.notify(rcpt.email,mail_params,att_file,att_data).deliver
        recordMailSuccess(mail_params[:event_id],rcpt, mail_params[:subject])
        return true
      else 
        recordMailFailure(mail_params[:event_id],rcpt,"blacklist")
        result = { :err=>"blacklisted", :entity=>contact,:type =>type}
        resultHash.push(result)
        return false
       end
    rescue
      recordMailFailure(mail_params[:event_id],rcpt,$!)
      result = { :err=>$!, :entity=>rcpt,:type =>type}
      resultHash.push(result)
      return false
    end
  end

end
