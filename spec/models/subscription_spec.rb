require 'spec_helper'

describe Subscription do
  let(:subscription) { build(:subscription) }
  let(:event) { subscription.event }

  context 'generating a subscription number' do
    it "should generate a new one on create" do
      subscription.number.should be_nil
      subscription.save!
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

  context "checking if a filter is valid" do
    it "is valid when it's a date and there is a begining date or an ending date" do
      Subscription.valid_filter?(1, {b: '', e: ''}, 'date').should be_false
      Subscription.valid_filter?(1, {b: 'a', e: ''}, 'date').should be_true
      Subscription.valid_filter?(1, {b: '', e: 'a'}, 'date').should be_true
      Subscription.valid_filter?(1, {b: 'a', e: 'a'}, 'date').should be_true
    end

    it "is valid when it's not a date and there is some value" do
      Subscription.valid_filter?(1, '', 'string').should be_false
      Subscription.valid_filter?(1, 'a', 'string').should be_true
    end

    it 'is valid when it\'s about check_boxes and there is some value' do
      Subscription.valid_filter?(1, [], 'check_boxes').should be_false
      Subscription.valid_filter?(1, ['a'], 'check_boxes').should be_true
    end
  end

  context 'filtering by fields' do
    before(:each) do
      subscription.save
    end

    it 'searches by a string field' do
      f1 = create :field, field_type: 'string'
      f2 = create :field, field_type: 'string'
      create(:field_fill, field_id: f1.id, value: 'ABC', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: 'DEF', subscription_id: subscription.id)

      Subscription.by_field(f1.id, 'B', 'string').should include(subscription)
      Subscription.by_field(f2.id, 'B', 'string').should_not include(subscription)
      Subscription.by_field(f1.id, 'B', 'text').should include(subscription)
      Subscription.by_field(f2.id, 'B', 'text').should_not include(subscription)
    end

    it 'searches by a date field' do
      f1 = create :field, field_type: 'date'
      f2 = create :field, field_type: 'date'
      create(:field_fill, field_id: f1.id, value: '2013-01-31', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: '2013-02-01', subscription_id: subscription.id)

      Subscription.by_field(f1.id, {b: '31/01/2013'}, 'date').should include(subscription)
      Subscription.by_field(f1.id, {e: '31/01/2013'}, 'date').should include(subscription)
      Subscription.by_field(f1.id, {b: '31/01/2013', e: '31/01/2013'}, 'date').should include(subscription)
      Subscription.by_field(f2.id, {b: '31/01/2013', e: '31/01/2013'}, 'date').should_not include(subscription)
    end

    it 'searches by a check_boxes field' do
      f1 = create :field, field_type: 'check_boxes'
      f2 = create :field, field_type: 'check_boxes'
      create(:field_fill, field_id: f1.id, value: '1,2', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: '3', subscription_id: subscription.id)

      Subscription.by_field(f1.id, ['2'], 'check_boxes').should include(subscription)
      Subscription.by_field(f1.id, ['1', '2'], 'check_boxes').should include(subscription)
      Subscription.by_field(f2.id, ['1', '3'], 'check_boxes').should include(subscription)
      Subscription.by_field(f2.id, ['1'], 'check_boxes').should_not include(subscription)
    end

    it 'searches by a boolean field' do
      f1 = create :field, field_type: 'boolean'
      f2 = create :field, field_type: 'boolean'
      create(:field_fill, field_id: f1.id, value: 'true', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: 'false', subscription_id: subscription.id)

      Subscription.by_field(f1.id, 'true', 'boolean').should include(subscription)
      Subscription.by_field(f1.id, 'false', 'boolean').should_not include(subscription)
    end

    it 'searches by a select field' do
      f1 = create :field, field_type: 'select'
      f2 = create :field, field_type: 'select'
      create(:field_fill, field_id: f1.id, value: '1', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: '2', subscription_id: subscription.id)

      Subscription.by_field(f1.id, ['1'     ], 'select').should     include(subscription)
      Subscription.by_field(f1.id, ['1', '2'], 'select').should     include(subscription)
      Subscription.by_field(f2.id, ['1'     ], 'select').should_not include(subscription)
    end

    it 'searches by a country field' do
      f1 = create :field, field_type: 'country'
      f2 = create :field, field_type: 'country'
      create(:field_fill, field_id: f1.id, value: 'BRA', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: 'PRY', subscription_id: subscription.id)

      Subscription.by_field(f1.id, ['BRA'       ], 'country').should     include(subscription)
      Subscription.by_field(f1.id, ['BRA', 'PRY'], 'country').should     include(subscription)
      Subscription.by_field(f2.id, ['BRA'       ], 'country').should_not include(subscription)
    end
  end
end
