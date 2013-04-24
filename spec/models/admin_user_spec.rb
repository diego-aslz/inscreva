require 'spec_helper'

describe AdminUser do
  before do
    @user = build(:admin_user) do |u|
      u.roles << build(:role)
    end
  end

  it 'has roles' do
    @user.has_role?(build(:candidate_role)).should_not be_true
    @user.has_role?(build(:role)).should be_true
  end
end
