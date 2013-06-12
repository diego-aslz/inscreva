require 'spec_helper'

feature "Subscriptions" do
  scenario "subscribing" do
    event = create(:ongoing_event)
    visit root_path
    click_link I18n.t(:subscribe)

    fill_in I18n.t('formtastic.labels.subscription.id_card'), with: '123456'
    fill_in I18n.t('formtastic.labels.subscription.name'), with: 'Teste'
    fill_in I18n.t('formtastic.labels.subscription.email'), with: 'teste@teste.com'
    fill_in I18n.t('formtastic.labels.subscription.email_confirmation'), with: 'teste@teste.com'
    fill_in I18n.t('formtastic.labels.subscription.password'), with: 'teste@teste.com'
    fill_in I18n.t('formtastic.labels.subscription.password_confirmation'), with: 'teste@teste.com'

    click_button I18n.t(:subscribe)
  end
end
