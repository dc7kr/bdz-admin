class ErrorMailer < ActionMailer::Base
  default from: "bdzdb@bdz-online.de"


  def deliver_snapshot( exception, env, current_user)
		@body = exception.to_s+"\n"+exception.backtrace.join("\n")
      email = nil
      if (current_user) then
        email = current_user.email
      else 
        email = "bdzdb@bdz-online.de"
      end

      admin_mail = BDZ_SETTINGS['contacts']['admin']['mail']
   		mail(:to => admin_mail, :subject => "Exception in "+env,:from=>email).deliver
  end
end
