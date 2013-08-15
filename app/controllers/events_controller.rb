class EventsController < InheritedResources::Base
  load_and_authorize_resource

  def new
    @event = Event.new
    @event.opens_at = Time.zone.now.change(:hour => 0)
    @event.closes_at = Time.zone.now.change(:hour => 23, :min => 59)
    @event.fields.build
    new!
  end

  protected

  def collection
    @events = @events.page(params[:page])
  end
end
