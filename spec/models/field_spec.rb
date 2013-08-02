require 'spec_helper'

describe "Field" do
  let(:field) { Field.new }

  context "validating" do
    subject {field}

    it{ should require_presence_of :field_type }
    it{ should require_presence_of :name }
  end

  context "select field" do
    let(:field) { build(:select_field, extra: "3=A\r\n1=B\n2=C\n\n") }

    it "generates options for select input" do
      field.select_options.should == [["A", '3'], ["B", '1'], ["C", '2']]
    end

    it "extract the value using the key" do
      field.select_value('3').should == 'A'
      field.select_value('1').should == 'B'
    end
  end

  context "field types" do
    it "requires a valid field_type" do
      field.field_type = "12345"
      field.valid?
      field.should have(1).errors_on(:field_type)

      %w[string text select country check_boxes boolean date file].each do |type|
        field.field_type = type
        field.should have(0).errors_on(:field_type)
      end
    end

    it 'is file when field_type is "file"' do
      field.field_type = "file"
      field.should be_file
    end
  end
end
