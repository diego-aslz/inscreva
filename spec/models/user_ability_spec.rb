require 'cancan/matchers'
require 'spec_helper'

describe User do
  describe 'abilities' do
    context 'when it\'s not logged in' do
      subject { Ability.new(nil) }
      it { should be_able_to(:new, Subscription) }
      it { should be_able_to(:create, Subscription) }
    end

    context 'when user is a candidate' do
      subject { user }
      let(:user) { create(:subscriber_user) }

      it { should have_ability([:show, :edit, :update], for: user.subscriptions.
          first)}
    end
  end
end
