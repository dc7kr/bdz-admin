module BulkMailHelper
  def is_mail_blacklisted?(mail) 
    mail.contain?("aol.com") 
  end

  def recordMailSuccess(event_id,id,subject,filename=nil)
    event = MemberEvent.newEmail(event_id,id,subject)
    if filename then
      event.filename=filename
    end
    event.save
  end

  def recordMailFailure(event_id,id, email, result)
    event = MemberEvent.newFailedEmail(event_id,id,result.to_s)
    event.save
  end
end
