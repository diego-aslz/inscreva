# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Subscription" do
  context "displaying dynamic fields" do
    it "displays a String field" do
      f = create(:field, field_type: 'string', name: 'Address')
      visit new_event_subscription_path(f.event)
      expect(page).to have_content('Address')
      expect(page).to have_selector("input#subscription_field_fills_attributes_0_value[type=text]")
    end

    it "displays a Text field" do
      f = create(:field, field_type: 'text', name: 'Address')
      visit new_event_subscription_path(f.event)
      expect(page).to have_content('Address')
      expect(page).to have_selector("textarea#subscription_field_fills_attributes_0_value_text")
    end

    it "displays a Boolean field" do
      f = create(:field, field_type: 'boolean', name: 'Address')
      visit new_event_subscription_path(f.event)
      expect(page).to have_content('Address')
      expect(page).to have_selector("input#subscription_field_fills_attributes_0_value_true[type=radio]")
      expect(page).to have_selector("input#subscription_field_fills_attributes_0_value_false[type=radio]")
    end

    it "displays a Country field" do
      f = create(:field, field_type: 'country', name: 'Address')
      visit new_event_subscription_path(f.event)
      expect(page).to have_content('Address')
      expect(page).to have_selector("select#subscription_field_fills_attributes_0_value")
      expect(page).to have_selector("option[value=BRA]")
      expect(page).to have_selector("option[value=ARG]")
      expect(page).to have_selector("option[value=BOL]")
    end

    it "displays a Date field" do
      f = create(:field, field_type: 'date', name: 'Address')
      visit new_event_subscription_path(f.event)
      expect(page).to have_content('Address')
      expect(page).to have_selector("input#subscription_field_fills_attributes_0_value_date[type=text]")
    end

    it "displays a File field" do
      f = create(:field, field_type: 'file', name: 'Address')
      visit new_event_subscription_path(f.event)
      expect(page).to have_content('Address')
      expect(page).to have_selector("input#subscription_field_fills_attributes_0_file[type=file]")
    end

    it "displays a Select field" do
      f = create(:field, field_type: 'select', name: 'Address', extra: "1=A\n2=B\n4=C")
      visit new_event_subscription_path(f.event)
      expect(page).to have_content('Address')
      expect(page).to have_selector("select#subscription_field_fills_attributes_0_value")
      expect(page).to have_selector("option[value=\"1\"]")
      expect(page).to have_selector("option[value=\"2\"]")
      expect(page).to have_selector("option[value=\"4\"]")
    end

    it "displays a Check Boxes field" do
      f = create(:field, field_type: 'check_boxes', name: 'Address', extra: "1=A\n2=B\n4=C")
      visit new_event_subscription_path(f.event)
      expect(page).to have_content('Address')
      expect(page).to have_selector("input#subscription_field_fills_attributes_0_value_cb_1[type=checkbox][value=\"1\"]")
      expect(page).to have_selector("input#subscription_field_fills_attributes_0_value_cb_2[type=checkbox][value=\"2\"]")
      expect(page).to have_selector("input#subscription_field_fills_attributes_0_value_cb_4[type=checkbox][value=\"4\"]")
    end

    context "existing subscription" do
      let(:user) { create(:user, password: '123456789', password_confirmation: '123456789') }
      let(:subscription) { create(:subscription, event_id: field.event_id, user_id: user.id) }
      let(:field)        { create(:field, field_type: 'string', name: 'Address') }

      before(:each) do
        sign_in user, '123456789'
      end

      it "renders fresh created fields" do
        visit edit_subscription_path(subscription)
        expect(page).to have_field("Address")
      end

      it "orders fresh created fields" do
        subscription.field_fills << FieldFill.create(field_id: field.id)
        field2 = create(:field, field_type: 'string', name: 'City', priority: 1,
          event_id: field.event_id)
        field.update_attribute :priority, 2

        visit edit_subscription_path(subscription)
        expect(page.document.text).to match(/City.*Address/)
      end
    end
  end

  it "orders fields and groups them when there is a group_name" do
    f1 = create(:field, field_type: 'text', priority: 0, name: 'Address')
    f2 = create(:field, field_type: 'text', priority: 1, event_id: f1.event_id, name: 'Test', group_name: 'Group')
    f3 = create(:field, field_type: 'text', priority: 2, event_id: f1.event_id, name: 'Another')
    visit new_event_subscription_path(f1.event)
    expect(page.body[/Address.*Group.*Test.*Another/m]).not_to be_nil
  end

  it 'receives subscriptions' do
    e = create(:ongoing_event, name: "Some Great Event", published: true)
    f1 = create(:field, event_id: e.id, field_type: 'string',      name: 'Street')
    f2 = create(:field, event_id: e.id, field_type: 'text',        name: 'About Yourself')
    f3 = create(:field, event_id: e.id, field_type: 'boolean',     name: 'Like Fish')
    f3 = create(:field, event_id: e.id, field_type: 'country',     name: 'Birth Country')
    f3 = create(:field, event_id: e.id, field_type: 'date',        name: 'Birth Date')
    f3 = create(:field, event_id: e.id, field_type: 'file',        name: 'Curriculum')
    f3 = create(:field, event_id: e.id, field_type: 'select',      name: 'Chocolate', extra: "B=Black\nW=White")
    f3 = create(:field, event_id: e.id, field_type: 'check_boxes', name: 'You Have',  extra: "1=Car\n2=Refrigerator\n3=TV")

    visit root_path
    expect(page).to have_content 'Some Great Event'
    click_on I18n.t(:subscribe)

    expect(page).not_to have_content(Subscription.human_attribute_name(:password))
    expect(page).not_to have_content(Subscription.human_attribute_name(:password_confirmation))
    fill_in Subscription.human_attribute_name(:name),                  with: 'My Name'
    fill_in Subscription.human_attribute_name(:id_card),               with: '123321123'
    fill_in Subscription.human_attribute_name(:email),                 with: 'some@mail.com'
    fill_in Subscription.human_attribute_name(:email_confirmation),    with: 'some@mail.com'
    fill_in "Street", with: 'Some St.'
    fill_in "About Yourself", with: "1234567890" * 30
    choose I18n.t('yes')
    select(I18n.t('countries.SWE'), :from => 'Birth Country')
    fill_in "Birth Date", with: '31/12/1990'
    attach_file('Curriculum',  File.expand_path("../../support/files/blank.pdf", __FILE__))
    select 'Black', :from => 'Chocolate'
    check 'TV'
    check 'Refrigerator'
    expect{ click_on I18n.t(:subscribe) }.not_to change(Subscription, :count)

    expect(page).to have_content(I18n.t(:'helpers.errors.subscription.confirm'))
    fill_in Subscription.human_attribute_name(:password),              with: '123456789'
    fill_in Subscription.human_attribute_name(:password_confirmation), with: '123456789'
    expect{ click_on I18n.t(:subscribe) }.to change(Subscription, :count).by(1)

    expect(page).to have_content(I18n.t(:'helpers.messages.subscription.successfully_created'))
    expect(page).to have_content('123321123')
    expect(page).to have_content('some@mail.com')
    expect(page).to have_content('Some Great Event')
    expect(page).to have_content('Some St.')
    expect(page).to have_content("1234567890" * 30)
    expect(page).to have_content(I18n.t('yes'))
    expect(page).to have_content(I18n.t('countries.SWE'))
    expect(page).to have_content(I18n.l(Date.new(1990,12,31), format: :long))
    expect(page).to have_link(I18n.t(:download))
    expect(page).to have_content('Black')
    expect(page).to have_content('Refrigerator, TV')
    expect(page).to have_link(I18n.t(:print_receipt))

    click_on I18n.t(:'helpers.links.edit')
    fill_in "Street", with: 'Another St.'
    click_on I18n.t(:subscribe)
    expect(page).not_to have_selector("form")
    expect(page).to have_content('Another St.')
  end
end
