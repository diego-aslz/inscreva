class SubscriptionsController < InheritedResources::Base
  actions :all, except: [ :destroy, :create ]
  load_and_authorize_resource except: [:new, :create]
  respond_to :html
  respond_to :json, only: :index
  include SubscriptionsHelper

  def new
    @event = Event.find(params[:event_id])
    params.permit!
    @application = ApplicationForm.new.load_from params, current_user
    @application.user = current_user
    authorize! :new, @application.subscription
  end

  def create
    @event = Event.find(params[:event_id])
    params.permit!
    @application = ApplicationForm.new.load_from(params[:subscription])
    @application.event = @event
    authorize! :create, @application.subscription

    @application.user = current_user
    @application.generate_number
    if @application.submit
      sign_in @application.user unless current_user
      flash[:notice] = t 'helpers.messages.subscription.successfully_created'
      redirect_to @application.subscription
    else
      render :new
    end
  end

  def edit
    sub = Subscription.find(params[:id])
    @application = ApplicationForm.new
    @application.subscription = sub
  end

  def update
    @application = ApplicationForm.new
    sub = Subscription.find(params[:id])
    @application.subscription = sub
    params.permit!
    if @application.submit params[:subscription]
      redirect_to sub
    else
      render :edit
    end
  end

  def mine
    @subscriptions = current_user.subscriptions.includes(:event).page(params[:page])
  end

  def receipt
    @subscription = Subscription.find(params[:id])
    render layout: 'printing_page'
  end

  def index
    index! do |format|
      format.html {
        @count = @subscriptions.count
        @subscriptions = @subscriptions.order(created_at: :desc).
          page(params[:page])
      }
      format.csv { send_data @subscriptions.to_csv(include_fields: @fields,
          selects: permitted_selects) }
      format.xls
      format.zip {
        authorize! :download, @subscriptions.first.field_fills.build
        fds = FileDownloaderService.new(@subscriptions)
        send_file fds.zip_file(params[:download][:field_ids])
      }
    end
  end

  protected

  def resource_params
    return [] if request.get?
    [params.require(:subscription).permit(
      :email,
      :id_card,
      :event_id,
      :name,
      field_fills_attributes: [
        :value,
        :field_id,
        :subscription_id,
        :type,
        :file,
        :remove_file,
        :file_cache,
        :value_cb,
        :value_date,
        :id
      ])]
  end

  def collection
    @event = Event.find(params[:event_id])
    authorize! :read, @event.subscriptions.build
    @subscriptions = @event.subscriptions
    @subscriptions = @subscriptions.search(params[:term]) unless params[:term].blank?
    @fields = []
    unless (fields = params[:field_ids]).blank?
      @fields = @event.fields.where("id in (?) and field_type != 'file'",
          fields).select(:id, :name, :field_type, :is_numeric, :extra)
      @subscriptions = @subscriptions.includes(:field_fills).references(:field_fills).
          where('field_fills.field_id in (?)', fields.map(&:to_i))
    end
    if params[:fields]
      types = Field.where('id in (?)', params[:fields].keys).pluck :field_type
      i=-1
      params[:fields].each_pair { |k,v| v[:type] = types[i += 1] }
      params[:fields].reject!{ |k,v| !Subscription.valid_filter?(k, v[:value], v[:type]) }
      params[:fields].each do |k,v|
        @subscriptions = @subscriptions.by_field k, v[:value], v[:type]
      end
    end
  end
end
