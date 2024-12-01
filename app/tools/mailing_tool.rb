class MailingTool

  def initialize(year, our_contact,event_id, event_title,via_paper=true)
    @year = year
    @our_contact = our_contact
    @event_title = event_title
    @event_id = event_id
    @via_paper = via_paper
  end

  # recipient is the derived class (Orchestra, PersonMember, RegionalOrganization)
  #
  # fields needed in addressee: id 
  #
  # diverts to deliver_letter in error case
  #
  def deliver_mailing(mailer, addressee, letterFile, attachment, letterArray, additionalMailerParams)  

    if not addressee.has_email? and @via_paper then
      result = deliver_letter(addressee,letterFile)
      letterArray << letterFile
      Rails.logger.info("Created letter for #{addressee.id}")
      return result
    else 
      o_result = deliver_email(mailer, addressee,letterFile,attachment, additionalMailerParams)
      if o_result[:success]!= true then
        Rails.logger.info("Mail delivery failed: #{addressee.id}")

        if @via_paper then
          result = deliver_letter(addressee, letterFile)
          letterArray << letterFile
          Rails.logger.info("Created letter for #{addressee.id}")
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

  # entity is either the superclass member or a similar object that supports calls to:
  # email, event_class, id
  def recordMailSuccess(addressee,subject,letterFile=nil)
    #Rails.logger.debug("Mail success  : "+addressee.class.name )
    #Rails.logger.debug("Festival class: "+FestivalApplication.class.name)

    if ( addressee.event_class.nil?) then
      Rails.logger.info("Event class is nil. Mail successfully sent to : #{addressee.email}")
      return
    end

    event = addressee.event_class.newEmail(@event_id,addressee.event_entity_id,subject)

    if not letterFile.nil? then
      event.filename=letterFile.relative_filename
    end

    event.save
  end

  def recordMailFailure(addressee, result)

    if addressee.event_class.nil? then
      Rails.logger.info("Event class is nil.")
      Rails.logger.warn("Mail sending failed: "+result)
      return
    end

    event = addressee.event_class.newEmail(@event_id,addressee.event_entity_id,result.to_s)
    event.save
  end

  def recordLetter(addressee,subject,letterFile)

    if addressee.event_class.nil? then
      Rails.logger.info("Event class is nil.")
      Rails.logger.info("Letter success: #{addressee.id}.")
      return
    end

    event = addressee.event_class.newLetter(@event_id,addressee.event_entity_id,subject.to_s)
    if not letterFile.nil? then
  	  event.filename=letterFile.relative_filename
    end
    event.save

    { :success=>true, :mode => "L" ,:entity=>addressee}
  end

  def deliver_letter(addressee,letter)
    recordLetter(addressee, @event_title, letter)
  end

  def deliver_email(mailer, addressee, letter,attachment,additionalMailerParams)
    begin
      type = addressee.entity.class
      if not is_mail_blacklisted?(addressee.email) then
        mailer.notify(addressee.email, letter,attachment,additionalMailerParams).deliver_later
        recordMailSuccess(addressee, @event_title,letter)
        result = { :success=>true, :mode => "E" ,:entity=>addressee}
        return result
      else 
        recordMailFailure(addressee,"blacklist")
        result = { :err=>"blacklisted", :entity=>addressee,:type =>type, :mode => "E"}
        return result
       end
    rescue => e 
      recordMailFailure(addressee,e.message)
       Rails.logger.warn e.backtrace.join("\n")
      return { :err=>e.message, :entity=>addressee,:type =>type, :mode=> "E"}
    end
  end
end
