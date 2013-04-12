require 'spec_helper'

describe "contests/new" do
  before(:each) do
    assign(:contest, stub_model(Contest,
      :name => "MyString",
      :allow_edit => false,
      :rules_url => "MyString",
      :technical_email => "MyString",
      :email => "MyString"
    ).as_new_record)
  end

  it "renders new contest form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contests_path, "post" do
      assert_select "input#contest_name[name=?]", "contest[name]"
      assert_select "input#contest_allow_edit[name=?]", "contest[allow_edit]"
      assert_select "input#contest_rules_url[name=?]", "contest[rules_url]"
      assert_select "input#contest_technical_email[name=?]", "contest[technical_email]"
      assert_select "input#contest_email[name=?]", "contest[email]"
    end
  end
end
