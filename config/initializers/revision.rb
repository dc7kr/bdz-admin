Rails.application.config.to_prepare do
  yml = YAML.load_file(Rails.root.join('config', 'version.yml'), aliases: true )

  if not yml.nil?
    data = yml["version_info"]

    GIT_REVISION =  data["current"]
    IMAGE_VERSION = data["image"]
  end
end
