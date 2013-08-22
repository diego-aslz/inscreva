class Event < ActiveRecord::Base
  has_many :fields, order: [:priority, :group_name, :id], dependent: :destroy
  has_many :subscriptions
  has_many :pages
  has_many :delegations
  attr_accessible :allow_edit, :closes_at, :email, :name, :opens_at, :rules_url,
      :technical_email, :fields_attributes, :delegations_attributes, :identifier,
      :published

  validates_presence_of :name, :identifier
  validates_uniqueness_of :identifier

  accepts_nested_attributes_for :fields, allow_destroy: true, :reject_if =>
      lambda { |f| f[:name].blank? }
  accepts_nested_attributes_for :delegations, allow_destroy: true, :reject_if =>
      lambda { |f| f[:user_id].blank? }

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

  def field_fills
    result = []
    fields.each do |f|
      result << FieldFill.new
      result.last.field = f
    end if fields
    result
  end

  def main_page
    pages.by_language(I18n.locale).where(main: true).first || pages.where(page_id: nil).first
  end
end
