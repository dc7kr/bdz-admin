class CustomInfoMail < ActionMailer::Base
  default from: "geschaeftsstelle@bdz-online.de"


  def initialize
  end
  
  def prepare(subject,body)
    @subject= subject
    @body = body
  end

  def notify(recipient, letter, attachment, params) 

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

   	mail(:to => recipient, :subject => @subject)
  end
end
