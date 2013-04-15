require 'spec_helper'

describe Event do
  it "can be ongoing" do
    e = Event.new
    e.ongoing?.should be_false
    e.opens_at = Time.zone.now - 2
    e.ongoing?.should be_false
    e.closes_at = Time.zone.now - 1
    e.ongoing?.should be_false
    e.closes_at = Time.zone.now + 2.days
    e.ongoing?.should be_true
    e.opens_at = Time.zone.now + 1.day
    e.ongoing?.should be_false
  end
end
