require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
