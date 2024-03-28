Rails.application.config.to_prepare do
  BDZ_SETTINGS = YAML.load_file(Rails.root.join('config', 'bdz-settings.yml'), aliases: true )[Rails.env]
  APP_CONFIG_HASH= YAML.load_file(Rails.root.join('config', 'bdz-settings.yml'), aliases: true )[Rails.env]
  DOCS_CONFIG = DocumentsConfig.new(APP_CONFIG_HASH["documents"])
end
