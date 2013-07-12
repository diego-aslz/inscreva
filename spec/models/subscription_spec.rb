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

  it "should generate a subscription number" do
    sub = build(:subscription)
    sub.number.should be_nil
    sub.save
    sub.number.should_not be_nil
  end

  it "should not change the number" do
    sub = create(:subscription)
    sub.number.should_not be_nil
    expect {
      sub.update_attribute :name, sub.name + sub.name
    }.not_to change(sub, :number)
  end
end
