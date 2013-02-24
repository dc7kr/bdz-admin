class AdminNotifier < ActionMailer::Base
  default from: "bdzdb@bdz-online.de"

  def new_report_sheet(user,rs)
	 @recipient = user
	 @rs=rs
     mail(:to => user.email, :subject => "Meldebogen-Eingabe "+rs.orchestra.mglnr.to_s)

  end
  def report_sheet_notification(user, doc_url, current_user)
	 @recipient = user
	 @docs_url = doc_url

	 @current_user = current_user 
	 mail(:to => user.email, :subject => "Meldebogen Anschreiben")
  end

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
  
  def newdistinction_notification(dtaus, invnr, is_direct_debit)
     @dtaus_url = dtaus
	 @is_direct_debit = is_direct_debit

	 @invoice_number = invnr

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
