class FestivalMailsJob < ApplicationJob
  include BulkMailHelper
  include Rails.application.routes.url_helpers

  include PdfHelper
  include UploadHelper
  include FestivalMailsHelper


  def perform(_user_id, mail_params)
    successCount = 0
    failCount = 0

    letterfile = MailingFile.from_hash(letterfile_hash)
    attachment = MailingFile.from_hash(mail_params[:datafile])

    cur_year = Time.zone.now.year

    results = []

    fa = FileArchiveTool.new(DOCS_CONFIG)

    applicants = nil

    case group
    when "FA"
      applicants = FestivalApplication.current_with_contacts
    when "FP"
      applicants = FestivalApplication.current_with_contacts.where(permission: true)
    when "FR"
      applicants = FestivalApplication.current_with_contacts.where(permission: true, visitor_type: "R")
    when "FS"
      applicants = FestivalApplication.current_with_contacts.where(permission: true, visitor_type: "V")
    when "FJ"
      applicants = FestivalApplication.current_with_contacts.where(permission: true, visitor_type: "Y")
    when "FG"
      applicants = FestivalApplication.current_with_contacts.where(permission: true, visitor_type: "G")
    when "FO"
      applicants = FestivalApplication.current_with_contacts.where(permission: true, visitor_type: "O")
    else
      logger.error("NO GROUP identified: #{group}")
    end

    tool = MailingTool.new(cur_year.to_s, "festival", event_id, subject, via_paper)

    letterArray = []

    applicants.each do |appl|
      appl.contact_person.to_addressee

      body = prepare_body(appl, body_template)
      logger.debug("Result: #{body}")
      mailer_params = { body: body, subject: subject }

      result = tool.deliver_mailing(FestivalMail, appl.contact_person.to_addressee, nil, letterfile, letterArray,
                                    mailer_params)
      results << result

      if result[:success] == true
        successCount += 1
      else
        failCount += 1
      end
    end

    if via_paper
      pdf_filename = "#{date_prefix}#{event_id}_letters.pdf"
      pdf_merged_file = MailingFile.new(pdf_filename, pdf_filename, attachment.archive_folder)
      fa.merge_pdfs(letterArray, pdf_merged_file)
    end

    send_admin_mail(pdf_merged_file, triggered_by, results)
  end

  private
  def replace_body(orig_body, subst)
    body = orig_body
    subst.each do |s|
      # logger.debug("Subst-Pattern:"+s[0])
      body = body.gsub(s[0], s[1])
    end

    body
  end

  def prepare_body(appl, body)
    @festival_concert = appl.festival_concert

    substitutes = {
      "%id%" => appl.id.to_s,
      "%teilnehmer_name%" => appl.orch_name
    }

    substitutes["%probenzeit%"] = appl.rehearsal_time.to_s unless appl.rehearsal_time.nil?

    unless @festival_concert.nil?
      substitutes["%konzert%"] = @festival_concert.label.to_s
      substitutes["%konzert_zeit%"] = I18n.l(@festival_concert.event_time)
      substitutes["%konzert_ort%"] = @festival_concert.location
    end

    replace_body(body, substitutes)
  end
end
