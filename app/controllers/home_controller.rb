class HomeController < ApplicationController
  def index
    @events = Event.ongoing.where(published: true)
    @published_events = Event.where(published: true)
  end
end
