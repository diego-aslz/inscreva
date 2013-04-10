require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.build(:user)
    @user.save validate: false
  end

  it 'searches users' do
    User.search(@user.email[0..5]).count.should be_> 0
    User.search('inexistent_email').count.should be_zero
  end

  it 'has roles' do
    r = FactoryGirl.create(:role)
    @user.roles << r
    @user.has_role?(r.name).should be_true
    @user.has_role?('inexistent_role').should_not be_true
  end
end
