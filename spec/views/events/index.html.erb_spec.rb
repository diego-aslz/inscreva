require 'spec_helper'

describe "events/index" do
  before(:each) do
    assign(:events, [
      stub_model(Event,
        :name => "Name",
        :allow_edit => false,
        :rules_url => "Rules Url",
        :technical_email => "Technical Email",
        :email => "Email"
      ),
      stub_model(Event,
        :name => "Name",
        :allow_edit => true,
        :rules_url => "Rules Url",
        :technical_email => "Technical Email",
        :email => "Email"
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => t('no'), :count => 1
    assert_select "tr>td", :text => t('yes'), :count => 1
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
