source "https://rubygems.org"

ruby '3.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.1.2'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

# Use Puma as the app server
gem 'puma', '~> 5.0'

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
gem "tzinfo-data", platforms: %i[ windows jruby ]
 

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do 
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

########################
## custom starts here
########################
gem 'haml'
gem 'haml-rails', "~> 2.0"

# DANGER: DONT OMIT iso otherwise it pollutes the default namespace
gem 'countries'
gem 'country_select'

#ASYNC Execution 
gem 'sidekiq', "~> 7.0"
gem "sidekiq-cron", "~> 1.1"
gem "redis-client"

gem 'sinatra', require: false
gem 'slim'

gem 'sepa_king', :git => 'https://github.com/salesking/sepa_king.git'
gem 'bankleitzahl'

gem 'fastercsv'
gem 'paperclip'

gem 'icalendar' 

gem 'rbktoblzcheck'
#gem 'konto_check'

# 0.3.1 seems to be broken
# 0.3.5 works fine :)
# 0.3.6 has encoding issues!
gem "rodf", "~> 1.0.0"

#gem 'roo', :git => 'git://github.com/dc7kr/roo.git'
gem 'roo'

#gem 'meta_where'
gem 'http_accept_language'

gem 'json'

gem 'prawn'
##TODO: REPLACE! is antique
gem 'prawn-table', '~> 0.2.2'

gem 'pdf-toolkit'

gem 'valid_email'

gem "comma", "~> 3.0"

gem "spreadsheet"
gem "roo-xls"
#gem "to_xml-rails"

gem 'mysql2', '~> 0.5.0'

# authenticate
gem 'devise'
#gem 'devise-async'

# authorize
gem 'cancancan', '~> 3.3.0'
gem 'cancancan-mongoid'

#paginator
gem 'kaminari'

gem 'kaminari-mongoid' 

gem 'rolify'
gem 'authority'

gem 'ruby_parser'
gem 'hpricot'

# JS exec environment for asset precompile
gem 'mini_racer'


# testing
#gem 'web-app-theme', '~> 0.8.0'
#gem 'web-app-theme', :git => "git://github.com/pilu/web-app-theme.git"

gem 'parseconfig'

gem 'mongoid'

# Bootstrap 5
gem 'bootstrap', '~> 5.2.3'
gem "bootstrap_form", "~> 5.4"
gem "font_awesome5_rails"


gem 'momentjs-rails', '>= 2.9.0'
#gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'

# for soft delete
gem "paranoia", "~> 2.6"

# Google libphonenumber
gem 'telephone_number'

# TODO: CHANGE TO THE REAL PATH ONCE IT IS FINAL!
gem "corika_invoices",  git: 'https://github.com/dc7kr/invoices-gem'

# crypto
#gem "attr_encrypted", "~> 3.1.0"

# to obfuscate mails
gem 'actionview-encoded_mail_to'


# localization defaults
gem 'rails-i18n', '~> 7.0.0'

gem 'exception_notification'

