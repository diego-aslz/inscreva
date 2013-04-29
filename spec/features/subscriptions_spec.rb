require 'spec_helper'

feature "Subscriptions" do
  scenario "subscribing" do
    event = create(:ongoing_event)
    visit root_path
    click_link I18n.t(:subscribe)

    fill_in I18n.t('formtastic.labels.subscription.id_card'), with: '123456'
    click_link I18n.t(:continue)
  end

  pending "more scenarios"
end
