class ErrorMailer < ActionMailer::Base
  default from: "karsten.richter@bdz-online.de"


  def deliver_snapshot( exception, env, current_user)
		@body = exception.to_s+"\n"+exception.backtrace.join("\n")
      email = nil
      if (current_user) then
        email = current_user.email
      else 
        email = "karsten.richter@bdz-online.de"
      end

   		mail(:to => "webmaster@bdz-online.de", :subject => "Exception in "+env,:from=>email).deliver
  end
end
