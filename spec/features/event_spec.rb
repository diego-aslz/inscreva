require 'spec_helper'

describe "Event", type: :feature do
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
    ## More config
    click_on 'Configurações'
    fill_in 'Título no Comprovante', with: "Some Title"
    check 'Assinatura'
    ## Check Result
    expect{click_button 'Criar'}.to change(Event, :count).by(1)
    expect(Event.last.created_by_id).to eq(admin.id)
    expect(page).to have_content('Test Event')
    expect(page).to have_content "Some Title"
    expect(page).to have_content "Assinatura Sim"
    click_on Event.human_attribute_name(:fields)
    expect(page).to have_content('Some Field')
    click_on Event.human_attribute_name(:delegations)
    expect(page).to have_content('Some Good User')
    expect(page).to have_content('A Role')

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
    expect(page).to have_content('Test Event')
    click_on Event.human_attribute_name(:fields)
    expect(page).not_to have_content('Some Field')
    expect(page).not_to have_content('Another one')
    expect(page).to have_content('Changed it')
    click_on Event.human_attribute_name(:delegations)
    expect(page).not_to have_content('Some Good User')
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
      expect(page).to have_field(Notification.human_attribute_name(:recipients_text),
        with: 'abc@def.com, ghi@jkl.com, xyz@jkl.com')
      expect(page).to have_field(Notification.human_attribute_name(:respond),
        with: admin.email)
    end

    it "sends the notification" do
      visit new_event_notification_path(event)

      fill_in Notification.human_attribute_name(:subject), with: 'Some subject'
      fill_in Notification.human_attribute_name(:message), with: 'Some message'

      result = Object.new
      expect(result).to receive(:deliver)
      expect(NotificationMailer).to receive(:notify) do |notification|
        expect(notification.subject).to eq('Some subject')
        expect(notification.respond).to eq(admin.email)
        expect(notification.recipients).to eq(['abc@def.com', 'ghi@jkl.com', 'xyz@jkl.com'])
        expect(notification.message).to eq('Some message')
        result
      end
      expect {
        click_on I18n.t('helpers.submit.notification.create',
          model: Notification.model_name.human)
      }.to change(Notification, :count).by(1)
    end
  end
end
