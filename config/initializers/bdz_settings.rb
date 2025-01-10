if ENV['ASSET_PRECOMPILE'].blank?
  Rails.application.config.to_prepare do
    bdz_yml = YAML.load_file(Rails.root.join('config/bdz-settings.yml'), aliases: true)

    unless bdz_yml.nil?
      BDZ_SETTINGS = bdz_yml[Rails.env]
      APP_CONFIG_HASH = bdz_yml[Rails.env]
      DOCS_CONFIG = DocumentsConfig.new(APP_CONFIG_HASH['documents'])
    end
  end
end
