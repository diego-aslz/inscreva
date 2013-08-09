require 'spec_helper'

describe User do
  it "is not admin by default" do
    create(:user).admin?.should be_false
  end
end
