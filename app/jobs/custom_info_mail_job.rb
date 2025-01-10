class CustomInfoMailJob < ApplicationJob
  include Rails.application.routes.url_helpers

  include PdfHelper
  include BulkMailHelper
  include UploadHelper

  def default_url_options
    {
      host: ActionMailer::Base.default_url_options[:host],
      protocol: ActionMailer::Base.default_url_options[:protocol]
    }
  end

  def perform(user_id, letterfile_hash, attachment_hash, subject, body, event_id, grp, via_paper)
    fa = FileArchiveTool.new(DOCS_CONFIG)

    triggered_by = User.find(user_id)

    letterfile = MailingFile.from_hash(letterfile_hash)
    attachment = MailingFile.from_hash(attachment_hash)

    Time.now.strftime '%Y%m%d_'

    orchestra = false
    em = false
    test = false

    if grp == 'A'
      orchestra = true
      em = true
    elsif grp == 'O'
      orchestra = true
    elsif grp == 'E'
      em = true
    elsif grp == 'T'
      test = true
    elsif grp == 'F'
      true
    end

    cur_year = Time.now.year
    date_prefix = Time.now.strftime('%Y%d%m%H%M_')
    results = []

    tool = MailingTool.new(cur_year.to_s, 'gs', event_id, subject)

    letterArray = []

    mailer_params = { subject: subject, body: body }

    if orchestra
      orchestras = Orchestra.mailForEvent(event_id, via_paper)

      orchestras.each do |orchestra|
        addr = orchestra.to_addressee
        Rails.logger.debug { "Generating for: #{addr.id}" }
        filled_template = customize_letter(date_prefix, cur_year.to_s, 'gs', addr, event_id, letterfile)
        o_result = tool.deliver_mailing(CustomInfoMail, addr, filled_template, attachment, letterArray, mailer_params)
        results.push(o_result)
      end
    end
    if test
      addrs = []

      addrs << Addressee.dummy_for_mail
      addrs << Addressee.dummy_for_letter

      addrs.each do |addr|
        filled_template = customize_letter(date_prefix, cur_year.to_s, 'gs', addr, event_id, letterfile)
        o_result = tool.deliver_mailing(CustomInfoMail, addr, filled_template, attachment, letterArray, mailer_params)
        results.push(o_result)
      end
    end

    if em
      persons = PersonMember.mailForEvent(event_id, via_paper)

      persons.each do |person|
        addr = person.to_addressee

        Rails.logger.debug { "Generating for: EM #{addr.id}" }
        filled_template = customize_letter(date_prefix, cur_year.to_s, 'gs', addr, event_id, letterfile)
        o_result = tool.deliver_mailing(CustomInfoMail, addr, filled_template, attachment, letterArray, mailer_params)
        results.push(o_result)
      end
    end

    if via_paper
      pdf_filename = "#{date_prefix}#{event_id}_letters.pdf"
      pdf_merged_file = MailingFile.new(pdf_filename, pdf_filename)
      fa.merge_pdfs(letterArray, pdf_merged_file)
    end

    send_admin_mail(pdf_merged_file, triggered_by, results)
  end
end
