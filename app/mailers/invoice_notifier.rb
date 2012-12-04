class InvoiceNotifier < ActionMailer::Base
  default from: "bdzdb@bdz-online.de"

  def newinvoices_notification(user, invoices, dtaus, current_user)
	 @recipient = user
	 @invoice_url = invoices
     @dtaus_url = dtaus		 

	 @current_user = current_user 
	 mail(:to => user.email, :subject => "BDZ Rechnungslauf")

  end
  
  def new_lv_dtaus_notification(user, dtaus, current_user)
	 @recipient = user
     @dtaus_url = dtaus		 

	 @current_user = current_user 
	 mail(:to => user.email, :subject => "BDZ LV Beitragsanteile DTAUS")
  end
  
  def newdistinction_notification(dtaus, invnr)
     @dtaus_url = dtaus		 

	if ENV["RAILS_ENV"] == "production" 
		@name = BDZ_SETTINGS['contacts']['treasurer']['name']
 		@user =	BDZ_SETTINGS['contacts']['treasurer']['mail'] 
	else
		@name = BDZ_SETTINGS['contacts']['admin']['name']
		@user = BDZ_SETTINGS['contacts']['admin']['mail']
	end
	
	@cc = BDZ_SETTINGS['contacts']['admin']['mail']

	mail(:to => @user, :cc => @cc, :subject => "Neue Ehrungsrechnung Nr. "+invnr);

  end
end
