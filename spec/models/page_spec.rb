# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Page do
  context 'validating' do
    let(:page) { build(:page) }
    subject { page }

    it { should require_presence_of :name }
    it { should require_presence_of :event }
    it { should require_presence_of :title }

    it "should validate uniqueness of name within the event" do
      should have(0).errors_on(:name)
      page2 = create(:page, name: page.name)
      should have(0).errors_on(:name)
      page2.update_attributes event_id: page.event_id
      should have(1).errors_on(:name)
    end
  end

  it 'should correct it\'s name to be a valid URL' do
    w = build(:page, name: 'Á_çabc?$% #@-')
    w.save
    w.name.should be_==('_abc--')
  end

  it "should resets the main page when a new main page is set to the event" do
    w1 = create(:page, main: true)
    w2 = create(:page, main: true, event_id: w1.event_id)
    w1.reload
    w2.reload
    w1.main.should be_false
    w2.main.should be_true

    w1.update_attribute :main, true
    w1.reload
    w2.reload
    w1.main.should be_true
    w2.main.should be_false

    create(:page, main: true)
    w1.reload
    w1.main.should be_true
  end

  it 'searches by a text' do
    s = create(:page, name: 'nametosearchby')
    Page.search('ametosearchb').include?(s).should be_true
    s.update_attribute :name, 'A'
    s.update_attribute :title, 'nametosearchby'
    Page.search('ametosearchb').include?(s).should be_true
    Page.search('anythingelse').include?(s).should be_false
  end
end
