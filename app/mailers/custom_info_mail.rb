class CustomInfoMail < ActionMailer::Base
  default from: "geschaeftsstelle@bdz-online.de"

  def notify(recipient, subject, body, letter, attachment) 

    storage_dir = BDZ_SETTINGS["invoice_archive_dir"]

	  if ( letter ) then
      letter_data = File.new(File.join(storage_dir,letter.filename)).read
		  attachments["Anschreiben.pdf" ] = letter_data
    end

    if (attachment) then
      attachment_data = File.new(File.join(storage_dir,attachment.filename)).read
		  attachments[attachment.orig_filename ] = attachment_data
    else 
      Rails.logger.info("No additional attachment")
    end

	  @body = body

   	mail(:to => recipient, :subject => subject)
  end
end
