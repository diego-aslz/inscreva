require 'spec_helper'

describe Role do
  context "validating" do
    let(:role) { build :role }
    subject { role }

    it { is_expected.to require_presence_of(:name) }
  end
end
