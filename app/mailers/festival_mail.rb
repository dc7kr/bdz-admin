class FestivalMail < ApplicationMailer
  default from: "info@eurofestival-zupfmusik.de"

  def notify(recipient, personalized_file, attachment_file, params) 

    subject = params[:subject]
    @body = params[:body]

    storage_dir = DOCS_CONFIG.archive_dir

    if (personalized_file != nil ) then
      attachment_data = File.new(personalized_file.full_path).read
		  attachments[personalized_file.orig_filename ] = attachment_data
    end

    if (attachment_file != nil ) then
      attachment_data = File.new(attachment_file.full_path).read
		  attachments[attachment_file.orig_filename ] = attachment_data
    end

   	mail(:to => recipient, :subject => subject)
  end
end
