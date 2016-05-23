class AdminNotifier < ActionMailer::Base
  default from: "bdzdb@bdz-online.de"

  def new_report_sheet(user,rs)
	  @recipient = user
	  @rs=rs
    mail(:to => user.email, :subject => "Meldebogen-Eingabe "+rs.orchestra.member.mglnr.to_s)

  end
  def report_sheet_notification(user, doc_url, current_user)
	 @recipient = user
	 @docs_url = doc_url

	 @current_user = current_user 
	 mail(:to => user.email, :subject => "Meldebogen Anschreiben")
  end

  def newinvoices_notification(user, invoices, sepafile, current_user)
	 @recipient = user
	 @invoice_url = invoices
   @dd_url = sepafile		 

	 @current_user = current_user 
	 mail(:to => user.email, :subject => "BDZ Rechnungslauf")

  end

  def new_custom_info_mail_notification(user, letters_url, results, triggered_by)
    @results = results
    @letterUrl = letters_url
    @triggeredBy = triggered_by

    mail(:to => user.email, :subject => "Rundschreiben wurde erstellt")
  end
  
  def newreminders_notification(user, reminders, current_user)
	 @recipient = user
	 @reminders_url = reminders

	 @current_user = current_user 
	 mail(:to => user.email, :subject => "BDZ Mahnungslauf")
  end
  
  def new_lv_ct_notification(user, sepafile, current_user)
    @recipient = user
    @sepafile_url = sepafile		 

    @current_user = current_user 
    mail(:to => user.email, :subject => "BDZ LV Beitragsanteile SEPA CT")
  end
  
  def newdistinction_notification(sepafile, invnr, customer)
    @sepafile_url = sepafile
	  @is_direct_debit = customer.is_direct_debit?

	  @invoice_number = invnr
	  @mglnr = customer.id

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
