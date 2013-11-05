class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  serialize :filters, Hash
  serialize :recipients, Array

  validates_format_of :respond, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :subject, :message, :respond, :recipients_text, presence: true

  before_save :sanitize_filters!

  def subscriptions
    s = Subscription.where(event_id: event_id)
    filters.each_pair do |k,v|
      s = s.by_field k, v[:value], v[:type]
    end if filters
    s
  end

  def sanitize_filters!
    filters.reject!{ |k,v| !Subscription.valid_filter?(k, v[:value], v[:type]) } if filters
  end

  def load_recipients
    self.recipients = subscriptions.pluck(:email).uniq
  end

  def recipients_text
    recipients.join(', ')
  end

  def recipients_text=(text)
    self.recipients = text.gsub(/[\s\n]/, '').split(',').reject &:blank?
  end
end
