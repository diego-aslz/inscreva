class HomeController < ApplicationController
  def index
    @events = Event.ongoing
  end
end
