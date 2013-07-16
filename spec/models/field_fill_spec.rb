require 'spec_helper'

describe FieldFill do
  pending "validate when required"
  let(:fill) { build :field_fill }

  it "generates values for check_boxes input" do
    fill.value = '1,5'
    fill.value_cb.should == ['1', '5']
  end

  it "receives values from check_boxes input" do
    fill.value_cb = ['', '3', '5']
    fill.value.should == '3,5'
  end
end
