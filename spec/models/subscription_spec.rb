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

  it "validates event is ongoing" do
    build(:subscription, event_id: create(:past_event).id).should have(1).
        errors_on(:event_id)
  end

  it "validates event exists" do
    build(:subscription, event_id: -1).should have(1).
        errors_on(:event_id)
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

  it "validates email matches its confirmation" do
    build(:subscription, email: "valid_mail@example.com", email_confirmation: "123").
        should have(1).errors_on(:email)
  end

  it "validates presence of email_confirmation" do
    build(:subscription, email_confirmation: "").should have(1).
        errors_on(:email_confirmation)
  end
end
