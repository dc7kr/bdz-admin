class DistinctionNotifier < ActionMailer::Base
  default from: "bdzdb@bdz-online.de"

  def newdistinction_notification(user, invoices, dtaus)
	 @recipient = user
     @dtaus_url = dtaus		 

	 mail(:to => user.email, :subject => "Neue Ehrungsrechnung")

  end
end
