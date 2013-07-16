require 'spec_helper'

describe "EventField" do
  describe "validating" do
    let(:event_field) { EventField.new }
    subject {event_field}

    it{ should require_presence_of :field_type }
    it{ should require_presence_of :name }
  end

  describe "select field" do
    let(:event_field) { build(:select_event_field, extra: "3=A\n1=B\n2=C\n\n") }

    it "generates options for select input" do
      event_field.select_options.should == [["A", '3'], ["B", '1'], ["C", '2']]
    end

    it "extract the value using the key" do
      event_field.select_value('3').should == 'A'
      event_field.select_value('1').should == 'B'
    end
  end
end
