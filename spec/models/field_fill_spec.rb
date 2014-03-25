# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FieldFill do
  let(:fill) { build :field_fill }

  context "being check_boxes" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'check_boxes') }

    it "generates values for check_boxes input" do
      fill.value = '1,5'
      fill.value_cb.should == ['1', '5']
    end

    it "receives values from check_boxes input" do
      fill.value_cb = ['', '3', '5']
      fill.value.should == '3,5'
    end

    it "shows its value as comma separated selected options" do
      fill.field.extra = "1=A\n2=B\n3=C"
      fill.value = nil
      fill.value_to_s.should == ''
      fill.value = '2,3'
      fill.value_to_s.should == 'B, C'
    end
  end

  context "being date" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'date') }

    it "generates a date from value" do
      fill.value = '2013-12-31'
      fill.value_date.should == '31/12/2013'
    end

    it "receives values from date input" do
      fill.value_date = '31/12/2013'
      fill.value.should == '2013-12-31'
    end

    it "shows its value as a date" do
      fill.value = nil
      fill.value_to_s.should == ''
      fill.value_date = '31/12/2013'
      fill.value_to_s.should == '31/12/2013'
    end
  end

  context "being country" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'country') }

    it "shows its value as a country" do
      fill.value = nil
      fill.value_to_s.should == ''
      fill.value = 'BRA'
      fill.value_to_s.should == 'Brasil'
    end
  end

  context "being boolean" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'boolean') }

    it "shows its value as a yes or no" do
      fill.value = nil
      fill.value_to_s.should == ''
      fill.value = 'true'
      fill.value_to_s.should == 'Sim'
      fill.value = 'false'
      fill.value_to_s.should == 'Não'
      fill.value = ''
      fill.value_to_s.should == ''
    end
  end

  context "being select" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'select') }

    it "shows its value with the selected option" do
      fill.field.extra = "1=A\n2=B\n3=C"
      fill.value = nil
      fill.value_to_s.should == ''
      fill.value = '2'
      fill.value_to_s.should == 'B'
    end
  end

  context "validating" do
    it "requires a value when Field is required" do
      fill.field.required = true
      fill.field.field_type = 'string'
      fill.should require_presence_of(:value)
      fill.field.required = false
      fill.should_not require_presence_of(:value)
    end

    it "does not require a file" do
      fill.field.required = true
      fill.field.field_type = 'string'
      fill.should_not require_presence_of(:file)
    end

    context 'is a File' do
      it "does not require a value" do
        fill.field.required = true
        fill.field.field_type = 'file'
        fill.should_not require_presence_of(:value)
      end

      it "requires a file when required is true" do
        fill.field.required = true
        fill.field.field_type = 'file'
        fill.should require_presence_of(:file)
        fill.field.required = false
        fill.should_not require_presence_of(:file)
      end

      it "requires a file with valid extension according to Field" do
        fill.field.required = true
        fill.field.field_type = 'file'
        fill.field.allowed_file_extensions = %w(png doc)

        fill.file = File.open '/tmp/test.png', 'w'
        fill.should be_valid

        fill.file = File.open '/tmp/test.doc', 'w'
        fill.should be_valid

        fill.file = File.open '/tmp/test.pdf', 'w'
        fill.should have(1).errors_on :file
      end

      it 'requires the file to not be greater than the size defined in the Field' do
        fill.field.max_file_size = 1.kilobyte
        fill.file = File.open "#{Rails.root}/spec/support/files/blank.pdf", 'r'
        fill.should have(1).errors_on :file

        fill.field.max_file_size = 2.kilobytes
        fill.should have(0).errors_on :file
        fill.field.max_file_size = 0
        fill.should have(0).errors_on :file
        fill.field.max_file_size = -1
        fill.should have(0).errors_on :file
      end
    end

    context 'field is numeric' do
      it "requires numericality of value" do
        fill.field.update_attributes is_numeric: true, required: false, field_type: 'string'
        fill.value = 'abc'
        fill.should have(1).errors_on(:value)
        fill.value = '123456'
        fill.should have(0).errors_on(:value)
        fill.value = ''
        fill.should have(0).errors_on(:value)
      end
    end

    context 'field is text' do
      it "requires value_text instead of value" do
        fill.field.update_attributes required: true, field_type: 'text'
        fill.value = nil
        fill.value_text = nil
        fill.should have(0).errors_on(:value)
        fill.should have(1).errors_on(:value_text)
        fill.value_text = '123456'
        fill.should have(0).errors_on(:value_text)
      end
    end
  end
end
