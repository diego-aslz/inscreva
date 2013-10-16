source 'https://rubygems.org'

gem 'rails', '4.0.0'

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
  gem 'sass-rails',   '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'jquery-rails', "2.3.0"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.3.0'
  gem "bootstrap-sass"
  gem 'bootstrap-datepicker-rails'
  gem 'maskedinput-rails'
end

gem 'devise', github: 'plataformatec/devise', branch: 'v3.1.0.rc2'
gem 'show_for'
gem 'cancan'
gem 'simple_form', '~> 3.0.0.rc'
gem 'kaminari'
gem 'nested_form'
gem 'responders'
gem 'has_scope'
gem 'country-select', github: 'nerde/country-select', branch: :rails4
gem "haml-rails"
gem 'carrierwave'
gem 'redcarpet'
gem 'inherited_resources'
gem 'angularjs-rails'
gem 'unicorn'
gem 'capistrano'
gem 'markitup-rails'
gem 'rubyzip', '< 1.0.0'
