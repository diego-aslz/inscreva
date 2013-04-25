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

  describe "GET edit" do
    it "doesn\'t edit when the event doesn\'t allow it" do
      ev = create(:ongoing_event, allow_edit: false)
      sub = create(:subscription, event: ev)
      sign_in sub.user
      get :edit, id: sub.id
      response.should redirect_to(root_path)
    end

    it "doesn\'t edit when the event is not ongoing" do
      ev = create(:past_event, allow_edit: true)
      sub = create(:subscription, event: ev)
      sign_in sub.user
      get :edit, id: sub.id
      response.should redirect_to(root_path)
    end
  end

  describe "POST create" do
    describe "with invalid params" do
      it "doesn\'t create when the event is in the past" do
        ev = create(:past_event)
        sub = build(:subscription, event: ev)
        post :create, subscription: sub
        response.should redirect_to(root_path)
      end

      it "doesn\'t create when the event is in the future" do
        ev = create(:future_event)
        sub = build(:subscription, event: ev)
        post :create, subscription: sub
        response.should redirect_to(root_path)
      end
    end
  end

  describe "PUT update" do
    describe "with invalid params" do
      it "doesn\'t update when the event doesn\'t allow it" do
        ev = create(:ongoing_event, allow_edit: false)
        sub = create(:subscription, event: ev)
        sign_in sub.user
        sub.id_card = '987654321'
        put :update, { id: sub.id, subscription: sub }
        response.should redirect_to(root_path)
      end

      it "doesn\'t update when the event is not ongoing" do
        ev = create(:past_event, allow_edit: true)
        sub = create(:subscription, event: ev)
        sign_in sub.user
        sub.id_card = '987654321'
        put :update, { id: sub.id, subscription: sub }
        response.should redirect_to(root_path)
      end
    end
  end
end
