class ApplicationMailer < ActionMailer::Base
  default from: BDZ_SETTINGS["contacts"]["system"]["email"]
  layout "mailer"

  def contact_email(key)
    if not BDZ_SETTINGS["contacts"].key?(key)
      return nil
    end

    contact_hash = BDZ_SETTINGS["contacts"][key]

    email_address_with_name(contact_hash["email"], contact_hash["name"])
  end

  def report_sheet_from
    email_address_with_name(BDZ_SETTINGS["contacts"]["gs"]["email"], "BDZ Admin System")
  end
  def invoice_out_bcc
    BDZ_SETTINGS["invoice_config"]["invoice_out_bcc"]
  end
end
