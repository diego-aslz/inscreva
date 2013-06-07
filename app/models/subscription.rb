class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  attr_accessible :details, :email, :id_card, :event_id
  validates_presence_of :email, :id_card, :event_id, :event
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validate :event_is_ongoing?, if: :event_id

  validates_confirmation_of :email, on: :create, message: I18n.t('helpers.
      errors.subscription.email.differs_from_confirmation')
  validates_presence_of :email_confirmation, on: :create

  private

  def event_is_ongoing?
    errors[:event_id] << I18n.t(
        'helpers.errors.subscription.event_id.not_ongoing') unless event && event.ongoing?
  end
end
