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

  def cleanup_notification(user, resigned_persons, resigned_orchestras)
    @recipient = user
    @resigned_persons = resigned_persons
    @resigned_orchestras = resigned_orchestras

    mail(to: user.email, subject: "[BDZDB] Automatische Austritte")
  end

  def invalid_member_notification(user, orch_invalid, em_invalid)
    @recipient = user
    @em_invalid = em_invalid
    @orch_invalid = orch_invalid
    mail(to: user.email, subject: "[BDZDB] Ungültige Mitgliedsdaten")
  end

  def em_tariff_fix_notification(user, digital, normal, changed, unchanged)
    @recipient = user
    @normal = normal
    @digital = digital
    @changed = changed
    @unchanged = unchanged
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

  def newinvoices_notification(recipient, invoices, sepa_file, current_user)
    @recipient = recipient
    @invoice_url = invoices
    @dd_url = sepa_file

    set_triggered_by(current_user)

    mail(to: recipient.email, subject: "BDZ Rechnungslauf")
  end

  def new_custom_info_mail_notification(recipient, letters_url, results, triggered_by)
    @recipient = recipient
    @results = results
    @letter_url = letters_url
    @triggered_by = triggered_by

    mail(to: recipient.email, subject: "Rundschreiben wurde erstellt")
  end

  def newreminders_notification(recipient, reminders, current_user)
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
    mail(to: current_user.email, subject: "[BDZDB] Test Notification")
  end

  def newdistinction_notification(invoice, sepa_file)
    @sepafile_url = sepa_file

    @is_direct_debit = invoice.customer.is_direct_debit?

    @invoice_number = invoice.number
    @mglnr = invoice.customer.customer_id
    user = nil
    if ENV["RAILS_ENV"] == "production"
      BDZ_SETTINGS["contacts"]["treasurer"]["name"]
      user = BDZ_SETTINGS["contacts"]["treasurer"]["mail"]
    else
      BDZ_SETTINGS["contacts"]["admin"]["name"]
      user = BDZ_SETTINGS["contacts"]["admin"]["mail"]
    end

    cc = BDZ_SETTINGS["contacts"]["admin"]["mail"]

    mail(to: user, cc: cc, subject: "Neue Ehrungsrechnung Nr. #{invnr}")
  end

  def generic_pdf_notification
    recipient = params[:recipient]
    p_attachment = MailingFile.from_hash(params[:attachment])

    @topic = params[:topic]

    attachments[p_attachment.orig_filename] = File.read(p_attachment.full_path)

    mail(to: recipient, subject: "PDF Erzeugung abgeschlossen: #{topic}")
  end

  private

  def set_triggered_by(current_user)
    @triggered_by = if current_user.nil?
                      "(System)"
    else
                      "#{current_user.name} (#{current_user.email})"
    end
  end
end
