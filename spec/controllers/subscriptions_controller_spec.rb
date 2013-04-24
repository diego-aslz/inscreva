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
      ev = create(:ongoing_event) do |e|
        e.allow_edit = false
      end
      sub = create(:subscription) do |s|
        s.event = ev
      end
      sign_in sub.user
      get :edit, id: sub.id
      response.should redirect_to(root_path)
    end

    it "doesn\'t edit when the event is not ongoing" do
      ev = create(:past_event)
      sub = create(:subscription) do |s|
        s.event = ev
      end
      sign_in sub.user
      get :edit, id: sub.id
      response.should redirect_to(root_path)
    end
  end

  describe "POST create" do
    describe "with invalid params" do
      pending 'Can\'t create when not ongoing'
    end
  end

  describe "PUT update" do
    describe "with invalid params" do
      pending 'Can\'t update when not ongoing'
      pending 'Can\'t update when not allowed by the event'
    end
  end
end
