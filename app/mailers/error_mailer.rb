class ErrorMailer < ActionMailer::Base
  default from: "karsten.richter@bdz-online.de"


  def deliver_snapshot( exception, env)
		@body = exception.to_s+"\n"+exception.backtrace.join("\n")

   		mail(:to => "webmaster@bdz-online.de", :subject => "Exception in "+env).deliver
  end
end
