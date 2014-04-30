require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
