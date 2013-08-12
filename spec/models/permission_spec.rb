require 'spec_helper'

describe Permission do
  context "validating" do
    let(:permission) { build :permission }
    subject { permission }

    it { should require_presence_of(:action) }
    it { should require_presence_of(:subject_class) }
  end
end
