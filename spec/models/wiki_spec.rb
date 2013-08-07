# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Wiki do
  context 'validating' do
    let(:wiki) { build(:wiki) }
    subject { wiki }

    it { should require_presence_of :name }
    it { should require_presence_of :event }
    it { should require_presence_of :title }

    it "should validate uniqueness of name within the event" do
      should have(0).errors_on(:name)
      wiki2 = create(:wiki, name: wiki.name)
      should have(0).errors_on(:name)
      wiki2.update_attributes event_id: wiki.event_id
      should have(1).errors_on(:name)
    end
  end

  it 'should correct it\'s name to be a valid URL' do
    w = build(:wiki, name: 'Á_çabc?$% #@-')
    w.save
    w.name.should be_==('_abc--')
  end

  it "should resets the main page when a new main page is set to the event" do
    w1 = create(:wiki, main: true)
    w2 = create(:wiki, main: true, event_id: w1.event_id)
    w1.reload
    w2.reload
    w1.main.should be_false
    w2.main.should be_true

    w1.update_attribute :main, true
    w1.reload
    w2.reload
    w1.main.should be_true
    w2.main.should be_false

    create(:wiki, main: true)
    w1.reload
    w1.main.should be_true
  end
end
