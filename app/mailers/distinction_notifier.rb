class DistinctionNotifier < ApplicationMailer
  default from: "bdzdb@zupfmusiker.de"

  def newdistinction_notification(user, invoices, dtaus)
	 @recipient = user
     @dtaus_url = dtaus		 

	 mail(:to => user.email, :subject => "Neue Ehrungsrechnung")

  end
end
