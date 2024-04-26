unless BDZAdmin::Application.config.action_mailer.nil?

  smtp_options = Rails.application.credentials[:smtp]
  url_options = Rails.application.credentials[:url]

  BDZAdmin::Application.config.action_mailer.smtp_settings = {}
  BDZAdmin::Application.config.action_mailer.default_url_options = {}

  smtp_options.each do |name, value|
    BDZAdmin::Application.config.action_mailer.smtp_settings[name.to_sym] = value
  end unless smtp_options.nil?


  url_options.each do |name, value|
    BDZAdmin::Application.config.action_mailer.default_url_options[name.to_sym] = value
  end unless url_options.nil?
end
