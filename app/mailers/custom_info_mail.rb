class CustomInfoMail < ApplicationMailer
  default from: "geschaeftsstelle@zupfmusiker.de"

  def notify(recipient, letter, attachment, params) 

    @subject = params[:subject]
    @body = params[:body]

    if ( letter ) then
      letter_data = File.new(letter.full_path).read
		  attachments[letter.orig_filename ] = letter_data
    end

    if (attachment) then
      attachment_data = File.new(attachment.full_path).read
		  attachments[attachment.orig_filename ] = attachment_data
    else 
      Rails.logger.info("No additional attachment")
    end

    mail(:to => recipient, :subject => @subject)
  end
end
