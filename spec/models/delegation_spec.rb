require 'spec_helper'

describe Delegation do
  context "validating" do
    let(:delegation) { build :delegation }
    subject { delegation }

    it { should require_presence_of(:event_id) }
    it { should require_presence_of(:user_id) }
    it { should require_presence_of(:role_id) }
  end
end
