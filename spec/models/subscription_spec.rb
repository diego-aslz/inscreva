require 'spec_helper'

describe 'Subscription' do
  context 'generating a subscription number' do
    it "should generate a new one on create" do
      sub = build(:subscription)
      sub.number.should be_nil
      sub.save
      sub.number.should_not be_nil
    end

    it "should not change on update" do
      sub = create(:subscription)
      sub.number.should_not be_nil
      expect {
        sub.update_attribute :name, sub.name + sub.name
      }.not_to change(sub, :number)
    end
  end
end
