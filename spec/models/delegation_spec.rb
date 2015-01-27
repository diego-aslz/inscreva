require 'spec_helper'

describe Delegation do
  context "validating" do
    let(:delegation) { build :delegation }
    subject { delegation }

    it { is_expected.to require_presence_of(:user_id) }
    it { is_expected.to require_presence_of(:role_id) }
  end
end
