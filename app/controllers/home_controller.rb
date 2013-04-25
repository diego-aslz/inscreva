class HomeController < ApplicationController
  def index
    @events = Event.ongoing
    @future_events = Event.future
  end
end
