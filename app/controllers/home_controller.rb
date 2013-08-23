class HomeController < ApplicationController
  def index
    @events = Event.where(published: true).order(:'created_at desc')
  end
end
