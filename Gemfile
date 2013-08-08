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
  # gem 'rack-mini-profiler'
  gem 'binding_of_caller'
  gem 'thin'
  gem 'debugger'
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
gem 'simple_form'
gem 'kaminari'
gem 'nested_form'
gem 'responders'
gem 'has_scope'
gem 'country-select', github: 'nerde/country-select'
gem "haml-rails"
gem 'carrierwave'
gem 'redcarpet'
gem 'inherited_resources'
gem 'angularjs-rails'
gem 'unicorn'
gem 'capistrano'
