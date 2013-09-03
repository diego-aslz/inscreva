class ApplicationForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveRecord::Validations

  ATTRIBUTES = [:password, :password_confirmation, :email_confirmation, :confirmed]
  attr_accessor *ATTRIBUTES

  validate :event_is_ongoing?, if: :event_id
  validate :valid_user?, on: :create
  validates_presence_of :email, :id_card, :event_id, :event, :name
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_confirmation_of :email, message: I18n.t('helpers.errors.' +
      'subscription.email.differs_from_confirmation')
  validates_confirmation_of :password, if: :validate_password?
  validates_presence_of :password, on: :create, if: :validate_password?
  validates_presence_of :email_confirmation, if: :email, on: :create
  validates_presence_of :password_confirmation, if: :password
  validates_associated :field_fills, includes: :field

  delegate :field_fills, :email, :id_card, :event_id, :event, :name, :user_id, :user,
      :id, :generate_number, to: :subscription
  delegate :field_fills=, :field_fills_attributes=, :email=, :id_card=, :event_id=,
      :event=, :name=, :user_id=, :user=, :persisted?, :new_record?, to: :subscription

  def load_from(params, user = nil)
    subscription
    if params
      subscription.attributes = params.slice(:email, :id_card, :event_id, :name,
          :field_fills_attributes)
      ATTRIBUTES.each { |att| send("#{att}=", params[att]) }
    end
    self.confirmed = false if self.confirmed.nil?
    if user && (last = user.subscriptions.last)
      self.name = last.name
      self.id_card = last.id_card
      self.email = last.email
      self.email_confirmation = last.email
    end
    self
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Subscription")
  end

  def self.human_attribute_name(*args)
    Subscription.human_attribute_name *args
  end

  def event_name
    event.name if event
  end

  def subscription
    @subscription ||= Subscription.new
  end

  def subscription=(s)
    @subscription = s
  end

  def submit(params = nil)
    load_from params if params
    if valid? (new_record? ? :create : :update)
      subscription.user_id ||= User.create!(email: email, password: password,
          password_confirmation: password_confirmation, name: name).id
      subscription.save!
      true
    else
      false
    end
  end

  def confirmed?
    self.confirmed == 'true'
  end

  def valid?(context = nil)
    valid = super(context)
    if valid && !confirmed? && context == :create
      errors.add :base, I18n.t('helpers.errors.subscription.confirm')
      self.confirmed = 'true'
      return false
    end
    valid
  end

  private

  def event_is_ongoing?
    errors[:event_id] << I18n.t('helpers.errors.subscription.event_id.' +
        'not_ongoing') unless event && event.ongoing?
  end

  def valid_user?
    valid = self.user || (self.user = User.where(email: email).first).nil? || self.user.
        valid_password?(password)
    unless valid
      helper = Rails.application.routes.url_helpers
      base_helper = ActionController::Base.helpers
      errors.add :password, I18n.t('helpers.errors.subscription.' +
          'password.invalid')
      msg = I18n.t('helpers.errors.subscription.invalid_user',
          password_link: base_helper.link_to(I18n.t('helpers.links.password_link'),
              helper.new_user_password_path, target: :_blank)).html_safe
      errors.add :base, msg
      self.user = nil
    end
  end

  def validate_password?
    !user && confirmed?
  end
end
