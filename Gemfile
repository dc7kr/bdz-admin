source 'http://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2'

# Use Puma as the app server
gem 'puma', '~> 3.11'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby


# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
   # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [ :mri, :mingw, :x64_mingw]
end

group :development do 
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

########################
## custom starts here
########################
gem 'haml'
gem 'haml-rails', "~> 2.0"

# DANGER: DONT OMIT iso otherwise it pollutes the default namespace
gem 'countries'
gem 'country_select'

#ASYNC Execution 
gem 'sidekiq'
gem "sidekiq-cron", "~> 1.1"

gem 'redis-namespace'

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

gem 'mysql2', '~> 0.4.0'

# authenticate
gem 'devise'
#gem 'devise-async'

# authorize
gem 'cancancan', '~> 2.0'
gem 'cancancan-mongoid'

#paginator
gem 'kaminari'

gem 'kaminari-mongoid' 

gem 'rolify'
gem 'authority'

gem 'ruby_parser'
gem 'hpricot'
# JS exec environment for asset precompile


# testing
#gem 'web-app-theme', '~> 0.8.0'
#gem 'web-app-theme', :git => "git://github.com/pilu/web-app-theme.git"

gem 'parseconfig'

gem 'mongoid', '~> 6.0.0'

# Bootstrap 4
gem 'bootstrap', '~> 4.3.1'
gem "bootstrap_form", ">= 4.1.0"
gem 'font-awesome-rails'
#gem 'bootstrap_form-datetimepicker'

gem 'momentjs-rails', '>= 2.9.0'
#gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'

# for soft delete
gem "paranoia", "~> 2.2"

# Google libphonenumber
gem 'telephone_number'

# TODO: CHANGE TO THE REAL PATH ONCE IT IS FINAL!
gem 'corika_invoices', path: "/home/kasi/corika_invoices"

# crypto
#gem "attr_encrypted", "~> 3.1.0"

# to obfuscate mails
gem 'actionview-encoded_mail_to'


# localization defaults
gem 'rails-i18n', '~> 5.0.0'
