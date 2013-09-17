class EventsController < InheritedResources::Base
  load_and_authorize_resource except: [:ahead, :copy_fields]

  def new
    @event = Event.new
    @event.fields.build
    new!
  end

  def copy_fields
    from = Event.find params[:copy][:from_event_id]
    @event = Event.find params[:copy][:to_event_id]
    authorize! :update, @event
    @event.copy_fields_from from
    render action: :edit
  end

  def ahead
    authorize! :index, Event
    @events = Event.accessible_by(current_ability)
    @events = @events.by_name(params[:term]) unless params[:term].blank?
    ar = []
    for e in @events.limit(20) do
      ar << {id: e.id, name: e.name}
    end
    render json: ar
  end

  protected

  def collection
    @events = @events.order('opens_at desc').page(params[:page])
  end
end
