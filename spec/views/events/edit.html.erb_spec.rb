require 'spec_helper'

describe "events/edit" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :name => "MyString",
      :allow_edit => false,
      :rules_url => "MyString",
      :technical_email => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", event_path(@event), "post" do
      assert_select "input#event_name[name=?]", "event[name]"
      assert_select "input#event_allow_edit[name=?]", "event[allow_edit]"
      assert_select "input#event_rules_url[name=?]", "event[rules_url]"
      assert_select "input#event_technical_email[name=?]", "event[technical_email]"
      assert_select "input#event_email[name=?]", "event[email]"
    end
  end
end
