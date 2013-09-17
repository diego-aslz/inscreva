class HomeController < ApplicationController
  def index
    @events = Event.where(published: true).order('opens_at, closes_at')
  end
end
