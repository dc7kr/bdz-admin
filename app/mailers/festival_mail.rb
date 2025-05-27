class FestivalMail < ApplicationMailer
  default from: "info@eurofestival-zupfmusik.de"

  def notify(recipient, personalized_file, attachment_file, params)
    subject = params[:subject]
    @body = params[:body]

    DOCS_CONFIG.archive_dir

    unless personalized_file.nil?
      attachment_data = File.new(personalized_file.full_path).read
      attachments[personalized_file.orig_filename] = attachment_data
    end

    unless attachment_file.nil?
      attachment_data = File.new(attachment_file.full_path).read
      attachments[attachment_file.orig_filename] = attachment_data
    end

    mail(to: recipient, subject: subject)
  end
end
