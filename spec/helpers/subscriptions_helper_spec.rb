require 'spec_helper'

describe 'SubscriptionsHelper' do
  include SubscriptionsHelper

  context "checking if a filter is valid" do
    it "is valid when it's a date and there is a begining date or an ending date" do
      filter_valid?(1, {b: '', e: ''}, 'date').should be_false
      filter_valid?(1, {b: 'a', e: ''}, 'date').should be_true
      filter_valid?(1, {b: '', e: 'a'}, 'date').should be_true
      filter_valid?(1, {b: 'a', e: 'a'}, 'date').should be_true
    end

    it "is valid when it's not a date and there is some value" do
      filter_valid?(1, '', 'string').should be_false
      filter_valid?(1, 'a', 'string').should be_true
    end

    it 'is valid when it\'s about check_boxes and there is some value' do
      filter_valid?(1, [], 'check_boxes').should be_false
      filter_valid?(1, ['a'], 'check_boxes').should be_true
    end
  end

  context "generating clause and parameters for filters" do
    it 'generates a like statement for string, and text' do
      clause, params = filter_clause(1, 'a', 'string')
      clause.should include("like ?")
      params.should include('%a%')

      clause, params = filter_clause(1, 'a', 'text')
      clause.should include("like ?")
      params.should include('%a%')
    end

    it 'filters date with begin and end' do
      clause, params = filter_clause(1, {b: '30/12/2013'}, 'date')
      clause.should include(">= ?")
      clause.should_not include("<= ?")
      params.should == [1, '2013-12-30']

      clause, params = filter_clause(1, {e: '31/12/2013'}, 'date')
      clause.should include("<= ?")
      clause.should_not include(">= ?")
      params.should == [1, '2013-12-31']

      clause, params = filter_clause(1, {b: '30/12/2013', e: '31/12/2013'}, 'date')
      clause.should include("<= ?")
      clause.should include(">= ?")
      params.should == [1, '2013-12-30', '2013-12-31']
    end

    it 'generates a FIND_IN_SET statement for check_boxes' do
      clause, params = filter_clause(1, [1, 2], 'check_boxes')
      clause.should include("FIND_IN_SET(?, field_fills.value) > 0")
      clause.scan("FIND_IN_SET(?, field_fills.value) > 0").size.should == 2
      params.should == [1, 1, 2]
    end

    it 'generates an equals statement for any other type' do
      clause, params = filter_clause(1, 'true', 'boolean')
      clause.should include("= ?")
      params.should include('true')
    end

    it "generates an IN statement for country, and select" do
      clause, params = filter_clause(1, ['a', 'b'], 'select')
      clause.should include("in (?)")
      params.should == [1, ['a', 'b']]

      clause, params = filter_clause(2, ['BRA', 'PRY'], 'country')
      clause.should include("in (?)")
      params.should == [2, ['BRA', 'PRY']]
    end
  end
end
