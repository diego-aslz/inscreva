require 'spec_helper'

describe Notification do
  let(:notification) { build :notification }

  it "rejects not valid filters" do
    notification.filters = {
      1 => {
        type: 'string',
        value: ''},
      2 => {
        type: 'string',
        value: nil},
      4 => {
        type: 'string',
        value: 'A'},
      3 => {
        type: 'string'}
      }
    notification.save.should be_true
    notification.filters.should == { 4 => { type: 'string', value: 'A'} }
  end

  context "loading recipients" do
    before(:each) do
      @s1 = build(:subscription, email: 'abc@def.com')
      @s2 = build(:subscription, email: 'abc@def.com')
      @s3 = build(:subscription, email: 'ghi@jkl.com')
      notification.event.subscriptions << @s1
      notification.event.subscriptions << @s2
      notification.event.subscriptions << @s3
      notification.filters = nil
      notification.load_recipients
    end

    it "does not repeat recipients" do
      notification.recipients.should == ['abc@def.com', 'ghi@jkl.com']
    end

    it "filters the subscribers" do
      f = create(:field, field_type: 'select', extra: 'ABC=abc')
      create(:field_fill, value: 'ABC', subscription_id: @s3.id, field_id: f.id)
      notification.filters = { f.id => { type: 'select', value: 'ABC' } }
      notification.load_recipients
      notification.recipients.should == ['ghi@jkl.com']
    end

    it "converts recipients to text" do
      notification.recipients_text.should == 'abc@def.com, ghi@jkl.com'
    end

    it "converts recipients from text" do
      notification.recipients_text= "abc@def.com,,,,   \n ghi@jkl.com,,another@test.com,"
      notification.recipients.should == ['abc@def.com', 'ghi@jkl.com', 'another@test.com']
    end
  end
end
