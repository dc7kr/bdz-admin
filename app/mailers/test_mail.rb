class TestMailMailer < ApplicationMailer
  default from: "karsten.richter@zupfmusiker.de"

  def notify(recipient, email_params)
    dataFile = email_params[:datafile]

    attachments[dataFile.original_filename] = dataFile.read if dataFile
    @body = email_params[:body]

    mail(to: recipient, subject: email_params[:subject])
  end
end
