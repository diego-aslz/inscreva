require 'spec_helper'

describe SubscriptionsController do
  describe "GET new" do
    it "redirects to root if no Event is selected" do
      get :new, {}
      response.should redirect_to(root_path)
    end

    it "redirects to root if the Event is not ongoing" do
      e = create(:past_event)
      get :new, { event_id: e.id}
      response.should redirect_to(root_path)

      e = create(:future_event)
      get :new, { event_id: e.id}
      response.should redirect_to(root_path)
    end
  end
end
