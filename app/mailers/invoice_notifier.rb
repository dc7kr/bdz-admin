class InvoiceNotifier < ActionMailer::Base
  default from: "bdzdb@bdz-online.de"

  def newinvoices_notification(user, invoices, dtaus)
	 @recipient = user
	 @invoice_url = invoices
     @dtaus_url = dtaus		 

	 mail(:to => user.email, :subject => "BDZ Rechnungslauf")

  end
end
