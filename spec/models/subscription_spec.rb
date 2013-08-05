require 'spec_helper'

describe 'Subscription' do
  context 'generating a subscription number' do
    let(:subscription) { build(:subscription) }

    it "should generate a new one on create" do
      subscription.number.should be_nil
      subscription.save
      subscription.number.should_not be_nil
    end

    it "should not change on update" do
      subscription.save!
      subscription.number.should_not be_nil
      expect {
        subscription.update_attribute :name, subscription.name + subscription.name
      }.not_to change(subscription, :number)
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

  it 'searches by a text' do
    s = create(:subscription, name: 'nametosearchby')
    Subscription.search('ametosearchb').include?(s).should be_true
    s.update_attribute :name, 'A'
    s.update_attribute :email, 'nametosearchby@domain.com'
    Subscription.search('ametosearchb').include?(s).should be_true
    s.update_attribute :name, 'A'
    s.update_attribute :email, 'abc@domain.com'
    s.update_attribute :number, '123456789'
    Subscription.search('23456789').include?(s).should be_true
    Subscription.search('anythingelse').include?(s).should be_false
  end
end
