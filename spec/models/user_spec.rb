require 'spec_helper'

describe User do
  it "is not admin by default" do
    expect(create(:user).admin?).to be_falsey
  end

  it "searches by name and email" do
    u = create(:user, name: 'searching', email: 'a@bcd.com')
    expect(User.search('cearchin').include?(u)).to be_falsey
    expect(User.search('earchin').include?(u)).to be_truthy
    expect(User.search('EARCHIN').include?(u)).to be_truthy
    u.update_attributes name: nil, email: 'searching@bcd.com'
    expect(User.search('cearchin').include?(u)).to be_falsey
    expect(User.search('earchin').include?(u)).to be_truthy
    expect(User.search('EARCHIN').include?(u)).to be_truthy
  end

  it "scopes by not subscribers, but includes them when they have some permission" do
    u1 = create(:user)
    u2 = create(:subscriber_user)

    expect(User.all.include?(u1)).to be_truthy
    expect(User.all.include?(u2)).to be_truthy

    expect(User.not_subscribers.include?(u1)).to be_truthy
    expect(User.not_subscribers.include?(u2)).to be_falsey

    create(:delegation, user_id: u2.id)
    expect(User.not_subscribers.include?(u2)).to be_truthy
  end
end
