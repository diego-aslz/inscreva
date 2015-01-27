# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Print Receipt" do
  let(:receipt_signature) { false }
  let(:receipt_title) { nil }
  let(:event)         { create :event, receipt_title: receipt_title,
    receipt_signature: receipt_signature }
  let(:subscription)  { create(:subscription, name: 'My Test', event: event,
    user: create(:user, password: '123456789', password_confirmation: '123456789')) }

  before(:each) do
    sign_in subscription.user, '123456789'
  end

  it "shows the subscription's details" do
    visit subscription_path(subscription)
    expect(page).to have_content 'My Test'
    click_on I18n.t(:print_receipt)
    expect(page).to have_content 'Comprovante de Inscrição'
    expect(current_path).to eq(receipt_subscription_path(subscription))
    expect(page).to have_content 'My Test'
  end

  it "shows the fields marked to be shown" do
    f = create(:field, event_id: subscription.event_id, field_type: 'string',
        name: 'Street', show_receipt: false)
    f.field_fills.create(subscription_id: subscription.id, value: 'My Street')
    visit receipt_subscription_path(subscription)
    expect(page).not_to have_content 'Street'

    f.update_attribute :show_receipt, true
    visit receipt_subscription_path(subscription)
    expect(page).to have_content 'My Street'
  end

  context 'there is a custom receipt_title' do
    let(:receipt_title) { 'Another Title' }
    subject { page }
    before(:each) do
      visit subscription_path(subscription)
      click_on I18n.t(:print_receipt)
    end
    it { is_expected.not_to have_content('Comprovante de Inscrição') }
    it { is_expected.to     have_content('Another Title') }
  end

  context 'receipt_signature is true' do
    let(:receipt_signature) { true }
    subject { page }
    before(:each) do
      visit subscription_path(subscription)
      click_on I18n.t(:print_receipt)
    end
    it { is_expected.to have_content('____________') }
  end
end
