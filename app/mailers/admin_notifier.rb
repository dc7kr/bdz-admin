class AdminNotifier < ApplicationMailer
  def gen_rsi_notification(args)
    @year = args[0]
    @user_id = args[1]

    if !@user_id.nil?
      @user = User.find(user_id)
      mail(to: user.email, subject: "[BDZDB] Meldebogen Eingabe Objekte wurden erzeugt.")
    else
      # bulk job
    end
  end

  def template_missing_notification(user, template_file, job_class)
    @job_class = job_class
    @template = template_file
    mail(to: user.email, subject: "[BDZDB] Job Fehler: #{job_class}")
  end

  def cleanup_notification(user, resigned_persons, resigned_orchestras)
    @recipient = user
    @resigned_persons = resigned_persons
    @resigned_orchestras = resigned_orchestras

    mail(to: user.email, subject: "[BDZDB] Automatische Austritte", from: system_from)
  end

  def invalid_member_notification(user, orch_invalid, em_invalid)
    @recipient = user
    @em_invalid = em_invalid
    @orch_invalid = orch_invalid
    mail(to: user.email, subject: "[BDZDB] Ungültige Mitgliedsdaten", from: system_from)
  end

  def em_tariff_fix_notification(user, changes)
    @changes = changes
    @recipient = user
    mail(to: user.email, subject: "[BDZDB] EM Tarifanpassung")
  end

  def invoice_update(user, invoice, invoice_file, sepa_file, delta_amount, report_sheet)
    @recipient = user
    @invoice = invoice
    @delta_amount = delta_amount
    @report_sheet = report_sheet

    @sepa_file = sepa_file

    unless @sepa_file.nil?
      attachment_data = File.new(sepa_file.full_path).read
      attachments[sepa_file.orig_filename] = attachment_data
    end

    invoice_data = File.new(invoice_file.full_path).read
    attachments[invoice_file.orig_filename] = invoice_data

    mail(to: user.email, subject: "Rechnungs-Korrektur Mgl-Nr. #{invoice.customer.customer_id}")
  end

  def new_report_sheet(user, rs)
    @recipient = user
    @rs = rs
    mail(to: user.email, subject: "Meldebogen-Eingabe #{rs.orchestra.member.mglnr}")
  end

  def report_sheet_notification(user, params)
    @recipient = user
    @params = params
    mail(to: user.email, subject: "Meldebogen Anschreiben")
  end

  def single_invoice(recipient, invoice_url, sepa_url:nil, sepa_invoices_url:nil, triggered_by:, mglnr:, letter:false)
    @recipient = recipient
    @invoice_url = invoice_url
    @sepa_url = sepa_url
    @sepa_invoices_url = sepa_invoices_url
    @mglnr = mglnr

    set_triggered_by(triggered_by)

    mail(to: recipient.email, subject: "Neue Beitragsrechnung #{mglnr}")
  end


  def new_invoices(recipient, invoices_url, sepa_url:nil, sepa_invoices_url:nil, triggered_by:)
    @recipient = recipient
    @invoices_url = invoices_url
    @sepa_url = sepa_url
    @sepa_invoices_url = sepa_invoices_url

    set_triggered_by(triggered_by)

    mail(to: recipient.email, subject: "BDZ Rechnungslauf")
  end

  def new_custom_info_mail_notification(recipient, letters_url, results, triggered_by)
    @recipient = recipient
    @results = results
    @letter_url = letters_url

    set_triggered_by(triggered_by)

    mail(to: recipient.email, subject: "Rundschreiben wurde erstellt")
  end

  def new_reminders_notification(recipient, reminders, current_user)
    @recipient = recipient
    @reminders_url = reminders

    @current_user = current_user
    mail(to: recipient.email, subject: "BDZ Mahnungslauf")
  end

  def new_lv_ct_notification(recipient, sepa_file, current_user)
    @recipient = recipient
    @sepafile_url = sepa_file

    @current_user = current_user
    mail(to: recipient.email, subject: "BDZ LV Beitragsanteile SEPA CT")
  end

  def test_notification(current_user)
    current_user_addr = email_address_with_name(current_user.email, current_user.name)

    adm = contact_email("admin")
    from = system_from

    mail(to: current_user_addr, subject: "[BDZDB] Test Notification", from:  from, bcc: adm)
  end

  def new_distinction_notification(triggered_by, invoice)
    @direct_debit = invoice.customer.direct_debit?

    @invoice_number = invoice.full_number
    @mglnr = invoice.customer.customer_id

    sepa_file = invoice.gen_sepa_file
    invoice_file = invoice.gen_pdf

    @sepa_dl_url = get_download_url(sepa_file)

    treasurer_to = contact_email_with_name("treasurer")
    admin_cc = contact_email("admin")
    user_to = triggered_by.email

    unless sepa_file.nil?
      attachment_data = File.new(sepa_file.full_path).read
      attachments[sepa_file.orig_filename] = attachment_data
    end

    invoice_data = File.new(invoice_file.full_path).read
    attachments[invoice_file.orig_filename] = invoice_data

    Rails.logger.info("Sending notify to #{treasurer_to} cc: #{admin_cc}")
    @name = contact_name("treasurer")
    mail(to: treasurer_to, cc: admin_cc, subject: "Neue Ehrungsrechnung Nr. #{@invoice_number}", from: system_from).deliver

    @name =  triggered_by.name
    Rails.logger.info("Sending notify to #{user_to}")
    mail(to: user_to, subject: "Neue Ehrungsrechnung Nr. #{@invoice_number}", from: system_from).deliver
  end

  def generic_pdf_notification
    recipient = params[:recipient]
    p_attachment = MailingFile.from_hash(params[:attachment])

    @topic = params[:topic]

    attachments[p_attachment.orig_filename] = File.read(p_attachment.full_path)

    mail(to: recipient, subject: "PDF Erzeugung abgeschlossen: #{topic}", from: system_from)
  end

  private

end
