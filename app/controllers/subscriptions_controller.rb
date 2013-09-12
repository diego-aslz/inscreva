class SubscriptionsController < InheritedResources::Base
  actions :all, except: [ :destroy, :create ]
  load_and_authorize_resource except: [:new, :create]
  respond_to :html
  include SubscriptionsHelper

  def new
    @event = Event.find(params[:event_id])
    @application = ApplicationForm.new.load_from params, current_user
    @application.user = current_user
    authorize! :new, @application.subscription
    @application.field_fills = @event.field_fills
  end

  def create
    @event = Event.find(params[:event_id])
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
      format.html { @subscriptions = @subscriptions.page(params[:page]) }
      format.csv { send_data @subscriptions.to_csv(include_fields: @fields) }
      format.xls
      format.zip {
        fds = FileDownloaderService.new(@subscriptions)
        send_file fds.zip_file(params[:download][:field_ids])
      }
    end
  end

  protected

  def collection
    @event = Event.find(params[:event_id])
    @subscriptions = @event.subscriptions.accessible_by(current_ability)
    @subscriptions = @subscriptions.search(params[:term]) unless params[:term].blank?
    unless (fields = params[:field_ids]).blank?
      @fields = @event.fields.where("id in (?) and field_type != 'file'",
          fields).select([:id, :name, :field_type, :is_numeric])
      @subscriptions = @subscriptions.includes(:field_fills).
          where('field_fills.field_id in (?)', fields.map(&:to_i))
    else
      @fields = []
    end
    params[:fields].each do |k,v|
      if v.key?(:value) and filter_valid?(k, v[:value], v[:type])
        clause, query_params = filter_clause(k, v[:value], v[:type])
        @subscriptions = @subscriptions.where('subscriptions.id in (select ' +
            "subscription_id from field_fills where #{clause})", *query_params)
      end
    end if params[:fields]
  end
end
