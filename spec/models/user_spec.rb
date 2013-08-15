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

  it "scopes by not subscribers, but includes them when they have some permission" do
    u1 = create(:user)
    u2 = create(:subscriber_user)

    User.all.include?(u1).should be_true
    User.all.include?(u2).should be_true

    User.not_subscribers.include?(u1).should be_true
    User.not_subscribers.include?(u2).should be_false

    create(:delegation, user_id: u2.id)
    User.not_subscribers.include?(u2).should be_true
  end
end
