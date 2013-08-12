require 'spec_helper'
require "cancan/matchers"

describe "User" do
  let(:user){ create(:admin) }

  describe "abilities" do
    subject { ability }
    let(:ability){ Ability.new(user) }

    it{ should be_able_to(:manage, :all) }
  end
end
