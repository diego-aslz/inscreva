class EventsController < InheritedResources::Base
  load_and_authorize_resource except: [:ahead, :copy_fields]

  def new
    @event = Event.new
    @event.fields.build
    new!
  end

  def create
    @event.created_by = current_user
    create!
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
    @events = @events.order('id desc').page(params[:page])
  end

  def resource_params
    return [] if request.get?
    [params.require(:event).permit(:closes_at, :email, :name, :opens_at,
      :technical_email, :identifier, :published, :description, :rules_url,
      :receipt_title, fields_attributes: [
        :field_type, :name, :extra, :required, :show_receipt,
        :group_name, :priority, :searchable, :is_numeric, :hint,
        :max_file_size, :id, :_destroy, allowed_file_extensions: []
      ],
      delegations_attributes: [
        :user_id, :user_name, :event_id, :role_id, :id, :_destroy
      ])]
  end
end
