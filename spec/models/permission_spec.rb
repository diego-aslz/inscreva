require 'spec_helper'

describe Permission do
  context "validating" do
    let(:permission) { build :permission }
    subject { permission }

    it { is_expected.to require_presence_of(:action) }
    it { is_expected.to require_presence_of(:subject_class) }
  end
end
