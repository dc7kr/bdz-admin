class InvoiceMail < ApplicationMailer

  def notify(recipient, invoice_file, attachment_file, params) 

    year = params[:year]
    mglnr = params[:mglnr]

    subject = "BDZ-Beitragsrechnung #{year} Mglnr. #{mglnr}"

    storage_dir = INVOICE_CONFIG.archive_dir

    attachment_data = File.new(invoice_file.full_path).read
		attachments[invoice_file.orig_filename ] = attachment_data

	  @recipient= recipient

    @mglnr = mglnr

   	mail(:to => recipient, :subject => subject)
  end
end
