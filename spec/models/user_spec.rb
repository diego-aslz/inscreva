require 'spec_helper'

describe User do
  it 'has roles' do
    user = build(:user)
    role = build(:role)
    user.has_role?(role).should_not be_true
    user.roles << role
    user.has_role?(role).should be_true
  end
end
