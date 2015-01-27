# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Page do
  context 'validating' do
    let(:page) { build(:page) }
    subject { page }

    it { is_expected.to require_presence_of :name }
    it { is_expected.to require_presence_of :event }
    it { is_expected.to require_presence_of :title }

    it "should validate uniqueness of name within the event" do
      expect(subject).to be_valid
      expect(subject.errors[:name].size).to eq 0
      page2 = create(:page, name: page.name)
      expect(subject).to be_valid
      expect(subject.errors[:name].size).to eq 0
      page2.update_attributes event_id: page.event_id
      expect(subject).to_not be_valid
      expect(subject.errors[:name].size).to eq 1
    end
  end

  it 'should correct it\'s name to be a valid URL' do
    w = build(:page, name: 'Á_çabc?$% #@-')
    w.save
    expect(w.name).to eq('_abc--')
  end

  it "should reset the main page when a new main page is set to the event" do
    w1 = create(:page, main: true)
    w2 = create(:page, main: true, event_id: w1.event_id)
    w1.reload
    w2.reload
    expect(w1.main).to be_falsey
    expect(w2.main).to be_truthy

    w1.update_attribute :main, true
    w1.reload
    w2.reload
    expect(w1.main).to be_truthy
    expect(w2.main).to be_falsey

    create(:page, main: true)
    w1.reload
    expect(w1.main).to be_truthy
  end

  it 'searches by a text' do
    s = create(:page, name: 'nametosearchby')
    expect(Page.search('ametosearchb').include?(s)).to be_truthy
    s.update_attribute :name, 'A'
    s.update_attribute :title, 'nametosearchby'
    expect(Page.search('ametosearchb').include?(s)).to be_truthy
    expect(Page.search('anythingelse').include?(s)).to be_falsey
  end

  it "scopes by the language, including the ones without it" do
    p1 = create(:page, language: 'pt-BR')
    p2 = create(:page, language: 'es')
    p3 = create(:page, language: nil)
    pages = Page.by_language('es')
    expect(pages.include?(p1)).to be_falsey
    expect(pages.include?(p2)).to be_truthy
    expect(pages.include?(p3)).to be_truthy
  end
end
