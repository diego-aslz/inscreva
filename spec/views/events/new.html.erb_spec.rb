require 'spec_helper'

describe "events/new" do
  before(:each) do
    assign(:event, stub_model(Event,
      :name => "MyString",
      :allow_edit => false,
      :rules_url => "MyString",
      :technical_email => "MyString",
      :email => "MyString"
    ).as_new_record)
  end

  it "renders new event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", events_path, "post" do
      assert_select "input#event_name[name=?]", "event[name]"
      assert_select "input#event_allow_edit[name=?]", "event[allow_edit]"
      assert_select "input#event_rules_url[name=?]", "event[rules_url]"
      assert_select "input#event_technical_email[name=?]", "event[technical_email]"
      assert_select "input#event_email[name=?]", "event[email]"
    end
  end
end
