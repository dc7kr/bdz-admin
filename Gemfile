source 'http://rubygems.org'

gem 'rails', '3.2.22'

gem 'haml'
gem 'haml-rails'

# DANGER: DONT OMIT iso otherwise it pollutes the default namespace
gem 'countries', :require => 'iso3166'
gem 'country_select'

# preparation for Rails 4
gem 'strong_parameters'


#gem 'corika_invoices', :git => 'git@git.corika.com:gems/corika_invoices.git'

#ASYNC Execution 
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

gem 'sepa_king', :git => 'https://github.com/salesking/sepa_king.git'
gem 'bankleitzahl'


gem 'coffee-rails'
gem 'uglifier', ">= 1.3.0"

gem 'fastercsv'
gem 'paperclip'

gem 'icalendar' 

gem 'rbktoblzcheck'
#gem 'konto_check'

gem 'jquery-rails' 	
gem 'jquery-ui-rails'
gem 'jquery-fileupload-rails'

# 0.3.1 seems to be broken
# 0.3.2 works fine :)
# 0.3.5 works fine :)
# 0.3.6 has encoding issues!
gem "rodf", "= 0.3.5"
#gem "rodf", '= 0.3'

#gem 'roo', :git => 'git://github.com/dc7kr/roo.git'
gem 'roo'

#gem 'meta_where'
gem 'meta_search'
gem 'http_accept_language'

# Use unicorn as the web server
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json'

gem 'prawn'

gem 'dynamic_form'
gem 'formtastic'
gem 'valid_email'

gem "comma", "~> 3.0"

gem "spreadsheet"
#gem "to_xml-rails"

gem 'sqlite3'
gem 'mysql2' , '>=0.3'

gem 'rails-asset-jqueryui'

# authenticate
gem 'devise'
#gem 'devise-async'
# authorize
gem 'cancancan' ,'~> 1.10'
#paginator
gem 'kaminari'
gem 'rolify'

gem 'ruby_parser'
gem 'hpricot'
# JS exec environment for asset precompile


#gem 'will_paginate'
# testing
#gem 'web-app-theme', '~> 0.8.0'
#gem 'web-app-theme', :git => "git://github.com/pilu/web-app-theme.git"

gem 'class-table-inheritance'

gem 'parseconfig'

# Bootstrap css 
gem 'bootstrap-sass', '~> 3.3.5'
gem 'sass-rails', '>= 3.2'

#to be able to compile the assets...
group :production do
  gem 'therubyracer'
end


group :test do
  gem 'simplecov', :require => false
  gem 'capybara'
  gem 'rspec-rails'
  gem 'factory_girl'
end
