require 'spec_helper'

feature "Contests" do
  fixtures :all

  background do
    visit new_user_session_path
    u = users(:admin)
    fill_in 'user_email', with: u.email
    fill_in 'user_password', with: '123456'
    click_button I18n.t('devise.buttons.sign_in')
  end

  scenario "creating a new one" do
    # visit contests_path
    click_link 'Contests'
    click_link I18n.t 'helpers.links.new'
    fill_in 'contest_name', with: 'Example'
    click_button I18n.t('helpers.titles.new', model: I18n.t(
        'activerecord.models.contest'))
  end
end
