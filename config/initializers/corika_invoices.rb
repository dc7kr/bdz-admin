Rails.application.config.to_prepare do
  INVOICE_CONFIG_HASH= YAML.load_file(Rails.root.join('config', 'bdz-settings.yml'), aliases: true)[Rails.env]
  INVOICE_CONFIG= CorikaInvoices::Config.new(INVOICE_CONFIG_HASH['invoice_config'])
  INVOICE_CONTACT_HASH = INVOICE_CONFIG_HASH['contacts']
end
