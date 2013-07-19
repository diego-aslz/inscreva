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

  describe "receipt_fills" do
    it "should return fills which field has show_receipt == true" do
      field = create(:field)
      show_field = create(:field, show_receipt: true)
      fill = create(:field_fill, field_id: field.id)
      show_fill = create(:field_fill, field_id: show_field.id, subscription_id:
          fill.subscription_id)

      subscription = fill.subscription
      subscription.receipt_fills.include?(fill).should be_false
      subscription.receipt_fills.include?(show_fill).should be_true
    end
  end
end
