# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FieldFill do
  let(:fill) { build :field_fill }

  context "being check_boxes" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'check_boxes') }

    it "generates values for check_boxes input" do
      fill.value = '1,5'
      expect(fill.value_cb).to eq(['1', '5'])
    end

    it "receives values from check_boxes input" do
      fill.value_cb = ['', '3', '5']
      expect(fill.value).to eq('3,5')
    end

    it "shows its value as comma separated selected options" do
      fill.field.extra = "1=A\n2=B\n3=C"
      fill.value = nil
      expect(fill.value_to_s).to eq('')
      fill.value = '2,3'
      expect(fill.value_to_s).to eq('B, C')
    end
  end

  context "being date" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'date') }

    it "generates a date from value" do
      fill.value = '2013-12-31'
      expect(fill.value_date).to eq('31/12/2013')
    end

    it "receives values from date input" do
      fill.value_date = '31/12/2013'
      expect(fill.value).to eq('2013-12-31')
    end

    it "shows its value as a date" do
      fill.value = nil
      expect(fill.value_to_s).to eq('')
      fill.value_date = '31/12/2013'
      expect(fill.value_to_s).to eq('31/12/2013')
    end
  end

  context "being country" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'country') }

    it "shows its value as a country" do
      fill.value = nil
      expect(fill.value_to_s).to eq('')
      fill.value = 'BRA'
      expect(fill.value_to_s).to eq('Brasil')
    end
  end

  context "being text" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'text') }

    it "uses the value_text field" do
      fill.value_text = 'long text'
      expect(fill.value_to_s).to eq('long text')
    end
  end

  context "being boolean" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'boolean') }

    it "shows its value as a yes or no" do
      fill.value = nil
      expect(fill.value_to_s).to eq('')
      fill.value = 'true'
      expect(fill.value_to_s).to eq('Sim')
      fill.value = 'false'
      expect(fill.value_to_s).to eq('Não')
      fill.value = ''
      expect(fill.value_to_s).to eq('')
    end
  end

  context "being select" do
    let(:fill) { build :field_fill, field: build(:field, field_type: 'select') }

    it "shows its value with the selected option" do
      fill.field.extra = "1=A\n2=B\n3=C"
      fill.value = nil
      expect(fill.value_to_s).to eq('')
      fill.value = '2'
      expect(fill.value_to_s).to eq('B')
    end
  end

  context "validating" do
    it "requires a value when Field is required" do
      fill.field.required = true
      fill.field.field_type = 'string'
      expect(fill).to require_presence_of(:value)
      fill.field.required = false
      expect(fill).not_to require_presence_of(:value)
    end

    it "does not require a file" do
      fill.field.required = true
      fill.field.field_type = 'string'
      expect(fill).not_to require_presence_of(:file)
    end

    context 'is a File' do
      it "does not require a value" do
        fill.field.required = true
        fill.field.field_type = 'file'
        expect(fill).not_to require_presence_of(:value)
      end

      it "requires a file when required is true" do
        fill.field.required = true
        fill.field.field_type = 'file'
        expect(fill).to require_presence_of(:file)
        fill.field.required = false
        expect(fill).not_to require_presence_of(:file)
      end

      it "requires a file with valid extension according to Field" do
        fill.field.required = true
        fill.field.field_type = 'file'
        fill.field.allowed_file_extensions = %w(png doc)

        fill.file = File.open '/tmp/test.png', 'w'
        expect(fill).to be_valid

        fill.file = File.open '/tmp/test.doc', 'w'
        expect(fill).to be_valid

        fill.file = File.open '/tmp/test.pdf', 'w'
        expect(fill).to_not be_valid
        expect(fill.errors[:file].size).to eq 1
      end

      it 'requires the file to not be greater than the size defined in the Field' do
        fill.field.max_file_size = 1.kilobyte
        fill.file = File.open "#{Rails.root}/spec/support/files/blank.pdf", 'r'
        expect(fill).to_not be_valid
        expect(fill.errors[:file].size).to eq 1

        fill.field.max_file_size = 2.kilobytes
        expect(fill).to be_valid
        expect(fill.errors[:file].size).to eq 0
        fill.field.max_file_size = 0
        expect(fill).to be_valid
        expect(fill.errors[:file].size).to eq 0
        fill.field.max_file_size = -1
        expect(fill).to be_valid
        expect(fill.errors[:file].size).to eq 0
      end
    end

    context 'field is numeric' do
      it "requires numericality of value" do
        fill.field.update_attributes is_numeric: true, required: false, field_type: 'string'
        fill.value = 'abc'
        expect(fill).to_not be_valid
        expect(fill.errors[:value].size).to eq(1)
        fill.value = '123456'
        expect(fill).to be_valid
        expect(fill.errors[:value].size).to eq(0)
        fill.value = ''
        expect(fill).to be_valid
        expect(fill.errors[:value].size).to eq(0)
      end
    end

    context 'field is text' do
      it "requires value_text instead of value" do
        fill.field.update_attributes required: true, field_type: 'text'
        fill.value = nil
        fill.value_text = nil
        expect(fill).to_not be_valid
        expect(fill.errors[:value].size).to eq(0)
        expect(fill.errors[:value_text].size).to eq(1)
        fill.value_text = '123456'
        expect(fill).to be_valid
        expect(fill.errors[:value_text].size).to eq(0)
      end
    end
  end
end
