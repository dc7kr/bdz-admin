module BulkMailHelper

  def customize_letter(date_prefix, year, our_contact, rcpt, event_id, template)
    rel_path = nil 
    doc=nil
    filled_template = nil 

    doc = prepare_pdf(rcpt,our_contact,template.full_path)
    suffix=event_id+"_"+rcpt.mglnr.to_s

    filled_filename = date_prefix+suffix+".pdf"

    file = MailingFile.new(filled_filename, filled_filename, year.to_s)
    doc.render_file(file.full_path)

    return file
  end


  def prepare_pdf(rcpt,our_contact, att_file, print_date = true)
    doc = CompanyPaperDocument.new(att_file)
    doc.print_address(rcpt)
    if print_date then 
      doc.print_date(BDZ_SETTINGS["contacts"][our_contact]["ort"],Time.now)
    end

    doc
  end

  def store_pdf(date_prefix, year, suffix,doc)
    arch_dir = File.join(BDZ_SETTINGS['invoice_archive_dir'],year.to_s)
  end


  def send_admin_mail(letterFile,triggered_by,results)
    year = Time.now.strftime('%Y')
    pdf_prefix= Time.now.strftime '%Y%m%d'

    users = User.for_admin_notify

    base_url = cron_downloads_url
    letters_url = base_url+"?year="+year+"&filename="+letterFile.orig_filename
    dd_url=nil

    users.each do |user| 
		  AdminNotifier.new_custom_info_mail_notification(user, letters_url, results, triggered_by).deliver
   		logger.info 'sent to %s' % user.email
	  end
  end
end
