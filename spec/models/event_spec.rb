require 'spec_helper'

describe Event do
  context "validating" do
    let(:event) { build :event, opens_at: Time.now }
    subject { event }

    it { is_expected.to require_presence_of(:name) }
    it { is_expected.to require_presence_of(:identifier) }
    it { is_expected.to require_uniqueness_of(:identifier, used_value: create(:event).identifier) }
    it { is_expected.to require_valid(:closes_at, invalid: event.opens_at - 1.day,
        valid: event.opens_at + 1.day) }
  end

  it "is ongoing when now is between opens_at and closes_at" do
    expect(build(:ongoing_event).ongoing?).to be_truthy
  end

  it "is not ongoing by default" do
    expect(Event.new.ongoing?).to be_falsey
  end

  it "is not ongoing when closes_at is in the past" do
    expect(build(:past_event).ongoing?).to be_falsey
  end

  it "is not ongoing when opens_at is in the future" do
    expect(build(:future_event).ongoing?).to be_falsey
  end

  it "is not ongoing when opens_at or closes_at are null" do
    expect(build(:ongoing_event, opens_at: nil).ongoing?).to be_falsey
    expect(build(:ongoing_event, closes_at: nil).ongoing?).to be_falsey
    expect(build(:ongoing_event, opens_at: nil, closes_at: nil).ongoing?).to be_falsey
  end

  it "scopes ongoing events" do
    curr = create(:ongoing_event)
    past = create(:past_event)
    future = create(:future_event)
    events = Event.ongoing
    expect(events.include?(curr)).to be_truthy
    expect(events.include?(past)).to be_falsey
    expect(events.include?(future)).to be_falsey
  end

  it "scopes future events" do
    curr = create(:ongoing_event)
    past = create(:past_event)
    future = create(:future_event)
    events = Event.future
    expect(events.include?(curr)).to be_falsey
    expect(events.include?(past)).to be_falsey
    expect(events.include?(future)).to be_truthy
  end

  it 'copies fields from another event' do
    f1 = create(:field, name: 'Field 1')
    f2 = create(:field, name: 'Field 2', event_id: f1.event_id, extra: '1=A',
        group_name: 'Testtt', allowed_file_extensions: ['pdf'], max_file_size: 1,
        hint: 'Hintt')
    e1 = f1.event

    e2 = create(:event)
    e2.copy_fields_from e1
    expect(e2.fields.size).to eq(2)
    expect(e2.fields[0].name).to eq(f1.name)
    expect(e2.fields[1].name).to eq(f2.name)
    expect(e2.fields[1].extra).to eq(f2.extra)
    expect(e2.fields[1].group_name).to eq(f2.group_name)
    expect(e2.fields[1].allowed_file_extensions).to eq(f2.allowed_file_extensions)
    expect(e2.fields[1].max_file_size).to eq(f2.max_file_size)
    expect(e2.fields[1].hint).to eq(f2.hint)

    expect(e2.fields[0].priority).to eq(1)
    expect(e2.fields[1].priority).to eq(2)

    e2.fields << Field.new(name: "Another One", priority: 3)
    e2.copy_fields_from e1
    expect(e2.fields.size).to eq(5)
    expect(e2.fields[3].name).to eq(f1.name)
    expect(e2.fields[4].name).to eq(f2.name)
    expect(e2.fields[3].priority).to eq(4)
    expect(e2.fields[4].priority).to eq(5)

    expect(e2.save).to be_truthy
    expect(e2.fields[4]).not_to be_new_record
  end

  describe "for_main_page" do
    let(:past_event)          { create(:past_event,    published: true) }
    let(:ongoing_event)       { create(:ongoing_event, published: true) }
    let(:not_published_event) { create(:ongoing_event, published: false) }
    let(:future_event)        { create(:future_event,  published: true) }

    subject { Event.for_main_page }

    before(:each) do
      past_event
      ongoing_event
      not_published_event
      future_event
    end

    it {
      is_expected.to     include(ongoing_event)
      is_expected.to     include(future_event)
      is_expected.not_to include(past_event)
      is_expected.not_to include(not_published_event)
    }
  end
end
