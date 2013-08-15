require 'spec_helper'

describe User do
  it "is not admin by default" do
    create(:user).admin?.should be_false
  end

  it "searches by name and email" do
    u = create(:user, name: 'searching', email: 'a@bcd.com')
    User.search('cearchin').include?(u).should be_false
    User.search('earchin').include?(u).should be_true
    u.update_attributes name: nil, email: 'searching@bcd.com'
    User.search('cearchin').include?(u).should be_false
    User.search('earchin').include?(u).should be_true
  end
end
