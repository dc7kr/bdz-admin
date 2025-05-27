class InvoiceMailMailer < ApplicationMailer
  default from: "geschaeftsstelle@zupfmusiker.de"

  def notify(recipient, invoice_hash, _attachment_hash, params)
    year = params[:year]
    mglnr = params[:mglnr]

    invoice_file = MailingFile.from_hash(invoice_hash)

    subject = "BDZ-Beitragsrechnung #{year} Mglnr. #{mglnr}"

    INVOICE_CONFIG.archive_dir

    attachment_data = File.new(invoice_file.full_path).read
    attachments[invoice_file.orig_filename] = attachment_data

    @recipient = recipient

    @mglnr = mglnr

    mail(to: recipient, subject: subject)
  end
end
