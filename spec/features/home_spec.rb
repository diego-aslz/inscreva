require 'spec_helper'

feature "Visiting Home" do
  scenario "viewing ongoing events" do
    event = create(:ongoing_event)
    visit root_path
    page.should have_content event.name
  end
end
