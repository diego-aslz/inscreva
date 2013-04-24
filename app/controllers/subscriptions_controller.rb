class SubscriptionsController < InheritedResources::Base
  actions :all, except: [ :index, :destroy ]
  load_and_authorize_resource

  def new
    unless params[:event_id] && Event.find(params[:event_id]).ongoing?
      redirect_to root_url
    else
      new!
    end
  end
end
