require 'spec_helper'

describe "contests/index" do
  before(:each) do
    assign(:contests, [
      stub_model(Contest,
        :name => "Name",
        :allow_edit => false,
        :rules_url => "Rules Url",
        :technical_email => "Technical Email",
        :email => "Email"
      ),
      stub_model(Contest,
        :name => "Name",
        :allow_edit => false,
        :rules_url => "Rules Url",
        :technical_email => "Technical Email",
        :email => "Email"
      )
    ])
  end

  it "renders a list of contests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Rules Url".to_s, :count => 2
    assert_select "tr>td", :text => "Technical Email".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
