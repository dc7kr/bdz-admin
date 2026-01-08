class MailingTool
  def initialize(year, our_contact, event_id, event_title, via_paper = true)
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
  def deliver_mailing(mailer, addressee, letter_file, attachment, letter_array, additional_mailer_params)
    if !addressee.has_email? && @via_paper
      result = deliver_letter(addressee, letter_file)
      letter_array << letter_file
      Rails.logger.info("Created letter for #{addressee.id}")
      result
    else
      o_result = deliver_email(mailer, addressee, letter_file, attachment, additional_mailer_params)
      if o_result[:success] == true
        o_result
      else
        Rails.logger.info("Mail delivery failed: #{addressee.id}")

        if @via_paper
          result = deliver_letter(addressee, letter_file)
          letter_array << letter_file
          Rails.logger.info("Created letter for #{addressee.id}")
          result
        else
          o_result
        end
      end
    end
  end

  private

  def mail_blacklisted?(mail)
    false
  end

  # entity is either the superclass member or a similar object that supports calls to:
  # email, event_class, id
  def record_mail_success(addressee, subject, letter_file = nil)
    # Rails.logger.debug("Mail success  : "+addressee.class.name )
    # Rails.logger.debug("Festival class: "+FestivalApplication.class.name)

    if addressee.event_class.nil?
      Rails.logger.info("Event class is nil. Mail successfully sent to : #{addressee.email}")
      return
    end

    event = addressee.event_class.new_email(@event_id, addressee.event_entity_id, subject)

    event.filename = letter_file.relative_filename unless letter_file.nil?

    event.save
  end

  def record_mail_failure(addressee, result)
    if addressee.event_class.nil?
      Rails.logger.info("Event class is nil.")
      Rails.logger.warn("Mail sending failed: #{result}")
      return
    end

    event = addressee.event_class.new_email(@event_id, addressee.event_entity_id, result.to_s)
    event.save
  end

  def record_letter(addressee, subject, letter_file)
    if addressee.event_class.nil?
      Rails.logger.info("Event class is nil.")
      Rails.logger.info("Letter success: #{addressee.id}.")
      return
    end

    event = addressee.event_class.new_letter(@event_id, addressee.event_entity_id, subject.to_s)
    event.filename = letter_file.relative_filename unless letter_file.nil?
    event.save

    { success: true, mode: "L", entity: addressee }
  end

  def deliver_letter(addressee, letter)
    record_letter(addressee, @event_title, letter)
  end

  def deliver_email(mailer, addressee, letter, attachment, additional_mailer_params)
    attachment_hash = nil
    letter_hash = nil

    letter_hash = letter.to_hash unless letter.nil?

    attachment_hash = attachment.to_hash unless attachment.nil?

    begin
      type = addressee.entity.class
      if mail_blacklisted?(addressee.email)
        record_mail_failure(addressee, "blacklist")
        { err: "blacklisted", entity: addressee, type: type, mode: "E" }

      else
        # to correctly record failed mails we have to use deliver_now ...
        mailer.notify(addressee.email, letter_hash, attachment_hash, additional_mailer_params).deliver_now
        record_mail_success(addressee, @event_title, letter)
        { success: true, mode: "E", entity: addressee }

      end
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      record_mail_failure(addressee, e.message)
      Rails.logger.warn e.backtrace.join("\n")
      { err: e.message, entity: addressee, type: type, mode: "E" }
    end
  end
end
