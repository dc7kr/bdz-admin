BDZAdmin::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true

  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # silence assets logging (Served asset...)
  config.assets.logger = nil

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.delivery_method = :smtp
    
  #
  # this disabled Mail sending entirely when set to false !!!
  #
  config.action_mailer.perform_deliveries = false
#  config.action_mailer.logger = nil
  #config.action_controller.relative_url_root = "/dev"

 config.time_zone = 'Berlin'
end
