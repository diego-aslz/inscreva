require 'spec_helper'

describe 'ApplicationForm' do
  let(:user) { create(:user) }
  let(:event) { create(:ongoing_event) }
  let(:subscription) { ApplicationForm.new.load_from(attributes_for(
      :application_form).merge(event_id: event.id)) }

  context 'validating' do
    subject { subscription }

    it { is_expected.to require_presence_of :name }
    it { is_expected.to require_presence_of :id_card }
    it { is_expected.to require_presence_of :event_id }
    it { is_expected.to require_presence_of :email_confirmation, context: :create }
    it { is_expected.not_to require_presence_of :email_confirmation, context: :update }
    it { is_expected.to require_presence_of :email, errors: 2 }
    it { is_expected.to require_confirmation_of :email }
    it { is_expected.to require_confirmation_of :password }

    it { is_expected.to require_valid(:email, valid: subscription.email,
        invalid: "anything") }
    it { is_expected.to require_valid(:email, valid: subscription.email,
        invalid: "invalid_mail@example.com second_mail@example.com") }

    it "should validate that event is ongoing" do
      subscription.event_id = create(:past_event).id
      expect(subscription).to_not be_valid
      expect(subscription.errors[:event_id].size).to eq 1
    end

    it "should validate that event exists" do
      subscription.event_id = -1
      expect(subscription).to_not be_valid
      expect(subscription.errors[:event_id].size).to eq 1
    end

    let(:valid_fill) { build :required_field_fill, subscription_id: subscription.id }
    let(:invalid_fill) { build :required_field_fill, subscription_id: subscription.id, value: nil }
    it 'validates its field_fills' do
      allow_any_instance_of(Event).to receive(:fields).and_return [valid_fill.field, invalid_fill.field]
      allow(subject).to receive(:field_fills).and_return [valid_fill]
      expect(subscription).to be_valid
      expect(subscription.errors[:field_fills].size).to eq 0
      allow(subject).to receive(:field_fills).and_return [invalid_fill]
      expect(subscription).to_not be_valid
      expect(subscription.errors[:field_fills].size).to eq 1
    end

    context 'data confirmation' do
      it "is NOT confirmed if it's not valid yet" do
        subscription.confirmed = false
        subscription.name = nil
        expect(subscription.valid?(:create)).to be_falsey
        expect(subscription.confirmed?).to be_falsey
      end

      it "is confirmed when everything else is valid" do
        subscription.confirmed = false
        expect(subscription.valid?(:create)).to be_falsey
        expect(subscription.confirmed?).to be_truthy
        expect(subscription.errors.count).to eq(1)
        expect(subscription.errors[:base]).not_to be_empty
      end

      it "is valid after confirmed" do
        subscription.confirmed = 'true'
        expect(subscription.valid?(:create)).to be_truthy
      end

      it "requires a password only after it's confirmed" do
        subscription.confirmed = 'false'
        subscription.password = nil
        subscription.password_confirmation = nil
        expect(subscription).not_to be_valid(:create)
        expect(subscription.confirmed?).to be_truthy
        expect(subscription.errors[:password].size).to eq(0)

        expect(subscription).not_to be_valid(:create)
        expect(subscription.confirmed?).to be_truthy
        expect(subscription.errors[:password].size).to be > 0

        subscription.password = '123123123'
        subscription.password_confirmation = '12312312'
        expect(subscription).not_to be_valid(:create)
        expect(subscription.confirmed?).to be_truthy
        expect(subscription.errors[:password_confirmation].size).to be > 0

        subscription.password_confirmation = '123123123'
        subscription.valid?(:create)
        expect(subscription).to be_valid(:create)
      end
    end

    context 'user creation' do
      it "validates the password when user exists" do
        subscription.email = user.email
        subscription.email_confirmation = user.email
        subscription.password = user.password + 'a'
        subscription.password_confirmation = user.password + 'a'
        subscription.valid? :create
        expect(subscription.errors[:password].count).to eq(1)
      end

      it "is valid when email is a new one" do
        subscription.email = 'another_email@teste.com'
        subscription.email_confirmation = 'another_email@teste.com'
        expect(subscription).to be_valid
        expect(subscription.errors[:password].size).to eq 0
      end

      it "is valid when email exists and the password matches with its user" do
        subscription.email = user.email
        subscription.email_confirmation = user.email
        subscription.email = user.password
        subscription.email_confirmation = user.password
        subscription.valid?
        expect(subscription.errors[:password].size).to eq 0
      end
    end
  end

  context 'user creation' do
    it "generates a new user when e-mail is unique" do
      subscription.email = 'abc' + user.email
      subscription.email_confirmation = 'abc' + user.email
      expect { expect(subscription.submit).to be_truthy }.to change(User, :count).by(1)
      expect(subscription.user).not_to be_nil
      expect(subscription.user.name).not_to be_empty
    end

    it "uses an existing user when e-mail is not unique" do
      subscription.email = user.email
      subscription.email_confirmation = user.email
      subscription.password = user.password
      subscription.password_confirmation = user.password
      expect { expect(subscription.submit).to be_truthy }.not_to change(User, :count)
      expect(subscription.user).not_to be_nil
    end
  end

  describe "field_fills" do
    let(:event)        { Event.new }
    let(:subscription) { Subscription.new(event: event) }
    let(:form)         { ApplicationForm.new(subscription: subscription) }
    let(:field)        { Field.new(id: 1) }

    before(:each) do
      event.fields << field
    end

    it "loads the field_fills from the event" do
      fills = form.field_fills
      expect(fills.length).to eq(1)
      expect(fills[0].field_id).to eq(1)
    end

    context "subscription has a FieldFill for some Field" do
      it "should load the existing FieldFill instead of a new one" do
        fill = FieldFill.new(field: field, value: '12')
        subscription.field_fills << fill
        expect(form.field_fills).to eq([fill])
      end
    end
  end
end
