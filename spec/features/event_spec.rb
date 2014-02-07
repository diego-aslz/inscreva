require 'spec_helper'

describe "Event" do
  let(:admin) { create(:admin, password: '123456789',
    password_confirmation: '123456789') }

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
    fill_in_typeahead 'Usuário', 'Some Good', page.find('#delegations')
    select 'A Role', from: Delegation.human_attribute_name(:role)
    ## Check Result
    expect{click_button 'Criar'}.to change(Event, :count).by(1)
    Event.last.created_by_id.should == admin.id
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

  context "notifying subscribers" do
    let(:sub1)  { build(:subscription, email: 'abc@def.com') }
    let(:sub2)  { build(:subscription, email: 'abc@def.com') }
    let(:sub3)  { build(:subscription, email: 'ghi@jkl.com') }
    let(:sub4)  { build(:subscription, email: 'xyz@jkl.com') }
    let(:event) { create(:event) }

    before(:each) do
      event.subscriptions << sub1
      event.subscriptions << sub2
      event.subscriptions << sub3
      event.subscriptions << sub4
    end

    it "loads the subscribers' emails" do
      visit events_path

      click_on "#event_#{event.id}_notify_link"
      page.should have_field(Notification.human_attribute_name(:recipients_text),
        with: 'abc@def.com, ghi@jkl.com, xyz@jkl.com')
      page.should have_field(Notification.human_attribute_name(:respond),
        with: admin.email)
    end

    it "sends the notification" do
      visit new_event_notification_path(event)

      fill_in Notification.human_attribute_name(:subject), with: 'Some subject'
      fill_in Notification.human_attribute_name(:message), with: 'Some message'

      result = Object.new
      result.should_receive(:deliver)
      NotificationMailer.should_receive(:notify) do |notification|
        notification.subject.should == 'Some subject'
        notification.respond.should == admin.email
        notification.recipients.should == ['abc@def.com', 'ghi@jkl.com', 'xyz@jkl.com']
        notification.message.should == 'Some message'
        result
      end
      expect {
        click_on I18n.t('helpers.submit.notification.create',
          model: Notification.model_name.human)
      }.to change(Notification, :count).by(1)
    end
  end
end
