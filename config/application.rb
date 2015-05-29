require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

Bundler.require(*Rails.groups)

module Inscreva
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brasilia'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :'pt-BR'
    config.i18n.locale = :'pt-BR'
    config.i18n.enforce_available_locales = false

    config.action_dispatch.rescue_responses["PagesController::NotFound"] = :not_found

    config.exceptions_app = self.routes

    config.filter_parameters += [:password, :password_confirmation, :current_password]

    config.active_record.raise_in_transactional_callbacks = true
  end
end
