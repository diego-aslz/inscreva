class EventsController < InheritedResources::Base
  load_and_authorize_resource

  def new
    @event = Event.new
    @event.fields.build
    new!
  end

  protected

  def collection
    @events = @events.page(params[:page])
  end
end
