# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Subscription" do
  context "displaying dynamic fields" do
    it "displays a String field" do
      f = create(:field, field_type: 'string', name: 'Address')
      visit new_event_subscription_path(f.event)
      page.should have_content('Address')
      page.should have_selector("input#subscription_field_fills_attributes_0_value[type=text]")
    end

    it "displays a Text field" do
      f = create(:field, field_type: 'text', name: 'Address')
      visit new_event_subscription_path(f.event)
      page.should have_content('Address')
      page.should have_selector("textarea#subscription_field_fills_attributes_0_value")
    end

    it "displays a Boolean field" do
      f = create(:field, field_type: 'boolean', name: 'Address')
      visit new_event_subscription_path(f.event)
      page.should have_content('Address')
      page.should have_selector("input#subscription_field_fills_attributes_0_value_true[type=radio]")
      page.should have_selector("input#subscription_field_fills_attributes_0_value_false[type=radio]")
    end

    it "displays a Country field" do
      f = create(:field, field_type: 'country', name: 'Address')
      visit new_event_subscription_path(f.event)
      page.should have_content('Address')
      page.should have_selector("select#subscription_field_fills_attributes_0_value")
      page.should have_selector("option[value=BRA]")
      page.should have_selector("option[value=ARG]")
      page.should have_selector("option[value=BOL]")
    end

    it "displays a Date field" do
      f = create(:field, field_type: 'date', name: 'Address')
      visit new_event_subscription_path(f.event)
      page.should have_content('Address')
      page.should have_selector("input#subscription_field_fills_attributes_0_value_date[type=text]")
    end

    it "displays a File field" do
      f = create(:field, field_type: 'file', name: 'Address')
      visit new_event_subscription_path(f.event)
      page.should have_content('Address')
      page.should have_selector("input#subscription_field_fills_attributes_0_file[type=file]")
    end

    it "displays a Select field" do
      f = create(:field, field_type: 'select', name: 'Address', extra: "1=A\n2=B\n4=C")
      visit new_event_subscription_path(f.event)
      page.should have_content('Address')
      page.should have_selector("select#subscription_field_fills_attributes_0_value")
      page.should have_selector("option[value=\"1\"]")
      page.should have_selector("option[value=\"2\"]")
      page.should have_selector("option[value=\"4\"]")
    end

    it "displays a Check Boxes field" do
      f = create(:field, field_type: 'check_boxes', name: 'Address', extra: "1=A\n2=B\n4=C")
      visit new_event_subscription_path(f.event)
      page.should have_content('Address')
      page.should have_selector("input#subscription_field_fills_attributes_0_value_cb_1[type=checkbox][value=\"1\"]")
      page.should have_selector("input#subscription_field_fills_attributes_0_value_cb_2[type=checkbox][value=\"2\"]")
      page.should have_selector("input#subscription_field_fills_attributes_0_value_cb_4[type=checkbox][value=\"4\"]")
    end
  end

  it "orders fields and groups them when there is a group_name" do
    f1 = create(:field, field_type: 'text', priority: 0, name: 'Address')
    f2 = create(:field, field_type: 'text', priority: 1, event_id: f1.event_id, name: 'Test', group_name: 'Group')
    f3 = create(:field, field_type: 'text', priority: 2, event_id: f1.event_id, name: 'Another')
    visit new_event_subscription_path(f1.event)
    page.body[/Address.*Group.*Test.*Another/m].should_not be_nil
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
    page.should have_content 'Some Great Event'
    click_on I18n.t(:subscribe)

    fill_in Subscription.human_attribute_name(:name),                  with: 'My Name'
    fill_in Subscription.human_attribute_name(:id_card),               with: '123321123'
    fill_in Subscription.human_attribute_name(:email),                 with: 'some@mail.com'
    fill_in Subscription.human_attribute_name(:email_confirmation),    with: 'some@mail.com'
    fill_in Subscription.human_attribute_name(:password),              with: '123456789'
    fill_in Subscription.human_attribute_name(:password_confirmation), with: '123456789'
    fill_in "Street", with: 'Some St.'
    fill_in "About Yourself", with: "I don't like to talk about me."
    choose I18n.t('yes')
    select(I18n.t('countries.SWE'), :from => 'Birth Country')
    fill_in "Birth Date", with: '31/12/1990'
    attach_file('Curriculum',  File.expand_path("../../support/files/blank.pdf", __FILE__))
    select 'Black', :from => 'Chocolate'
    check 'TV'
    check 'Refrigerator'
    click_on I18n.t(:subscribe)

    fill_in Subscription.human_attribute_name(:password),              with: '123456789'
    fill_in Subscription.human_attribute_name(:password_confirmation), with: '123456789'
    click_on I18n.t(:subscribe)

    page.should have_content(I18n.t(:'helpers.messages.subscription.successfully_created'))
    page.should have_content('123321123')
    page.should have_content('some@mail.com')
    page.should have_content('Some Great Event')
    page.should have_content('Some St.')
    page.should have_content('I don\'t like to talk about me.')
    page.should have_content(I18n.t('yes'))
    page.should have_content(I18n.t('countries.SWE'))
    page.should have_content(I18n.l(Date.new(1990,12,31), format: :long))
    page.should have_link(I18n.t(:download))
    page.should have_content('Black')
    page.should have_content('Refrigerator, TV')
    page.should have_link(I18n.t(:print_receipt))
  end
end
