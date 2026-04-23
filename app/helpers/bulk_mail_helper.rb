module BulkMailHelper
  def customize_letter(date_prefix, year, our_contact, addressee, event_id, template)
    return nil if template.nil?

    doc = prepare_pdf(addressee, our_contact, false)
    suffix = "#{event_id}_#{addressee.id}"

    tmpfile = Tempfile.new("ci_addr")

    doc.render_file(tmpfile)

    Rails.logger.info("Tempfile: #{tmpfile.path}")

    Tempfile.new("mb_stamped")

    filled_filename = "#{date_prefix}#{suffix}.pdf"
    file = MailingFile.new(filled_filename, filled_filename, year.to_s)

    Rails.logger.debug { "Output file: #{file.full_path}" }

    # this is the multipage case
    # result = PDF::Toolkit.pdftk(tmpfile.path, "background", template.full_path, "output", tmpfile2.path)
    # Rails.logger.debug("Result 1: #{result}")
    # result = PDF::Toolkit.pdftk("A="+tmpfile2.path, "B="+template.full_path, "cat", "A1", "B1", "output", file.full_path)
    # Rails.logger.debug("Result 2: #{result}")

    PDF::Toolkit.pdftk(tmpfile.path, "background", template.full_path, "output", file.full_path)

    file
  end

  def prepare_pdf(addressee, our_contact, print_date = true)
    doc = CompanyPaperDocument.new
    doc.print_address(addressee)
    doc.print_date(BDZ_SETTINGS["contacts"][our_contact]["ort"], Time.zone.now) if print_date

    doc
  end

  def store_pdf(_date_prefix, year, _suffix, _doc)
    File.join(DOCS_CONFIG.archive_dir, year.to_s)
  end

end
