class ApplicationForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  ATTRIBUTES = [:password, :password_confirmation, :email_confirmation]
  attr_accessor *ATTRIBUTES

  validate :event_is_ongoing?, if: :event_id
  validate :valid_user?, on: :create
  validates_presence_of :email, :id_card, :event_id, :event, :name
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_confirmation_of :email, message: I18n.t('helpers.' +
      'errors.subscription.email.differs_from_confirmation')
  validates_confirmation_of :password
  validates_presence_of :password, on: :create
  validates_presence_of :email_confirmation, if: :email
  validates_presence_of :password_confirmation, if: :password

  delegate :details, :email, :id_card, :event_id, :event, :name, :user_id, :user,
      to: :subscription
  delegate :details=, :email=, :id_card=, :event_id=, :event=, :name=, :user_id=,
      :user=, :persisted?, :new_record?, to: :subscription

  def load_from(params)
    if params
      subscription.attributes = params.slice(:details, :email, :id_card,
          :event_id, :name)
      ATTRIBUTES.each { |att| send("#{att}=", params[att]) }
    end
    self
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Subscription")
  end

  def event_name
    event.name if event
  end

  def subscription
    @subscription ||= Subscription.new
  end

  def submit(params = nil)
    load_from params if params
    if valid? (new_record? ? :create : :update)
      subscription.user_id ||= User.create!(email: email, password: password,
          password_confirmation: password_confirmation).id
      subscription.save!
      true
    else
      false
    end
  end

  private

  def event_is_ongoing?
    errors[:event_id] << I18n.t('helpers.errors.subscription.event_id.' +
        'not_ongoing') unless event && event.ongoing?
  end

  def valid_user?
    valid = (self.user = User.where(email: email).first).nil? || self.user.
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
    end
  end
end
