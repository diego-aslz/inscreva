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
      it{ is_expected.to     be_able_to(:create,  event.subscriptions.build) }
      it{ is_expected.not_to be_able_to(:create,  past_event.subscriptions.build) }
      it{ is_expected.not_to be_able_to(:create,  future_event.subscriptions.build) }
      it{ is_expected.not_to be_able_to(:read,    event) }
      it{ is_expected.not_to be_able_to(:update,  event) }
      it{ is_expected.not_to be_able_to(:create,  event) }
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

      it{ is_expected.to     be_able_to(:mine,     Subscription) }
      it{ is_expected.to     be_able_to(:update,   his_subscription) }
      it{ is_expected.to     be_able_to(:show,     his_subscription) }
      it{ is_expected.to     be_able_to(:show,     his_past_subscription) }
      it{ is_expected.to     be_able_to(:download, his_fill) }

      it{ is_expected.not_to be_able_to(:update,   his_past_subscription) }

      it{ is_expected.not_to be_able_to(:update,   another_users_subscription) }
      it{ is_expected.not_to be_able_to(:show,     another_users_subscription) }
      it{ is_expected.not_to be_able_to(:download, another_users_fill) }
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

        expect(ability).to      be_able_to(:read, event)
        expect(ability).not_to  be_able_to(:read, another_event)

        subscription         = create(:subscription, event_id: event.id)
        another_subscription = create(:subscription)
        expect(ability).to      be_able_to(:read, subscription)
        expect(ability).not_to  be_able_to(:read, another_subscription)
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
        is_expected.to be_able_to(:read,     event)
        is_expected.to be_able_to(:update,   event)
        is_expected.to be_able_to(:read,     his_events_page)
        is_expected.to be_able_to(:create,   his_events_page)
        is_expected.to be_able_to(:update,   his_events_page)
        is_expected.to be_able_to(:read,     his_events_subscription)
        is_expected.to be_able_to(:create,   his_events_subscription)
        is_expected.to be_able_to(:update,   his_events_subscription)
        is_expected.to be_able_to(:receipt,  his_events_subscription)
        is_expected.to be_able_to(:download, his_events_fill)
        is_expected.to be_able_to(:create,   his_events_notification)

        is_expected.not_to be_able_to(:read,     anothers_event)
        is_expected.not_to be_able_to(:update,   anothers_event)
        is_expected.not_to be_able_to(:read,     anothers_events_page)
        is_expected.not_to be_able_to(:create,   anothers_events_page)
        is_expected.not_to be_able_to(:update,   anothers_events_page)
        is_expected.not_to be_able_to(:read,     anothers_events_subscription)
        is_expected.not_to be_able_to(:create,   anothers_events_subscription)
        is_expected.not_to be_able_to(:update,   anothers_events_subscription)
        is_expected.not_to be_able_to(:receipt,  anothers_events_subscription)
        is_expected.not_to be_able_to(:download, anothers_events_fill)
        is_expected.not_to be_able_to(:create,   anothers_events_notification)
      }
    end
  end
end
