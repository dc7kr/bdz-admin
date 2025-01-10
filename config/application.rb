require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BDZAdmin
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = "Central Time (US & Canada)"
    config.time_zone = 'Berlin'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :en

    config.action_controller.include_all_helpers = false

    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOW-FROM http://www.bdz-online.de/'
    }

    # custom error handling
    config.exceptions_app = routes
    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths += Dir["#{config.root}/app/writers/*"]
    # config.autoload_paths << Rails.root.join("lib")
    # config.eager_load_paths << Rails.root.join("lib")
  end
end
