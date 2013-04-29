class SubscriptionsController < InheritedResources::Base
  actions :all, except: [ :index, :destroy ]
  load_and_authorize_resource
  respond_to :js, :only => :check

  def new
    unless params[:event_id] && Event.find(params[:event_id]).ongoing?
      redirect_to root_url
    else
      new!
    end
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    if !@subscription.event.nil? && @subscription.event.ongoing?
      create!
    else
      redirect_to root_url
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

  def check
    id_card = params[:id_card]
    if id_card && Subscription.exists?(id_card: id_card)
      render json: 1
    else
      render json: 0
    end
  end
end
