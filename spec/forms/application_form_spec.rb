require 'spec_helper'

describe 'ApplicationForm' do
  let(:user) { create(:user) }
  let(:event) { create(:ongoing_event) }
  let(:subscription) { ApplicationForm.new.load_from(attributes_for(
      :application_form).merge(event_id: event.id)) }

  context 'validating' do
    subject { subscription }

    it { should require_presence_of :name }
    it { should require_presence_of :id_card }
    it { should require_presence_of :event_id }
    it { should require_presence_of :email_confirmation, context: :create }
    it { should_not require_presence_of :email_confirmation, context: :update }
    it { should require_presence_of :email, errors: 2 }
    it { should require_confirmation_of :email }
    it { should require_confirmation_of :password }

    it { should require_valid(:email, valid: subscription.email,
        invalid: "anything") }
    it { should require_valid(:email, valid: subscription.email,
        invalid: "invalid_mail@example.com second_mail@example.com") }

    it "should validate that event is ongoing" do
      subscription.event_id = create(:past_event).id
      subscription.should have(1).errors_on(:event_id)
    end

    it "should validate that event exists" do
      subscription.event_id = -1
      subscription.should have(1).errors_on(:event_id)
    end

    let(:valid_fill) { build :required_field_fill, subscription_id: subscription.id }
    let(:invalid_fill) { build :required_field_fill, subscription_id: subscription.id, value: nil }
    it 'validates its field_fills' do
      Event.any_instance.stub(:fields).and_return [valid_fill.field, invalid_fill.field]
      subject.stub(:field_fills).and_return [valid_fill]
      expect(subject).to have(0).errors_on :field_fills
      subject.stub(:field_fills).and_return [invalid_fill]
      expect(subject).to have(1).errors_on :field_fills
    end

    context 'data confirmation' do
      it "is NOT confirmed if it's not valid yet" do
        subscription.confirmed = false
        subscription.name = nil
        subscription.valid?(:create).should be_false
        subscription.confirmed?.should be_false
      end

      it "is confirmed when everything else is valid" do
        subscription.confirmed = false
        subscription.valid?(:create).should be_false
        subscription.confirmed?.should be_true
        subscription.errors.count.should == 1
        subscription.errors[:base].should_not be_empty
      end

      it "is valid after confirmed" do
        subscription.confirmed = 'true'
        subscription.valid?(:create).should be_true
      end

      it "requires a password only after it's confirmed" do
        subscription.confirmed = 'false'
        subscription.password = nil
        subscription.password_confirmation = nil
        subscription.should_not be_valid(:create)
        subscription.confirmed?.should be_true
        subscription.errors[:password].size.should == 0

        subscription.should_not be_valid(:create)
        subscription.confirmed?.should be_true
        subscription.errors[:password].size.should > 0

        subscription.password = '123123123'
        subscription.password_confirmation = '12312312'
        subscription.should_not be_valid(:create)
        subscription.confirmed?.should be_true
        subscription.errors[:password_confirmation].size.should > 0

        subscription.password_confirmation = '123123123'
        subscription.valid?(:create)
        subscription.should be_valid(:create)
      end
    end

    context 'user creation' do
      it "validates the password when user exists" do
        subscription.email = user.email,
        subscription.email_confirmation = user.email
        subscription.password = user.password + 'a'
        subscription.password_confirmation = user.password + 'a'
        subscription.valid? :create
        subscription.errors[:password].count.should == 1
      end

      it "is valid when email is a new one" do
        subscription.email = 'another_email@teste.com'
        subscription.email_confirmation = 'another_email@teste.com'
        subscription.should have(0).errors_on(:password)
      end

      it "is valid when email exists and the password matches with its user" do
        subscription.email = user.email
        subscription.email_confirmation = user.email
        subscription.email = user.password
        subscription.email_confirmation = user.password
        subscription.should have(0).errors_on(:password)
      end
    end
  end

  context 'user creation' do
    it "generates a new user when e-mail is unique" do
      subscription.email = 'abc' + user.email
      subscription.email_confirmation = 'abc' + user.email
      expect { subscription.submit.should be_true }.to change(User, :count).by(1)
      subscription.user.should_not be_nil
      subscription.user.name.should_not be_empty
    end

    it "uses an existing user when e-mail is not unique" do
      subscription.email = user.email
      subscription.email_confirmation = user.email
      subscription.password = user.password
      subscription.password_confirmation = user.password
      expect { subscription.submit.should be_true }.not_to change(User, :count)
      subscription.user.should_not be_nil
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
      fills = event.field_fills
      event.should_receive(:field_fills).and_return fills
      form.field_fills.should == fills
    end

    context "subscription has a FieldFill for some Field" do
      it "should load the existing FieldFill instead of a new one" do
        fill = FieldFill.new(field: field, value: '12')
        subscription.field_fills << fill
        form.field_fills.should == [fill]
      end
    end
  end
end
