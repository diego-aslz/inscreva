require 'spec_helper'

feature "Subscriptions" do
  scenario "subscribing" do
    event = create(:ongoing_event)
    visit root_path
    click_link I18n.t(:subscribe)

    fill_in Subscription.human_attribute_name(:id_card), with: '123456'
    fill_in Subscription.human_attribute_name(:name), with: 'Teste'
    fill_in Subscription.human_attribute_name(:email), with: 'teste@teste.com'
    fill_in Subscription.human_attribute_name(:email_confirmation), with: 'teste@teste.com'
    fill_in Subscription.human_attribute_name(:password), with: 'teste@teste.com', match: :prefer_exact
    fill_in Subscription.human_attribute_name(:password_confirmation), with: 'teste@teste.com'

    click_button I18n.t(:subscribe)
  end

  scenario "viewing subscription receipt" do
    af = build(:application_form)
    af.submit
    sign_in User.new(email: af.email, password: af.password)

    visit subscription_path(af.subscription)
    click_link I18n.t(:print_receipt)
    page.should have_content(af.subscription.name)
  end
end
