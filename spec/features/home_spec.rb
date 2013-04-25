require 'spec_helper'

feature "Visiting Home" do
  scenario "viewing ongoing events" do
    event = create(:ongoing_event)
    visit root_path
    page.should have_content event.name
    page.should have_content I18n.t :subscribe
  end

  scenario "viewing future events" do
    event = create(:future_event)
    visit root_path
    page.should have_content I18n.t :future_events
    page.should have_content event.name
    page.should_not have_content I18n.t :subscribe
  end

  scenario "no future events at all" do
    visit root_path
    page.should_not have_content I18n.t :future_events
  end
end
