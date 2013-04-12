require 'spec_helper'

describe Contest do
  it "can be ongoing" do
    c = Contest.new
    c.ongoing?.should be_false
    c.begin_at = Time.zone.now - 2
    c.ongoing?.should be_false
    c.end_at = Time.zone.now - 1
    c.ongoing?.should be_false
    c.end_at = Time.zone.now + 2.days
    c.ongoing?.should be_true
    c.begin_at = Time.zone.now + 1.day
    c.ongoing?.should be_false
  end
end
