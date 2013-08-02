require 'spec_helper'
require "cancan/matchers"

describe "User" do
  describe "abilities" do
    subject { ability }
    let(:ability){ Ability.new(user) }
    let(:user){ nil }

    context "when is no one" do
      it{ should be_able_to(:create,  Subscription) }
      it{ should be_able_to(:new,     Subscription) }
      it{ should be_able_to(:show,    Wiki) }
    end

    context "when is a candidate" do
      let(:user)                        { create(:candidate_user) }
      let(:his_subscription)            { user.subscriptions.first }
      let(:another_users_subscription)  { create(:subscription) }
      let(:his_fill)                    { create(:field_fill, subscription_id: his_subscription.id) }
      let(:another_users_fill)          { create(:field_fill) }

      it{ should     be_able_to(:index,    Subscription) }
      it{ should     be_able_to(:edit,     his_subscription) }
      it{ should     be_able_to(:update,   his_subscription) }
      it{ should     be_able_to(:show,     his_subscription) }
      it{ should     be_able_to(:download, his_fill) }

      it{ should_not be_able_to(:edit,     another_users_subscription) }
      it{ should_not be_able_to(:update,   another_users_subscription) }
      it{ should_not be_able_to(:show,     another_users_subscription) }
      it{ should_not be_able_to(:download, another_users_fill) }
    end
  end
end
