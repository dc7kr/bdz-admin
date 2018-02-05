BDZ_SETTINGS = YAML.load_file(Rails.root.join('config', 'bdz-settings.yml'))[Rails.env]
APP_CONFIG_HASH= YAML.load_file(Rails.root.join('config', 'bdz-settings.yml'))[Rails.env]
DOCS_CONFIG = DocumentsConfig.new(APP_CONFIG_HASH["documents"])
