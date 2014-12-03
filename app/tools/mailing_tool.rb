class MailingTool

  def initialize(year, our_contact,event_id, event_title,via_paper=true)
    @year = year
    @our_contact = our_contact
    @event_title = event_title
    @event_id = event_id
    @via_paper = via_paper
  end

  def deliver_mailing(mailer, rcpt, letterFile, attachment, letterArray, additionalMailerParams=nil)  
    if not rcpt.has_email? and @via_paper then
      result = deliver_letter(rcpt,letterFile)
      letterArray << letterFile
      Rails.logger.info("Created letter for #{rcpt.mglnr.to_s}: #{letterFile.orig_filename}")
      return result
    else 
      o_result = deliver_email(mailer, rcpt,letterFile,attachment, additionalMailerParams)
      if o_result[:success]!= true then
        Rails.logger.info("Mail delivery failed: "+rcpt.email)

        if @via_paper then
          result = deliver_letter(rcpt, letterFile)
          letterArray << letterFile
          Rails.logger.info("Created letter for #{rcpt.mglnr.to_s}: #{letterFile.orig_filename}")
          return result
        else
          return o_result
        end
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
 
  def recordMailSuccess(entity,subject,letterFile=nil)
    Rails.logger.debug("Mail success  : "+entity.class.name )
    Rails.logger.debug("Festival class: "+FestivalApplication.class.name)

    if ( entity.event_class.nil?) then
      Rails.logger.info("Event class is nil. Mail successfully sent to : #{entity.email}")
      return
    end

    event = entity.event_class.newEmail(@event_id,entity.id,subject)

    if not letterFile.nil? then
      event.filename=letterFile.relative_filename
    end

    event.save
  end

  def recordMailFailure(entity, result)

    if ( entity.event_class.nil?) then
      Rails.logger.info("Event class is nil. Mail sending failed.")
      return
    end

    event = entity.event_class.newEmail(@event_id,entity.id,result.to_s)
    event.save
  end

  def recordLetter(entity,subject,letterFile)

    if ( entity.event_class.nil?) then
      Rails.logger.info("Event class is nil. Letter success: #{entity.email}.")
      return
    end

    event = entity.event_class.newLetter(@event_id,entity.id,subject.to_s)
    if not letterFile.nil? then
  	  event.filename=letterFile.relative_filename
    end
    event.save

    { :success=>true, :mode => "L" ,:entity=>entity}
  end

  def deliver_letter(rcpt,letter)
    recordLetter(rcpt, @event_title, letter)
  end

  def deliver_email(mailer, rcpt, letter,attachment,additionalMailerParams)
    begin
      type = rcpt.class
      if not is_mail_blacklisted?(rcpt.email) then
        mailer.notify(rcpt.email, letter,attachment,additionalMailerParams).deliver
        recordMailSuccess(rcpt, @event_title,letter)
        result = { :success=>true, :mode => "E" ,:entity=>rcpt}
        return result
      else 
        recordMailFailure(rcpt,"blacklist")
        result = { :err=>"blacklisted", :entity=>rcpt,:type =>type, :mode => "E"}
        return result
       end
    rescue => e 
      recordMailFailure(rcpt,e.message)
       Rails.logger.warn e.backtrace.join("\n")
      return { :err=>e.message, :entity=>rcpt,:type =>type, :mode=> "E"}
    end
  end
end
