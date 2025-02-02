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
  def deliver_mailing(mailer, addressee, letterFile, attachment, letterArray, additionalMailerParams)
    if !addressee.has_email? && @via_paper
      result = deliver_letter(addressee, letterFile)
      letterArray << letterFile
      Rails.logger.info("Created letter for #{addressee.id}")
      result
    else
      o_result = deliver_email(mailer, addressee, letterFile, attachment, additionalMailerParams)
      if o_result[:success] == true
        o_result
      else
        Rails.logger.info("Mail delivery failed: #{addressee.id}")

        if @via_paper
          result = deliver_letter(addressee, letterFile)
          letterArray << letterFile
          Rails.logger.info("Created letter for #{addressee.id}")
          result
        else
          o_result
        end
      end
    end
  end

  private

  def is_mail_blacklisted?(mail)
    mail.include?('aol.com')
  end

  # entity is either the superclass member or a similar object that supports calls to:
  # email, event_class, id
  def recordMailSuccess(addressee, subject, letterFile = nil)
    # Rails.logger.debug("Mail success  : "+addressee.class.name )
    # Rails.logger.debug("Festival class: "+FestivalApplication.class.name)

    if addressee.event_class.nil?
      Rails.logger.info("Event class is nil. Mail successfully sent to : #{addressee.email}")
      return
    end

    event = addressee.event_class.newEmail(@event_id, addressee.event_entity_id, subject)

    event.filename = letterFile.relative_filename unless letterFile.nil?

    event.save
  end

  def recordMailFailure(addressee, result)
    if addressee.event_class.nil?
      Rails.logger.info('Event class is nil.')
      Rails.logger.warn("Mail sending failed: #{result}")
      return
    end

    event = addressee.event_class.newEmail(@event_id, addressee.event_entity_id, result.to_s)
    event.save
  end

  def recordLetter(addressee, subject, letterFile)
    if addressee.event_class.nil?
      Rails.logger.info('Event class is nil.')
      Rails.logger.info("Letter success: #{addressee.id}.")
      return
    end

    event = addressee.event_class.newLetter(@event_id, addressee.event_entity_id, subject.to_s)
    event.filename = letterFile.relative_filename unless letterFile.nil?
    event.save

    { success: true, mode: 'L', entity: addressee }
  end

  def deliver_letter(addressee, letter)
    recordLetter(addressee, @event_title, letter)
  end

  def deliver_email(mailer, addressee, letter, attachment, additional_mailer_params)
    attachment_hash = nil
    letter_hash = nil

    letter_hash = letter.to_hash unless letter.nil?

    attachment_hash = attachment.to_hash unless attachment.nil?

    begin
      type = addressee.entity.class
      if is_mail_blacklisted?(addressee.email)
        recordMailFailure(addressee, 'blacklist')
        { err: 'blacklisted', entity: addressee, type: type, mode: 'E' }

      else
        mailer.notify(addressee.email, letter_hash, attachment_hash, additional_mailer_params).deliver_later
        recordMailSuccess(addressee, @event_title, letter)
        { success: true, mode: 'E', entity: addressee }

      end
    rescue StandardError => e
      # TODO: be more specific about the errors: Catch all is bad!
      recordMailFailure(addressee, e.message)
      Rails.logger.warn e.backtrace.join("\n")
      { err: e.message, entity: addressee, type: type, mode: 'E' }
    end
  end
end
