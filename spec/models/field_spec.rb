require 'spec_helper'

describe "Field" do
  let(:field) { Field.new }

  context "validating" do
    subject {field}

    it{ is_expected.to require_presence_of :field_type }
    it{ is_expected.to require_presence_of :name }
  end

  context "select field" do
    let(:field) { build(:select_field, extra: "3=A\r\n1=B\n2=C\n\n") }

    it "generates options for select input" do
      expect(field.select_options).to eq([["A", '3'], ["B", '1'], ["C", '2']])
    end

    it "extract the value using the key" do
      expect(field.select_value('3')).to eq('A')
      expect(field.select_value('1')).to eq('B')
    end
  end

  context "field types" do
    it "requires a valid field_type" do
      field.field_type = "12345"
      expect(field).to_not be_valid
      expect(field.errors[:field_type].size).to eq 1

      %w[string text select country check_boxes boolean date file].each do |type|
        field.field_type = type
        field.valid?
        expect(field.errors[:field_type].size).to eq 0
      end
    end

    it 'is file when field_type is "file"' do
      field.field_type = "file"
      expect(field).to be_file
    end
  end
end
