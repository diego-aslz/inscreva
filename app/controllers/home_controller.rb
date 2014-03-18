class HomeController < ApplicationController
  def index
    @events = Event.for_main_page.order('opens_at, closes_at')
  end
end
