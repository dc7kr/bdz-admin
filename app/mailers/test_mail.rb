class TestMail < ApplicationMailer
  default from: "karsten.richter@zupfmusiker.de"

  def notify(recipient,email_params)
	dataFile = email_params[:datafile]

	if ( dataFile) then
		attachments[dataFile.original_filename] = dataFile.read
    end
	@body = email_params[:body]

   	mail(:to => recipient, :subject => email_params[:subject])
  end
end
