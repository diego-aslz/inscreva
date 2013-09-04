# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Print Receipt" do
  let(:subscription) { create(:subscription, name: 'My Test') }

  before(:each) do
    sign_in subscription.user
  end

  it "shows the subscription's details" do
    visit subscription_path(subscription)
    page.should have_content 'My Test'
    click_on I18n.t(:print_receipt)
    current_path.should == receipt_subscription_path(subscription)
    page.should have_content 'My Test'
  end

  it "shows the fields marked to be shown" do
    f = create(:field, event_id: subscription.event_id, field_type: 'string',
        name: 'Street', show_receipt: false)
    f.field_fills.create(subscription_id: subscription.id, value: 'My Street')
    visit receipt_subscription_path(subscription)
    page.should_not have_content 'Street'

    f.update_attribute :show_receipt, true
    visit receipt_subscription_path(subscription)
    page.should have_content 'My Street'
  end
end
