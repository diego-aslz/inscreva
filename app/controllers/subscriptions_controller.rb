class SubscriptionsController < InheritedResources::Base
  actions :all, except: [ :destroy, :create ]
  load_and_authorize_resource except: [:create]

  def new
    unless params[:event_id] && Event.find(params[:event_id]).ongoing?
      redirect_to root_url
    else
      @application = ApplicationForm.new.load_from params, current_user
      @application.user = current_user
    end
  end

  def create
    @application = ApplicationForm.new.load_from(params[:subscription])
    @application.user = current_user
    if @application.submit
      sign_in @application.user unless current_user
      flash[:notice] = t 'helpers.messages.subscription.successfully_created'
      redirect_to @application.subscription
    else
      render :new
    end
  end

  def edit
    @subscription = Subscription.find(params[:id])
    if @subscription.event.ongoing? && @subscription.event.allow_edit
      edit!
    else
      redirect_to root_url
    end
  end

  def update
    @subscription = Subscription.find(params[:id])
    if @subscription.event.ongoing? && @subscription.event.allow_edit
      update!
    else
      redirect_to root_url
    end
  end

  def index
    @subscriptions = Subscription.accessible_by(current_ability).includes :event
  end
end
