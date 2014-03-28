# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Subscription" do
  let(:admin) { create(:admin, password: '123456789', password_confirmation: '123456789') }

  before(:each) do
    sign_in admin, '123456789'
  end

  it "does not show a filter that is not searchable" do
    f = create(:field, field_type: 'string', name: 'Test Address', searchable: false)
    visit event_subscriptions_path(f.event)
    page.should_not have_content('Test Address', count: 2)
    page.should_not have_selector("input#field_#{f.id}[type=text]")
  end

  it "filters a String field" do
    f = create(:field, field_type: 'string', name: 'Test Address', searchable: true)
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value: 'ABC')
    s2.field_fills << create(:field_fill, field_id: f.id, value: 'DEF')

    visit event_subscriptions_path(f.event)
    page.should have_content('Test Address', count: 2)
    page.should have_selector("input#field_#{f.id}[type=text]")
    page.should have_content(s1.number)
    page.should have_content(s2.number)

    fill_in 'Test Address', with: 'BC'
    click_button I18n.t(:search)
    page.should have_content(s1.number)
    page.should_not have_content(s2.number)
  end

  it "filters a Text field" do
    f = create(:field, field_type: 'text', name: 'Big Text Example', searchable: true)
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value_text: 'ABC')
    s2.field_fills << create(:field_fill, field_id: f.id, value_text: 'DEF')

    visit event_subscriptions_path(f.event)
    page.should have_content('Big Text Example', count: 2)
    page.should have_selector("input#field_#{f.id}[type=text]")
    page.should have_content(s1.number)
    page.should have_content(s2.number)

    fill_in 'Big Text Example', with: 'BC'
    click_button I18n.t(:search)
    page.should have_content(s1.number)
    page.should_not have_content(s2.number)
  end

  it "filters a Boolean field" do
    f = create(:field, field_type: 'boolean', name: 'Is it', searchable: true)
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value: 'true')
    s2.field_fills << create(:field_fill, field_id: f.id, value: 'false')

    visit event_subscriptions_path(f.event)
    page.should have_content('Is it', count: 2)
    within "select#field_#{f.id}" do
      page.should have_selector("option[value=true]")
      page.should have_selector("option[value=false]")
    end
    page.should have_content(s1.number)
    page.should have_content(s2.number)

    select(I18n.t('yes'), :from => 'Is it')
    click_button I18n.t(:search)
    page.should have_content(s1.number)
    page.should_not have_content(s2.number)
  end

  it "filters a CheckBoxes field" do
    f = create(:field, field_type: 'check_boxes', name: 'You Eat', searchable: true,
        extra: "A=ABC\nB10=DEF")
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value_cb: ['A', 'B10'])
    s2.field_fills << create(:field_fill, field_id: f.id, value_cb: ['A'])

    visit event_subscriptions_path(f.event)
    page.should have_content('You Eat', count: 2)
    page.should have_selector("input#field_#{f.id}_A[type=checkbox][value=A]")
    page.should have_selector("input#field_#{f.id}_B10[type=checkbox][value=B10]")
    page.should have_content(s1.number)
    page.should have_content(s2.number)

    check 'ABC'
    click_button I18n.t(:search)
    page.should have_content(s1.number)
    page.should have_content(s2.number)

    uncheck 'ABC'
    check 'DEF'
    click_button I18n.t(:search)
    page.should have_content(s1.number)
    page.should_not have_content(s2.number)
  end

  it "filters a Country field" do
    f = create(:field, field_type: 'country', name: 'Birth Country', searchable: true)
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value: 'BRA')
    s2.field_fills << create(:field_fill, field_id: f.id, value: 'PRY')

    visit event_subscriptions_path(f.event)
    page.should have_content('Birth Country', count: 2)
    page.should have_selector("input#field_#{f.id}_BRA[type=checkbox][value=BRA]")
    page.should have_selector("input#field_#{f.id}_PRY[type=checkbox][value=PRY]")
    page.should have_content(s1.number)
    page.should have_content(s2.number)

    check I18n.t(:'countries.BRA')
    click_button I18n.t(:search)
    page.should have_content(s1.number)
    page.should_not have_content(s2.number)
  end

  it "filters a Date field" do
    f = create(:field, field_type: 'date', name: 'Birth Date', searchable: true)
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value_date: '01/01/1980')
    s2.field_fills << create(:field_fill, field_id: f.id, value_date: '01/01/1981')

    visit event_subscriptions_path(f.event)
    page.should have_content('Birth Date', count: 2)
    page.should have_selector("input#field_#{f.id}_b[type=text]")
    page.should have_selector("input#field_#{f.id}_e[type=text]")
    page.should have_content(s1.number)
    page.should have_content(s2.number)

    fill_in "field_#{f.id}_b", with: '01/01/1980'
    fill_in "field_#{f.id}_e", with: '01/01/1980'
    click_button I18n.t(:search)
    page.should have_content(s1.number)
    page.should_not have_content(s2.number)
  end

  it "filters a Select field" do
    f = create(:field, field_type: 'select', name: 'Choose One', searchable: true,
        extra: "A=ABC\nB10=DEF")
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value: 'A')
    s2.field_fills << create(:field_fill, field_id: f.id, value: 'B10')

    visit event_subscriptions_path(f.event)
    page.should have_content('Choose One', count: 2)
    page.should have_selector("input#field_#{f.id}_A[type=checkbox][value=A]")
    page.should have_selector("input#field_#{f.id}_B10[type=checkbox][value=B10]")
    page.should have_content(s1.number)
    page.should have_content(s2.number)

    check 'ABC'
    click_button I18n.t(:search)
    page.should have_content(s1.number)
    page.should_not have_content(s2.number)
  end

  it "shows a String field when it is included" do
    f = create(:field, field_type: 'string', name: 'Test Address', searchable: true)
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value: 'ABC')
    s2.field_fills << create(:field_fill, field_id: f.id, value: 'DEF')

    visit event_subscriptions_path(f.event)
    page.find('table').should_not have_content("ABC")
    page.find('table').should_not have_content("DEF")
    select 'Test Address'
    click_on "Buscar"
    page.find('table').should have_content("ABC")
    page.find('table').should have_content("DEF")
  end

  it "shows a Text field when it is included" do
    f = create(:field, field_type: 'text', name: 'Big Text Example', searchable: true)
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value_text: 'ABC')
    s2.field_fills << create(:field_fill, field_id: f.id, value_text: 'DEF')

    visit event_subscriptions_path(f.event)
    page.find('table').should_not have_content("ABC")
    page.find('table').should_not have_content("DEF")
    select 'Big Text Example'
    click_on "Buscar"
    page.find('table').should have_content("ABC")
    page.find('table').should have_content("DEF")
  end

  it "shows a Boolean field when it is included" do
    f = create(:field, field_type: 'boolean', name: 'Is it', searchable: true)
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value: 'true')
    s2.field_fills << create(:field_fill, field_id: f.id, value: 'false')

    visit event_subscriptions_path(f.event)
    page.find('table').should_not have_content("Sim")
    page.find('table').should_not have_content("Não")
    select 'Is it'
    click_on "Buscar"
    page.find('table').should have_content("Sim")
    page.find('table').should have_content("Não")
  end

  it "shows a CheckBoxes field when it is included" do
    f = create(:field, field_type: 'check_boxes', name: 'You Eat', searchable: true,
        extra: "A=ABC\nB10=DEF")
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value_cb: ['A', 'B10'])
    s2.field_fills << create(:field_fill, field_id: f.id, value_cb: ['A'])

    visit event_subscriptions_path(f.event)
    page.find('table').should_not have_content("ABC")
    page.find('table').should_not have_content("DEF")
    select 'You Eat'
    click_on "Buscar"
    page.find('table').should have_content("ABC")
    page.find('table').should have_content("DEF")
  end

  it "shows a Country field when it is included" do
    f = create(:field, field_type: 'country', name: 'Birth Country', searchable: true)
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value: 'BRA')
    s2.field_fills << create(:field_fill, field_id: f.id, value: 'PRY')

    visit event_subscriptions_path(f.event)
    page.find('table').should_not have_content("Brasil")
    page.find('table').should_not have_content("Paraguai")
    select 'Birth Country'
    click_on "Buscar"
    page.find('table').should have_content("Brasil")
    page.find('table').should have_content("Paraguai")
  end

  it "shows a Date field when it is included" do
    f = create(:field, field_type: 'date', name: 'Birth Date', searchable: true)
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value_date: '01/01/1980')
    s2.field_fills << create(:field_fill, field_id: f.id, value_date: '01/01/1981')

    visit event_subscriptions_path(f.event)
    page.find('table').should_not have_content("01/01/1980")
    page.find('table').should_not have_content("01/01/1981")
    select 'Birth Date'
    click_on "Buscar"
    page.find('table').should have_content("01/01/1980")
    page.find('table').should have_content("01/01/1981")
  end

  it "shows a Select field when it is included" do
    f = create(:field, field_type: 'select', name: 'Choose One',
        extra: "A=ABC\nB10=DEF")
    s1 = create :subscription, event_id: f.event_id
    s2 = create :subscription, event_id: f.event_id
    s1.field_fills << create(:field_fill, field_id: f.id, value: 'A')
    s2.field_fills << create(:field_fill, field_id: f.id, value: 'B10')

    visit event_subscriptions_path(f.event)
    page.find('table').should_not have_content("ABC")
    page.find('table').should_not have_content("DEF")
    select 'Choose One'
    click_on "Buscar"
    page.find('table').should have_content("ABC")
    page.find('table').should have_content("DEF")
  end
end
