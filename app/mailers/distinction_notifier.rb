class DistinctionNotifier < ApplicationMailer
  def new_distinction_notification(user, _invoices, dtaus)
    @recipient = user
    @dtaus_url = dtaus

    mail(from: contact_email("system"), to: user.email, subject: "Neue Ehrungsrechnung", bcc: invoice_out_bcc)
  end
end
