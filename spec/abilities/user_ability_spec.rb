require 'spec_helper'
require "cancan/matchers"

describe "User" do
  describe "abilities" do
    subject            { ability }
    let(:ability)      { Ability.new(user) }
    let(:user)         { nil }

    let(:past_event)   { build( :past_event) }
    let(:event)        { create(:ongoing_event) }
    let(:future_event) { build( :future_event) }

    context "is no one" do
      it{ should     be_able_to(:create,  event.subscriptions.build) }
      it{ should_not be_able_to(:create,  past_event.subscriptions.build) }
      it{ should_not be_able_to(:create,  future_event.subscriptions.build) }
      it{ should_not be_able_to(:read,    event) }
      it{ should_not be_able_to(:update,  event) }
      it{ should_not be_able_to(:create,  event) }
    end

    context "is a subscriber" do
      let(:user)                       { create(:subscriber_user) }
      let(:his_subscription)           { user.subscriptions.first }
      let(:his_past_subscription)      { s = user.subscriptions.first
        s.event = past_event; s }
      let(:his_fill)                   { create(:field_fill,
        subscription_id: his_subscription.id) }
      let(:another_users_subscription) { create(:subscription,event_id: event.id) }
      let(:another_users_fill)         { create(:field_fill) }

      it{ should     be_able_to(:mine,     Subscription) }
      it{ should     be_able_to(:update,   his_subscription) }
      it{ should     be_able_to(:show,     his_subscription) }
      it{ should     be_able_to(:show,     his_past_subscription) }
      it{ should     be_able_to(:download, his_fill) }

      it{ should_not be_able_to(:update,   his_past_subscription) }

      it{ should_not be_able_to(:update,   another_users_subscription) }
      it{ should_not be_able_to(:show,     another_users_subscription) }
      it{ should_not be_able_to(:download, another_users_fill) }
    end

    context "has permissions" do
      let(:user) { create :user }

      before(:each) do
        d = create(:delegation, event_id: event.id, user_id: user.id)
        d.role = create(:role)
        d.role.permissions << Permission.find_or_create_by(action: 'read',
          subject_class: 'Event')
        d.role.permissions << Permission.find_or_create_by(action: 'read',
          subject_class: 'Subscription')
        user.delegations   << d
      end

      it 'should be able to do what the permission says' do
        another_event = create(:event)

        ability.should      be_able_to(:read, event)
        ability.should_not  be_able_to(:read, another_event)

        subscription         = create(:subscription, event_id: event.id)
        another_subscription = create(:subscription)
        ability.should      be_able_to(:read, subscription)
        ability.should_not  be_able_to(:read, another_subscription)
      end
    end

    context 'is the creator of an event' do
      let(:user)  { create :user, can_create_events: true }
      let(:event) { create(:event, created_by_id: user.id) }
      let(:his_events_subscription) { create(:subscription, event_id: event.id) }
      let(:his_events_page)         { build(:page,          event_id: event.id) }
      let(:his_events_notification) { build(:notification,  event_id: event.id) }
      let(:his_events_fill)         { build(:field_fill,
        subscription_id: his_events_subscription.id) }

      let(:anothers_event) { create(:event) }
      let(:anothers_events_subscription) { create(:subscription, event_id: anothers_event.id) }
      let(:anothers_events_page)         { build(:page,          event_id: anothers_event.id) }
      let(:anothers_events_notification) { build(:notification,  event_id: anothers_event.id) }
      let(:anothers_events_fill)         { build(:field_fill,
        subscription_id: anothers_events_subscription.id) }

      it {
        should be_able_to(:read,     event)
        should be_able_to(:update,   event)
        should be_able_to(:read,     his_events_page)
        should be_able_to(:create,   his_events_page)
        should be_able_to(:update,   his_events_page)
        should be_able_to(:read,     his_events_subscription)
        should be_able_to(:create,   his_events_subscription)
        should be_able_to(:update,   his_events_subscription)
        should be_able_to(:receipt,  his_events_subscription)
        should be_able_to(:download, his_events_fill)
        should be_able_to(:create,   his_events_notification)

        should_not be_able_to(:read,     anothers_event)
        should_not be_able_to(:update,   anothers_event)
        should_not be_able_to(:read,     anothers_events_page)
        should_not be_able_to(:create,   anothers_events_page)
        should_not be_able_to(:update,   anothers_events_page)
        should_not be_able_to(:read,     anothers_events_subscription)
        should_not be_able_to(:create,   anothers_events_subscription)
        should_not be_able_to(:update,   anothers_events_subscription)
        should_not be_able_to(:receipt,  anothers_events_subscription)
        should_not be_able_to(:download, anothers_events_fill)
        should_not be_able_to(:create,   anothers_events_notification)
      }
    end
  end
end
