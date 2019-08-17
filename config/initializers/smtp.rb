unless BDZAdmin::Application.config.action_mailer.nil?

yml = YAML.load_file(Rails.root.join('config', 'smtp.yml'))[Rails.env]

smtp_options= yml["smtp"]
url_options= yml["url"]

BDZAdmin::Application.config.action_mailer.smtp_settings = {}
BDZAdmin::Application.config.action_mailer.default_url_options = {}

smtp_options.each do |name, value|
  BDZAdmin::Application.config.action_mailer.smtp_settings[name.to_sym] = value
end unless smtp_options.nil?


url_options.each do |name, value|
  BDZAdmin::Application.config.action_mailer.default_url_options[name.to_sym] = value
end unless url_options.nil?
end
