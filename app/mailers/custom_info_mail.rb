class CustomInfoMail < ActionMailer::Base
  default from: "geschaeftsstelle@bdz-online.de"

  def notify(recipient,email_params,attach_filename, attach_data)

	  if ( attach_data) then
		  attachments[attach_filename] = attach_data
    end
	  @body = email_params[:body]

   	mail(:to => recipient, :subject => email_params[:subject])
  end
end
