class TestMail < ApplicationMailer

  def notify(recipient, email_params)
    dataFile = email_params[:datafile]

    attachments[dataFile.original_filename] = dataFile.read if dataFile
    @body = email_params[:body]

    mail(from: contact_email("system"), to: recipient, subject: email_params[:subject], cc: recipient)
  end
end
