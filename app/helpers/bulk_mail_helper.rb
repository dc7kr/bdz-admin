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
end
