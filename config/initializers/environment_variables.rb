module SecretEnvironmentVariables
  class Application < Rails::Application
    config.before_configuration do
      env_file = Rails.root.join('/etc//bdz-rails-env.yml').to_s

      if File.exist?(env_file)
        YAML.load_file(env_file)[Rails.env].each do |key, value|
          ENV[key.to_s] = value
        end # end YAML.load_file
      end # end if File.exist?
    end # end config.before_configuration
  end # end class
end # end module
