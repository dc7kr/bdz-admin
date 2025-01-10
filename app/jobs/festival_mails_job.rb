class FestivalMailsJob < ApplicationJob
  include BulkMailHelper
  include Rails.application.routes.url_helpers

  include PdfHelper
  include UploadHelper
  include FestivalMailsHelper

  def perform(_user_id, letterfile_hash, attachment_hash, subject, body_template, event_id, group, via_paper)
    successCount = 0
    failCount = 0

    letterfile = MailingFile.from_hash(letterfile_hash)
    attachment = MailingFile.from_hash(attachment_hash)

    cur_year = Time.now.year

    results = []

    fa = FileArchiveTool.new(DOCS_CONFIG)

    applicants = nil

    if group == 'FA'
      applicants = FestivalApplication.current_festival.includes(:contact_person)
    elsif group == 'FP'
      applicants = FestivalApplication.current_festival.includes(:contact_person).where(permission: true)
    elsif group == 'FR'
      applicants = FestivalApplication.current_festival.includes(:contact_person).where(permission: true,
                                                                                        visitor_type: 'R')
    elsif group == 'FS'
      applicants = FestivalApplication.current_festival.includes(:contact_person).where(permission: true,
                                                                                        visitor_type: 'V')
    elsif group == 'FJ'
      applicants = FestivalApplication.current_festival.includes(:contact_person).where(permission: true,
                                                                                        visitor_type: 'Y')
    elsif group == 'FG'
      applicants = FestivalApplication.current_festival.includes(:contact_person).where(permission: true,
                                                                                        visitor_type: 'G')
    elsif group == 'FO'
      applicants = FestivalApplication.current_festival.includes(:contact_person).where(permission: true,
                                                                                        visitor_type: 'O')
    else
      logger.error('NO GROUP identified: ' + group)
    end

    tool = MailingTool.new(cur_year.to_s, 'festival', event_id, subject, via_paper)

    letterArray = []

    applicants.each do |appl|
      appl.contact_person.to_addressee

      body = prepare_body(appl, body_template)
      logger.debug('Result: ' + body)
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
end
