source "https://rubygems.org"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 7.2.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use Puma as the app server
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

########################
## custom starts here
########################
gem "haml"
gem "haml-rails", "~> 2.0"

# localization defaults
gem "rails-i18n", "~> 7.0.0"

# paginator
gem "kaminari"
gem "kaminari-mongoid"

# databases
gem "mongoid"
gem "mysql2", "~> 0.5.0"

# ASYNC Execution
gem "redis-client"
gem "sidekiq", "~> 7.3"
gem "sidekiq-cron"

# Version 3.0.2 makes sidekiq fail - see https://github.com/mperham/connection_pool/issues/212
gem "connection_pool", "<3"

# authenticate
gem "devise"
# gem 'devise-async'

# authorize
gem "pundit", "~> 2.5.2"
gem "rolify"

# DANGER: DONT OMIT iso otherwise it pollutes the default namespace
gem "countries"
gem "country_select"

gem "sinatra", require: false
gem "slim"

gem "bankleitzahl"
gem "sepa_king", git: "https://github.com/salesking/sepa_king.git"

gem "fastercsv"

gem "icalendar"

# 0.3.1 seems to be broken
# 0.3.5 works fine :)
# 0.3.6 has encoding issues!
gem "rodf", "~> 1.2.0"
#gem "rodf", path: "/srv/src/rodf"

# gem 'roo', :git => 'git://github.com/dc7kr/roo.git'
gem "roo"

# gem 'meta_where'
gem "http_accept_language"

gem "json"

gem "prawn"

# #TODO: REPLACE! is antique
gem "prawn-table", "~> 0.2.2"

gem "pdf-toolkit"

gem "combine_pdf"

gem "valid_email"

gem "comma", "~> 3.0"

gem "roo-xls"
gem "spreadsheet"
# gem "to_xml-rails"


# JS exec environment for asset precompile
gem "mini_racer"

# Bootstrap 5
gem "sassc-rails"
gem "bootstrap", "~> 5.3.5"
gem "bootstrap_form", "~> 5.4"
gem "font_awesome5_rails"

gem "momentjs-rails", ">= 2.9.0"
# gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'

# for soft delete
# gem "paranoia", "~> 2.6"
gem "acts_as_paranoid"

# Google libphonenumber
gem "telephone_number"

gem "corika_invoices",  git: 'https://github.com/dc7kr/invoices-gem', ref: "a3dc1260d98db8cbd9fe59ff2af3d605c0c78064", tag: "2.8"
gem "corika_sumup", git: 'https://github.com/dc7kr/sumup-gem', ref: "b400eb0b3019b70c7b94a5c69263ca250e2ca7a4", tag: "1.2"
# for developing the gem in parallel:
#gem "corika_invoices", path: "/srv/src/invoices-gem"
#gem "corika_sumup", path: "/srv/src/sumup_gem"

# crypto
# gem "attr_encrypted", "~> 3.1.0"

# to obfuscate mails
gem "actionview-encoded_mail_to"

gem "exception_notification"

# for QR generation
gem "rqrcode", "~> 3.0"

gem 'phonelib'

group :development do
  gem "rubocop"
  gem "rubocop-discourse"
  gem "rubocop-performance"
  gem "rubocop-rails"
end
