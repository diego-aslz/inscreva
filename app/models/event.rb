class Event < ActiveRecord::Base

  has_many :fields, class_name: "EventField"
  attr_accessible :allow_edit, :closes_at, :email, :name, :opens_at, :rules_url,
      :technical_email, :fields_attributes

  validates_presence_of :name, :opens_at, :closes_at

  accepts_nested_attributes_for :fields, allow_destroy: true, :reject_if =>
      lambda { |f| f[:name].blank? }

  validate :valid_period?
  scope :ongoing, -> { where('? between opens_at and closes_at', Time.zone.now) }
  scope :future, -> { where('? < opens_at and closes_at', Time.zone.now) }

  def ongoing?
    opens_at && closes_at && Time.zone.now.between?(opens_at, closes_at)
  end

  def valid_period?
    errors[:closes_at] = I18n.t('helpers.errors.event.closes_at.too_soon') unless (
        closes_at.nil? || opens_at.nil? || closes_at > opens_at)
  end

  def to_s
    name
  end
end
