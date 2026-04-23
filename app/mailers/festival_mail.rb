class FestivalMail < ApplicationMailer
  default from: BDZ_SETTINGS["config"]["festival_email"]

  def notify(recipient, personalized_hash, attachment_hash, params)
    subject = params[:subject]
    @body = params[:body]

    if not recipient.present? 
      Rails.logger.warn("Empty recipient, skipping mail.")
      return nil
    end

    personalized = MailingFile.from_hash(personalized_hash)
    attachment = MailingFile.from_hash(attachment_hash)

    unless personalized.nil?
      attachment_data = File.new(personalized.full_path).read
      attachments[personalized_file.orig_filename] = attachment_data
    end

    unless attachment.nil?
      attachment_data = File.new(attachment.full_path).read
      attachments[attachment.orig_filename] = attachment_data
    end

    mail(to: recipient, subject: subject)
  end
end
