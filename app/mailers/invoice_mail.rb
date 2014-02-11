class InvoiceMail < ActionMailer::Base
  default from: "geschaeftsstelle@bdz-online.de"

  def notify(recipient, invoice_file, attachment_file, params) 

    year = params[:year]
    mglnr = params[:mglnr]

    subject = "BDZ-Beitragsrechnung #{year} Mglnr. #{mglnr}"

    storage_dir = BDZ_SETTINGS["invoice_archive_dir"]

    attachment_data = File.new(File.join(storage_dir,invoice_file.filename)).read
		attachments[invoice_file.orig_filename ] = attachment_data

	  @recipient= recipient

    @mglnr = mglnr

   	mail(:to => recipient, :subject => subject)
  end
end
