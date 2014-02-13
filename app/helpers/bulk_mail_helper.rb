module BulkMailHelper

  def customize_letter(date_prefix, year, our_contact, rcpt, event_id, template)
    rel_path = nil 
    doc=nil
    filled_template = nil 

    doc = prepare_pdf(rcpt,our_contact,File.join(BDZ_SETTINGS["invoice_archive_dir"],template.filename))
    suffix=event_id+"_"+rcpt.mglnr.to_s

    filled_filename = date_prefix+suffix+".pdf"

    file = MailingFile.new(filled_filename, filled_filename, year.to_s)
    doc.render_file(file.full_path)

    return file
  end


  def prepare_pdf(rcpt,our_contact, att_file)
    doc = CompanyPaperDocument.new(att_file)
    doc.print_address(rcpt)
    doc.print_date(BDZ_SETTINGS["contacts"][our_contact]["ort"],Time.now)

    doc
  end

  def store_pdf(date_prefix, year, suffix,doc)
    arch_dir = File.join(BDZ_SETTINGS['invoice_archive_dir'],year.to_s)
  end
end
