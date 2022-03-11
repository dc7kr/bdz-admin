class AdminNotifier < ActionMailer::Base
  default from: "bdzdb@bdz-online.de"

  def cleanup_notification(user, resigned_persons, resigned_orchestras)
    @recipient = user
    @resigned_persons = resigned_persons
    @resigned_orchestras= resigned_orchestras

    mail(:to => user.email, :subject => "[BDZDB] Automatische Austritte")
  end

  def invalid_member_notification(user,orch_invalid,em_invalid)
    @recipient = user
    @em_invalid = em_invalid
    @orch_invalid = orch_invalid
    mail(:to => user.email, :subject => "[BDZDB] Ungültige Mitgliedsdaten")
  end

  def em_tariff_fix_notification(user, digital, normal, changed, unchanged)
    @recipient = user
    @normal = normal
    @digital = digital 
    @changed = changed
    @unchanged = unchanged
    mail(:to => user.email, :subject => "[BDZDB] EM Tarifanpassung")
  end

  def invoice_update(user, invoice, invoice_file, sepa_file, delta_amount, report_sheet)
    @recipient = user
    @invoice = invoice
    @delta_amount = delta_amount
    @report_sheet = report_sheet

    @sepa_file = sepa_file

    if not @sepa_file.nil? then
      attachment_data = File.new(sepa_file.full_path).read
		  attachments[sepa_file.orig_filename ] = attachment_data
    end

    invoice_data = File.new(invoice_file.full_path).read
		attachments[invoice_file.orig_filename ] = invoice_data

    mail(:to => user.email, :subject => "Rechnungs-Korrektur Mgl-Nr. "+invoice.customer.customer_id)
  end

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

  def newinvoices_notification(user, invoices, sepa_file, current_user)
	 @recipient = user
	 @invoice_url = invoices
   @dd_url = sepa_file		 

	 @current_user = current_user 
	 mail(:to => user.email, :subject => "BDZ Rechnungslauf")

  end

  def new_custom_info_mail_notification(user, letters_url, results, triggered_by)
    @recipient = user
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
  
  def new_lv_ct_notification(user, sepa_file, current_user)
    @recipient = user
    @sepafile_url = sepa_file		 

    @current_user = current_user 
    mail(:to => user.email, :subject => "BDZ LV Beitragsanteile SEPA CT")
  end
  
  def newdistinction_notification(invoice,sepa_file)
    @sepafile_url = sepa_file

	  @is_direct_debit = invoice.customer.is_direct_debit?

	  @invoice_number = invoice.number
	  @mglnr = invoice.customer.customer_id

    name = nil
    user= nil
    if ENV["RAILS_ENV"] == "production" 
      name = BDZ_SETTINGS['contacts']['treasurer']['name']
      user =	BDZ_SETTINGS['contacts']['treasurer']['mail'] 
    else
      name = BDZ_SETTINGS['contacts']['admin']['name']
      user = BDZ_SETTINGS['contacts']['admin']['mail']
    end
    
    cc = BDZ_SETTINGS['contacts']['admin']['mail']

    mail(:to => user, :cc => cc, :subject => "Neue Ehrungsrechnung Nr. "+invnr);
  end
end
