class ApplicationMailer < ActionMailer::Base
  default from: BDZ_SETTINGS["contacts"]["system"]["email"]
  layout "mailer"

  attr_accessor :triggered_by

  def get_download_url(archive_file)
    Rails.application.routes.url_helpers.dl_url(year: archive_file.archive_folder, filename: archive_file.orig_filename)
  end

  def contact_email_with_name(key)
    if not BDZ_SETTINGS["contacts"].key?(key)
      return nil
    end

    contact_hash = BDZ_SETTINGS["contacts"][key]

    email_address_with_name(contact_hash["email"], contact_hash["name"])
  end

  def contact_name(key)
    if not BDZ_SETTINGS["contacts"].key?(key)
      return nil
    end

    contact_hash = BDZ_SETTINGS["contacts"][key]

    contact_hash["name"]
  end

  def contact_email(key)
    if not BDZ_SETTINGS["contacts"].key?(key)
      return nil
    end

    contact_hash = BDZ_SETTINGS["contacts"][key]

    contact_hash["email"]
  end

  def report_sheet_from
    email_address_with_name(BDZ_SETTINGS["contacts"]["gs"]["email"], "BDZ Admin System")
  end

  def system_from
    email_address_with_name(BDZ_SETTINGS["contacts"]["system"]["email"], "BDZ Admin System")
  end

  def invoice_out_bcc
    BDZ_SETTINGS["invoice_config"]["invoice_out_bcc"]
  end

  def set_triggered_by(triggered_by_id)
    if triggered_by_id.present? and triggered_by_id > 0
      self.triggered_by = User.find(triggered_by_id)
    else
      self.triggered_by = nil
    end
  end
end
