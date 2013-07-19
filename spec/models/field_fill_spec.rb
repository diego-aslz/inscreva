require 'spec_helper'

describe FieldFill do
  let(:fill) { build :field_fill }

  it "generates values for check_boxes input" do
    fill.value = '1,5'
    fill.value_cb.should == ['1', '5']
  end

  it "receives values from check_boxes input" do
    fill.value_cb = ['', '3', '5']
    fill.value.should == '3,5'
  end

  context "validating" do
    it "requires a value when Field is required and not a file" do
      fill.field.required = true
      fill.field.field_type = 'string'
      fill.should require_presence_of(:value)
      fill.field.required = false
      fill.should_not require_presence_of(:value)
    end

    it "does not require a value when Field is a file" do
      fill.field.required = true
      fill.field.field_type = 'file'
      fill.should_not require_presence_of(:value)
    end

    it "requires a file when Field is required and is a file" do
      fill.field.required = true
      fill.field.field_type = 'file'
      fill.should require_presence_of(:file)
      fill.field.required = false
      fill.should_not require_presence_of(:file)
    end

    it "does not require a file when Field is not a file" do
      fill.field.required = true
      fill.field.field_type = 'string'
      fill.should_not require_presence_of(:file)
    end
  end
end
