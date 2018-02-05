INVOICE_CONFIG_HASH= YAML.load_file(Rails.root.join('config', 'bdz-settings.yml'))[Rails.env]
INVOICE_CONFIG= CorikaInvoices::Config.new(INVOICE_CONFIG_HASH['invoice_config'])
INVOICE_CONTACT_HASH = INVOICE_CONFIG_HASH['contacts']
