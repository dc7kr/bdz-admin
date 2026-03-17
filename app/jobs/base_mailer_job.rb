class BaseMailerJob < ApplicationJob

  protected 
  def send_admin_mail(letterFile, triggered_by_id, results)
    year = Time.zone.now.strftime("%Y")

    users = User.for_admin_notify

    base_url = cron_downloads_url

    letters_url = nil

    letters_url = "#{base_url}?year=#{year}&filename=#{letterFile.orig_filename}" unless letterFile.nil?

    users.each do |user|
      AdminNotifier.new_custom_info_mail_notification(user, letters_url, results, triggered_by_id: triggered_by_id).deliver
      logger.debug "sent to %s" % user.email
    end
  end

  def customize_letter(date_prefix, year, our_contact, addressee, event_id, template)
    return nil if template.nil?

    doc = prepare_pdf(addressee, our_contact, false)
    suffix = "#{event_id}_#{addressee.id}"

    tmpfile = Tempfile.new("ci_addr")

    doc.render_file(tmpfile)

    Rails.logger.info("Tempfile: #{tmpfile.path}")

    Tempfile.new("mb_stamped")

    filled_filename = "#{date_prefix}#{suffix}.pdf"
    file = MailingFile.new(filled_filename, filled_filename, year.to_s)

    Rails.logger.debug { "Output file: #{file.full_path}" }

    # this is the multipage case
    # result = PDF::Toolkit.pdftk(tmpfile.path, "background", template.full_path, "output", tmpfile2.path)
    # Rails.logger.debug("Result 1: #{result}")
    # result = PDF::Toolkit.pdftk("A="+tmpfile2.path, "B="+template.full_path, "cat", "A1", "B1", "output", file.full_path)
    # Rails.logger.debug("Result 2: #{result}")

    PDF::Toolkit.pdftk(tmpfile.path, "background", template.full_path, "output", file.full_path)

    file
  end
end
