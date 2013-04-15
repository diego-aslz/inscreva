class EventsController < ApplicationController
  def index
    @events = Event.all
    respond_with(@events)
  end

  def show
    @event = Event.find(params[:id])
    respond_with(@event)
  end

  def new
    @event = Event.new
    respond_with(@event)
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])
    @event.save
    respond_with(@event)
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes(params[:event])
    respond_with(@event)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_with(@event)
  end
end
