require 'securerandom'

class ReportSheetMailingsJob < ApplicationJob
  sidekiq_options retry: false

  def perform(p_year, p_triggered_by)
    counters = {}

    counters[:skip] = 0
    counters[:orch] = 0
    counters[:orch_fail] = 0
    counters[:letter] = 0

    results = []

    letterArray = []

    now = Time.zone.now
    date_prefix = now.strftime '%Y%m%d'
    cur_year = now.strftime '%Y'

    event_id = "MB_#{p_year}"

    subject = "Meldebogen Anschreiben #{p_year}"

    tool = MailingTool.new(cur_year.to_s, 'gs', event_id, subject)

    fa = FileArchiveTool.new(DOCS_CONFIG)

    orchestras = if now.year == p_year
                   Orchestra.this_year
                 else
                   Orchestra.member_next_year
                 end

    orchestras.each do |orchestra|
      if orchestra.has_notify_event?(event_id)
        counters[:skip] += 1
      elsif !orchestra.report_sheet_required?
        Rails.logger.info("Skipping #{orchestra.member.mglnr} - no report sheet required")
      else
        rsi = ReportSheetInput.for_orchestra_and_year(orchestra, p_year)

        if rsi.nil?
          Rails.logger.error("Report sheet input is nil!: #{orchestra.member.mglnr}")
        else
          mailing_pdf = nil
          begin
            mailing_pdf = gen_anschreiben(orchestra, rsi)
          rescue DocumentGenerationException => e
            Rails.logger.error("Error generating PDF #{e.message}")
            counters[:orch_fail] += 1
            results << { success: false, mode: 'X', entity: orchestra }
            next
          rescue StandardError => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
            next
          end
          mailer_params = { rsi: rsi }
          result = tool.deliver_mailing(ReportSheetInputMailer, orchestra.to_addressee, mailing_pdf, nil,
                                        letterArray, mailer_params)

          results << result

          if result[:success] == true
            counters[:orch] += 1
          else
            counters[:orch_fail] += 1
          end
        end
      end
    end

    pdf_merged_file = nil
    doc_url = nil

    if letterArray.size.positive?
      pdf_filename = "#{date_prefix}#{event_id}_meldebogen_anschreiben.pdf"
      pdf_merged_file = MailingFile.new(pdf_filename, pdf_filename, cur_year)
      fa.merge_pdfs(letterArray, pdf_merged_file)
    end

    unless pdf_merged_file.nil?
      base_url = cron_downloads_url
      doc_url = "#{base_url}?year=#{cur_year}&filename=#{pdf_merged_file.orig_filename}"
    end

    users = User.for_admin_notify

    mailer_params = {}
    mailer_params[:counters] = counters
    mailer_params[:results] = results
    mailer_params[:pdf_url] = doc_url
    mailer_params[:triggered_by] = p_triggered_by

    users.each do |user|
      AdminNotifier.report_sheet_notification(user, mailer_params).deliver
      Rails.logger.debug 'sent to %s' % user.email
    end
  end

  def gen_anschreiben(orchestra, rsi)
    year = rsi.report_sheet.year
    url = BDZ_SETTINGS['meldebogen_url']

    mglnr = orchestra.member.mglnr
    anrede = orchestra.member.anrede

    member = orchestra.member

    dateprefix = Time.zone.now.strftime '%Y%m%d%H%M%S'

    filename = "#{dateprefix}_#{mglnr}_meldebogen_anschreiben.pdf"

    Rails.logger.info("Generate PDF: #{filename}")

    file = MailingFile.new('meldebogen_anschreiben.pdf', filename, Time.zone.now.strftime('%Y'))

    template_file = "#{DOCS_CONFIG.template_dir}/meldebogen_anschreiben.#{year}.template.pdf"

    anrede = if !anrede.nil? && anrede.length.positive?
               I18n.t("common.salutation_d.#{anrede}")
             else
               ''
             end

    workdir = DOCS_CONFIG.work_dir
    temp_name = "#{SecureRandom.hex}.pdf"
    stamped_name = "#{SecureRandom.hex}.pdf"

    temp_path = File.join(workdir, temp_name)
    stamped_path = File.join(workdir, stamped_name)

    Rails.logger.debug { "Stamping: temp file: #{temp_path} stamped: #{stamped_path}" }

    Prawn::Document.generate(temp_path, page_size: 'A4') do
      bounding_box([21, 340], width: 500, height: 50) do
        font 'Times-Roman'
        font_size 11
        text "Bitte melden Sie sich dazu unter #{url} mit Ihrer Mitgliedsnummer #{mglnr} und dem Passwort #{rsi.token} an.",
             align: :left
      end

      bounding_box([40, 650], width: 250, height: 100) do
        text orchestra.orchName
        text "#{anrede} #{member.vorname} #{member.name}"
        text member.strasse
        text ' '
        text "#{member.plz} #{member.ort}"
        text member.t_country if member.country_code != 'DE'
      end

      from = BDZ_SETTINGS['contacts']['gs']
      l_date = I18n.l Time.zone.now.to_date, format: :long
      bounding_box([370, 510], width: 200, height: 50) do
        text "#{from['city']}, #{l_date}"
      end

      if orchestra.is_direct_debit?
        bounding_box([21, 310], width: 500, height: 50) do
          text I18n.t('report_sheet_input.dd_to_sepa_valid', iban: member.iban, bic: member.bic, mref: member.mref)
        end

      end
    end

    retval = PDF::Toolkit.pdftk(temp_path, 'background', template_file, 'output', stamped_path)

    unless retval
      Rails.logger.error('Stamping failed')
      raise DocumentGenerationException, 'Error while stamping PDF'
    end

    retval = PDF::Toolkit.pdftk("A=#{stamped_path}", "B=#{template_file}", 'cat', 'A1', 'B2-2', 'output',
                                file.full_path)

    unless retval
      Rails.logger.error('PDF merge failed')
      raise DocumentGenerationException, 'Error re-merging PDFs'
    end

    File.unlink(stamped_path)
    File.unlink(temp_path)

    # return MailingFile instance
    file
  end
end
