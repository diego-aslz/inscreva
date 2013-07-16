require 'spec_helper'
require "cancan/matchers"

describe "SuperAdminUser" do
  describe "abilities" do
    subject { ability }
    let(:ability){ Ability.new(user) }
    let(:user){ create(:superadmin) }

    it{ should     be_able_to(:manage, :all) }
  end
end
