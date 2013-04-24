require 'spec_helper'

describe User do
  before do
    @user = build(:user) do |u|
      u.roles << build(:candidate_role)
    end
  end

  it 'has roles' do
    @user.has_role?(build(:candidate_role)).should be_true
    @user.has_role?(build(:role)).should_not be_true
  end
end
