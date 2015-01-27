require 'spec_helper'

describe Subscription do
  let(:subscription) { build(:subscription) }
  let(:event) { subscription.event }

  context 'generating a subscription number' do
    it "should generate a new one on create" do
      expect(subscription.number).to be_nil
      subscription.save!
      expect(subscription.number).not_to be_nil
    end

    it "should not change on update" do
      subscription.save!
      expect(subscription.number).not_to be_nil
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
      expect(subscription.receipt_fills.include?(fill)).to be_falsey
      expect(subscription.receipt_fills.include?(show_fill)).to be_truthy
    end
  end

  it 'searches by a text' do
    s = create(:subscription, name: 'nametosearchby')
    expect(Subscription.search('ametosearchb').include?(s)).to be_truthy
    s.update_attribute :name, 'A'
    s.update_attribute :email, 'nametosearchby@domain.com'
    expect(Subscription.search('ametosearchb').include?(s)).to be_truthy
    s.update_attribute :name, 'A'
    s.update_attribute :email, 'abc@domain.com'
    s.update_attribute :number, '123456789'
    expect(Subscription.search('23456789').include?(s)).to be_truthy
    expect(Subscription.search('anythingelse').include?(s)).to be_falsey
  end

  context "checking if a filter is valid" do
    it "is valid when it's a date and there is a begining date or an ending date" do
      expect(Subscription.valid_filter?(1, {b: '', e: ''}, 'date')).to be_falsey
      expect(Subscription.valid_filter?(1, {b: 'a', e: ''}, 'date')).to be_truthy
      expect(Subscription.valid_filter?(1, {b: '', e: 'a'}, 'date')).to be_truthy
      expect(Subscription.valid_filter?(1, {b: 'a', e: 'a'}, 'date')).to be_truthy
    end

    it "is valid when it's not a date and there is some value" do
      expect(Subscription.valid_filter?(1, '', 'string')).to be_falsey
      expect(Subscription.valid_filter?(1, 'a', 'string')).to be_truthy
    end

    it 'is valid when it\'s about check_boxes and there is some value' do
      expect(Subscription.valid_filter?(1, [], 'check_boxes')).to be_falsey
      expect(Subscription.valid_filter?(1, ['a'], 'check_boxes')).to be_truthy
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

      expect(Subscription.by_field(f1.id, 'B', 'string')).to include(subscription)
      expect(Subscription.by_field(f2.id, 'B', 'string')).not_to include(subscription)
    end

    it 'searches by a text field' do
      f1 = create :field, field_type: 'text'
      f2 = create :field, field_type: 'text'
      create(:field_fill, field_id: f1.id, value_text: 'ABC', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value_text: 'DEF', subscription_id: subscription.id)

      expect(Subscription.by_field(f1.id, 'B', 'text')).to include(subscription)
      expect(Subscription.by_field(f2.id, 'B', 'text')).not_to include(subscription)
    end

    it 'searches by a date field' do
      f1 = create :field, field_type: 'date'
      f2 = create :field, field_type: 'date'
      create(:field_fill, field_id: f1.id, value: '2013-01-31', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: '2013-02-01', subscription_id: subscription.id)

      expect(Subscription.by_field(f1.id, {b: '31/01/2013'}, 'date')).to include(subscription)
      expect(Subscription.by_field(f1.id, {e: '31/01/2013'}, 'date')).to include(subscription)
      expect(Subscription.by_field(f1.id, {b: '31/01/2013', e: '31/01/2013'}, 'date')).to include(subscription)
      expect(Subscription.by_field(f2.id, {b: '31/01/2013', e: '31/01/2013'}, 'date')).not_to include(subscription)
    end

    it 'searches by a check_boxes field' do
      f1 = create :field, field_type: 'check_boxes'
      f2 = create :field, field_type: 'check_boxes'
      create(:field_fill, field_id: f1.id, value: '1,2', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: '3', subscription_id: subscription.id)

      expect(Subscription.by_field(f1.id, ['2'], 'check_boxes')).to include(subscription)
      expect(Subscription.by_field(f1.id, ['1', '2'], 'check_boxes')).to include(subscription)
      expect(Subscription.by_field(f2.id, ['1', '3'], 'check_boxes')).to include(subscription)
      expect(Subscription.by_field(f2.id, ['1'], 'check_boxes')).not_to include(subscription)
    end

    it 'searches by a boolean field' do
      f1 = create :field, field_type: 'boolean'
      f2 = create :field, field_type: 'boolean'
      create(:field_fill, field_id: f1.id, value: 'true', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: 'false', subscription_id: subscription.id)

      expect(Subscription.by_field(f1.id, 'true', 'boolean')).to include(subscription)
      expect(Subscription.by_field(f1.id, 'false', 'boolean')).not_to include(subscription)
    end

    it 'searches by a select field' do
      f1 = create :field, field_type: 'select'
      f2 = create :field, field_type: 'select'
      create(:field_fill, field_id: f1.id, value: '1', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: '2', subscription_id: subscription.id)

      expect(Subscription.by_field(f1.id, ['1'     ], 'select')).to     include(subscription)
      expect(Subscription.by_field(f1.id, ['1', '2'], 'select')).to     include(subscription)
      expect(Subscription.by_field(f2.id, ['1'     ], 'select')).not_to include(subscription)
    end

    it 'searches by a country field' do
      f1 = create :field, field_type: 'country'
      f2 = create :field, field_type: 'country'
      create(:field_fill, field_id: f1.id, value: 'BRA', subscription_id: subscription.id)
      create(:field_fill, field_id: f2.id, value: 'PRY', subscription_id: subscription.id)

      expect(Subscription.by_field(f1.id, ['BRA'       ], 'country')).to     include(subscription)
      expect(Subscription.by_field(f1.id, ['BRA', 'PRY'], 'country')).to     include(subscription)
      expect(Subscription.by_field(f2.id, ['BRA'       ], 'country')).not_to include(subscription)
    end
  end
end
