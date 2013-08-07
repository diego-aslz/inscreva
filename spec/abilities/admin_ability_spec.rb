require 'spec_helper'
require "cancan/matchers"

describe "AdminUser" do
  describe "abilities" do
    subject { ability }
    let(:ability){ Ability.new(user) }
    let(:user){ create(:admin_user) }

    it{ should     be_able_to(:show,     Wiki) }
  end
end
