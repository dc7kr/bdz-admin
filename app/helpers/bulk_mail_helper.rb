module BulkMailHelper

  def customize_letter(date_prefix, year, our_contact, rcpt, event_id, template)
    rel_path = nil 
    doc=nil
    filled_template = nil 

    doc = prepare_pdf(rcpt,our_contact,File.join(BDZ_SETTINGS["invoice_archive_dir"],template.filename))
    suffix=event_id+"_"+rcpt.mglnr.to_s
    rel_path = store_pdf(datePrefix, year, suffix, doc)

    MailingFile.new(rel_path,template.filename)
  end


  def prepare_pdf(rcpt,our_contact, att_file)
    doc = CompanyPaperDocument.new(att_file)
    doc.print_address(rcpt)
    doc.print_date(BDZ_SETTINGS["contacts"][our_contact]["ort"],Time.now)

    doc
  end

  def store_pdf(date_prefix, year, suffix,doc)
    year = Time.now.year.to_s
    arch_dir = path = File.join(BDZ_SETTINGS['invoice_archive_dir'],year)

    filename = date_prefix+suffix+".pdf"
    filled_template_file = File.join(arch_dir,filename)

    doc.render_file(filled_template_file)
    
    return File.join(year,filename)
  end
end
