require 'spec_helper'

describe Event do
  it "is ongoing when now is between opens_at and closes_at" do
    build(:ongoing_event).ongoing?.should be_true
  end

  it "is not ongoing by default" do
    e = Event.new
    e.ongoing?.should be_false
end

  it "is not ongoing when closes_at is in the past" do
    build(:past_event).ongoing?.should be_false
  end

  it "is not ongoing when opens_at is in the future" do
    build(:future_event).ongoing?.should be_false
  end

  it "is not valid when closes_at before opens_at" do
    event = build(:event) do |e|
      e.closes_at = e.opens_at - 1.day
    end
    event.valid?.should be_false
    event.errors[:closes_at].should_not be_nil
  end
end
