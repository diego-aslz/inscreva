source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'mysql2'

group :test, :development do
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'zeus'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-rspec'
end

group :development do
  gem 'better_errors'
  gem 'bullet'
  gem 'rack-mini-profiler'
  gem 'binding_of_caller'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'jquery-rails', "2.3.0"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem "bootstrap-sass"
  gem 'bootstrap-datepicker-rails'
  gem 'maskedinput-rails'
end

gem 'devise'
gem 'show_for'
gem 'cancan'
gem 'formtastic-bootstrap'
gem 'kaminari'
gem 'nested_form'
gem 'puma'
gem 'responders'
gem 'activeadmin'
gem 'has_scope'
gem 'country-select', github: 'nerde/country-select'
gem "haml-rails"
gem "paperclip"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
