require 'spec_helper'
require "cancan/matchers"

describe "User" do
  describe "abilities" do
    subject { ability }
    let(:ability){ Ability.new(user) }
    let(:user){ nil }

    let(:past_event){ build(:past_event) }
    let(:event){ create(:ongoing_event) }
    let(:future_event){ build(:future_event) }

    context "when is no one" do
      it{ should     be_able_to(:create,  event.subscriptions.build) }
      it{ should_not be_able_to(:create,  past_event.subscriptions.build) }
      it{ should_not be_able_to(:create,  future_event.subscriptions.build) }
    end

    context "when is a candidate" do
      let(:user)                        { create(:subscriber_user) }
      let(:his_subscription)            { user.subscriptions.first }
      let(:his_past_subscription)       { s = user.subscriptions.first; s.event = past_event; s }
      let(:another_users_subscription)  { create(:subscription, event_id: event.id) }
      let(:his_fill)                    { create(:field_fill, subscription_id: his_subscription.id) }
      let(:another_users_fill)          { create(:field_fill) }

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

    context "when it has permissions" do
      let(:user) { create :user }

      before(:each) do
        d = create(:delegation, event_id: event.id, user_id: user.id)
        d.role = create(:role)
        d.role.permissions << Permission.find_or_create_by_action_and_subject_class('read', 'Event')
        d.role.permissions << Permission.find_or_create_by_action_and_subject_class('read', 'Subscription')
        user.delegations << d
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
  end
end
