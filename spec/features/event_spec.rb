require 'spec_helper'

describe "Event" do
  let(:admin) { create(:admin, password: '123456789', password_confirmation: '123456789') }

  before(:each) do
    sign_in admin, '123456789'
  end

  it "is possible to create and update events", js: true do
    create(:user, name: "Some Good User")
    create(:role, name: "A Role")
    visit events_path

    # Creating
    ## Event
    click_on I18n.t(:'helpers.links.new')
    fill_in Event.human_attribute_name(:name), with: 'Test Event'
    fill_in Event.human_attribute_name(:identifier), with: 'test'
    ## Fields
    click_on Event.human_attribute_name(:fields)
    fill_in Field.human_attribute_name(:name), with: 'Some Field'
    find('#add_field').click
    find('#event_fields_attributes_1_name').set 'Another one'
    ## Delegations
    click_on Event.human_attribute_name(:delegations)
    find('#add_delegation').click
    fill_in Delegation.human_attribute_name(:user), with: "Some Good"
    find('#delegations').find('li.active').click
    select 'A Role', from: Delegation.human_attribute_name(:role)
    ## Check Result
    click_on I18n.t(:'helpers.submit.create', model: Event.model_name.human)
    page.should have_content('Test Event')
    click_on Event.human_attribute_name(:fields)
    page.should have_content('Some Field')
    click_on Event.human_attribute_name(:delegations)
    page.should have_content('Some Good User')
    page.should have_content('A Role')

    # Updating
    click_on I18n.t(:'helpers.links.edit')
    ## Fields
    click_on Event.human_attribute_name(:fields)
    find('#event_fields_attributes_0_name').set 'Changed it'
    find('#event_fields_attributes_1_destroy_link').click
    ## Delegations
    click_on Event.human_attribute_name(:delegations)
    find('#event_delegations_attributes_0_destroy_link').click
    ## Check Result
    click_on I18n.t(:'helpers.submit.update', model: Event.model_name.human)
    page.should have_content('Test Event')
    click_on Event.human_attribute_name(:fields)
    page.should_not have_content('Some Field')
    page.should_not have_content('Another one')
    page.should have_content('Changed it')
    click_on Event.human_attribute_name(:delegations)
    page.should_not have_content('Some Good User')
  end
end
