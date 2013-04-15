require 'spec_helper'

describe "events/show" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :name => "Name",
      :allow_edit => false,
      :rules_url => "Rules Url",
      :technical_email => "Technical Email",
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/false/)
    rendered.should match(/Rules Url/)
    rendered.should match(/Technical Email/)
    rendered.should match(/Email/)
  end
end
