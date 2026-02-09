class DownloadsController < AuthenticatedController
  def show
      authorize :download

      file_name = "#{params[:filename]}.#{params[:format]}"

      full_path = File.join(DOCS_CONFIG.archive_dir, params[:year],file_name)

      Rails.logger.info(full_path)

      if File.exist?(full_path)
        send_file(full_path, filename: file_name, type: "application/octet-stream")
      else
        render "errors/404", content_type: "text/html", layout: false, status: :not_found
      end
  end

  def combined_letters_pdf
    authorize :download
    invoices = CorikaInvoices::Invoice.where(generator_session_id: params["generator_session_id"])

    # TODO: invoice_ids = invoices.to_a.map { |i| i.id.to_s } 

    if invoices.count == 0 
      render status :not_found
    else 
      combined_file = combined_invoice_pdf(invoices, mode: :letter)
      send_data combined_file.to_pdf, filename: "combined.pdf", type: "application/pdf"
    end
  end

  def combined_sepa_pdf
    authorize :download
    generator_session_id =  params["generator_session_id"] 
    invoices = CorikaInvoices::Invoice.where(generator_session_id: generator_session_id)

    if invoices.count == 0 
      render status :not_found
    else 
      combined_file = combined_invoice_pdf(invoices, mode: :sepa)
      send_data combined_file.to_pdf, filename: "#{generator_session_id}_sepa_invoices.pdf", type: "application/pdf"
    end
  end

  def combined_sepa_xml
    authorize :download

    session_id = params[:generator_session_id]

    invoices = CorikaInvoices::Invoice.where(generator_session_id: params["generator_session_id"])

    date_prefix = Time.zone.now.strftime "%Y%m%d%H%M%S"

    sepa_writer = CorikaInvoices::SepaWriter.new(date_prefix, INVOICE_CONFIG)

    bookings = 0 

    invoices.each do |invoice|
      if invoice.gen_sepa_booking(sepa_writer)
        bookings+=1
      end

    end 

    if bookings > 0 
      sepa_xml = sepa_writer.generate_xml

      send_data sepa_xml, filename: "#{session_id}.sepa.xml", type: "application/octet-stream"
    else
      render  status: :not_found
    end

  end

  private 
  def combined_invoice_pdf(invoices, mode: :sepa)
    combined_file = CombinePDF.new

    invoices.each do |inv|
      filename = inv.pdf_filename
      year = inv.booking_year

      if inv.pdf_filename.nil? 
        Rails.logger.warn("Filename is nil: #{inv.full_number}")
      else
        select = false
        if mode == :sepa
          select = inv.customer.direct_debit?
        else
          select = true
        end

        if select
          full_path = File.join(INVOICE_CONFIG.archive_dir, year.to_s, filename)
          combined_file << CombinePDF.load(full_path, allow_optional_content: true)
        end
      end
    end

    combined_file
  end
end
