module DownloadsHelper

  def invoice_pdf_download_path(invoice)
    return unless invoice.present? and invoice.pdf_filename.present?

    pdf_file = invoice.get_invoice_file

    archive_file_download_path(pdf_file)
  end

  def invoice_sepa_download_path(invoice)
    return unless invoice.present? and invoice.sepa_filename.present?

    # TODO: refactor invoice to provide get_sepa_file
    sepa_file = invoice.gen_sepa_file

    archive_file_download_path(sepa_file)
  end

  def archive_file_download_path(archive_file)
    dl_path(archive_file.archive_folder, archive_file.orig_filename)
  end
end
