require 'spec_helper'

describe Role do
  context "validating" do
    let(:role) { build :role }
    subject { role }

    it { should require_presence_of(:action) }
    it { should require_presence_of(:subject_class) }
  end
end
