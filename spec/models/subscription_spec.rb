require 'spec_helper'

describe 'Subscription' do
  context 'fetching the fields in details' do
    let(:f1) { create(:event_field) }
    let(:f2) { create(:event_field) }
    let(:f3) { create(:event_field) }
    let(:subscription) {
      f3
      build(:subscription, details: { f1.id.to_s => "true", f2.id.to_s => "false" })
    }

    subject { subscription.details_fields }

    its(:count) { should == 2 }
    it { should be_include(f1) }
    it { should be_include(f2) }
    it { should_not be_include(f3) }
  end
end
