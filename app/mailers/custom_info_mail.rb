class CustomInfoMail < ApplicationMailer

  def notify(recipient, letter_hash, attachment_hash, params)
    @subject = params[:subject]
    @body = params[:body]

    letter = MailingFile.from_hash(letter_hash)
    attachment = MailingFile.from_hash(attachment_hash)

    if letter
      letter_data = File.new(letter.full_path).read
      attachments[letter.orig_filename] = letter_data
    end

    if attachment
      attachment_data = File.new(attachment.full_path).read
      attachments[attachment.orig_filename] = attachment_data
    else
      Rails.logger.info("No additional attachment")
    end

    mail(from: contact_email("gs"), to: recipient, subject: @subject)
  end
end
