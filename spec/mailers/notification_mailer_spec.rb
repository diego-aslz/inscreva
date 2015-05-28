require "spec_helper"

describe NotificationMailer do
  let(:notification) { build(:notification, message: 'Hello, guys.', subject: 'Testing') }

  before(:each) do
    @s1 = build(:subscription, email: 'abc@def.com')
    @s2 = build(:subscription, email: 'abc@def.com')
    @s3 = build(:subscription, email: 'ghi@jkl.com')
    notification.event.subscriptions << @s1
    notification.event.subscriptions << @s2
    notification.event.subscriptions << @s3
    notification.load_recipients
  end

  it "notifies the subscribers about the Notification" do
    NotificationMailer.notify(notification).deliver_now
    expect(ActionMailer::Base.deliveries.last.bcc).to eq(['abc@def.com', 'ghi@jkl.com'])
    expect(ActionMailer::Base.deliveries.last.subject).to eq('Testing')
  end

  it "filters the subscribers" do
    f = create(:field, field_type: 'select', extra: 'ABC=abc')
    create(:field_fill, value: 'ABC', subscription_id: @s3.id, field_id: f.id)
    notification.filters = { f.id => { type: 'select', value: 'ABC' } }
    notification.load_recipients
    NotificationMailer.notify(notification).deliver_now
    expect(ActionMailer::Base.deliveries.last.bcc).to eq(['ghi@jkl.com'])
  end
end
