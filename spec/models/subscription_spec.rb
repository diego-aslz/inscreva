require 'spec_helper'

describe Subscription do
  it "validates presence of email" do
    build(:subscription, email: "").should have(2).errors_on(:email)
  end

  it "validates presence of id_card" do
    build(:subscription, id_card: "").should have(1).errors_on(:id_card)
  end

  it "validates presence of event_id" do
    build(:subscription, event_id: "").should have(1).errors_on(:event_id)
  end

  it "validates email" do
    build(:subscription, email: "anything").should have(1).errors_on(:email)
    build(:subscription, email: "valid_mail@example.com second_mail@example.com").
        should have(1).errors_on(:email)
  end

  it "validates email" do
    build(:subscription, email: "valid_mail@example.com").should have(0).
        errors_on(:email)
  end
end
