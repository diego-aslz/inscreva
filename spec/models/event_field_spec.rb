require 'spec_helper'

describe "EventField" do
  let(:event_field) { EventField.new }

  context "validating" do
    subject {event_field}

    it{ should require_presence_of :field_type }
    it{ should require_presence_of :name }
  end

  context "select field" do
    let(:event_field) { build(:select_event_field, extra: "3=A\r\n1=B\n2=C\n\n") }

    it "generates options for select input" do
      event_field.select_options.should == [["A", '3'], ["B", '1'], ["C", '2']]
    end

    it "extract the value using the key" do
      event_field.select_value('3').should == 'A'
      event_field.select_value('1').should == 'B'
    end
  end

  context "field types" do
    it "requires a valid field_type" do
      event_field.field_type = "12345"
      event_field.valid?
      event_field.should have(1).errors_on(:field_type)

      %w[string text select country check_boxes boolean date file].each do |type|
        event_field.field_type = type
        event_field.should have(0).errors_on(:field_type)
      end
    end

    it 'is file when field_type is "file"' do
      event_field.field_type = "file"
      event_field.should be_file
    end
  end
end
