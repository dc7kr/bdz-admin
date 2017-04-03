module BulkMailHelper

  def customize_letter(date_prefix, year, our_contact, addressee, event_id, template)
    rel_path = nil 
    doc=nil
    filled_template = nil 

    if template.nil? then
      return nil
    end

    doc = prepare_pdf(addressee,our_contact,false)
    suffix=event_id+"_"+addressee.id.to_s

    tmpfile = Tempfile.new('ci_addr')

    doc.render_file(tmpfile)

    Rails.logger.info("Tempfile: "+tmpfile.path)

    tmpfile2 = Tempfile.new('mb_stamped')

    filled_filename = date_prefix+suffix+".pdf"
    file = MailingFile.new(filled_filename, filled_filename, year.to_s)

    Rails.logger.debug("Output file: #{file.full_path}")

    # this is the multipage case
    #result = PDF::Toolkit.pdftk(tmpfile.path, "background", template.full_path, "output", tmpfile2.path)
    #Rails.logger.debug("Result 1: #{result}")
    #result = PDF::Toolkit.pdftk("A="+tmpfile2.path, "B="+template.full_path, "cat", "A1", "B1", "output", file.full_path)
    #Rails.logger.debug("Result 2: #{result}")
    
    result = PDF::Toolkit.pdftk(tmpfile.path, "background", template.full_path, "output", file.full_path)

    return file
  end


  def prepare_pdf(addressee,our_contact, print_date = true)
    doc = CompanyPaperDocument.new
    doc.print_address(addressee)
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

    users = User.for_admin_notify

    base_url = cron_downloads_url

    letters_url = nil

    if not letterFile.nil? then 
      letters_url = base_url+"?year="+year+"&filename="+letterFile.orig_filename
    end
      
    dd_url=nil

    users.each do |user| 
		  AdminNotifier.new_custom_info_mail_notification(user, letters_url, results, triggered_by).deliver
   		logger.info 'sent to %s' % user.email
	  end
  end
end
