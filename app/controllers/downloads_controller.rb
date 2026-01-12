class DownloadsController < AuthenticatedController
  def show
      authorize Orchestra, :index

      file_name = "#{params[:filename]}.#{params[:format]}"

      full_path = File.join(DOCS_CONFIG.archive_dir, params[:year],file_name)

      Rails.logger.info(full_path)

      if File.exist?(full_path)
        send_file(full_path, filename: file_name, type: "application/octet-stream")
      else
        render "errors/404", content_type: "text/html", layout: false, status: :not_found
      end
  end

  def combined_invoice_pdf
    combined_file = CombinePDF.new
    invoices = CorikaInvoices::Invoice.where(generator_session_id: params["generator_session_id"])

    invoices.each do |inv|
      filename = inv.pdf_filename
      year = inv.booking_year

      if inv.pdf_filename.nil? 
        Rails.logger.warn("Filename is nil: #{inv.full_number}")
      else
        full_path = File.join(INVOICE_CONFIG.archive_dir, year.to_s, filename)
        combined_file << CombinePDF.load(full_path, allow_optional_content: true)
      end
    end

    #attachments.each { |att| combined_file << CombinePDF.load(att, allow_optional_content: true) }

    send_data combined_file.to_pdf, filename: "combined.pdf", type: "application/pdf"
  end
end
