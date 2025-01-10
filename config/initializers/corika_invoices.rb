if ENV['ASSET_PRECOMPILE'].blank?
  Rails.application.config.to_prepare do
    bdz_yaml = YAML.load_file(Rails.root.join('config/bdz-settings.yml'), aliases: true)

    unless bdz_yaml.nil?
      INVOICE_CONFIG_HASH = bdz_yaml[Rails.env]
      INVOICE_CONFIG = CorikaInvoices::Config.new(INVOICE_CONFIG_HASH['invoice_config'])
      INVOICE_CONTACT_HASH = INVOICE_CONFIG_HASH['contacts']
    end
  end
end
