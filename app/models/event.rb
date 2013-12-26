class Event < ActiveRecord::Base
  has_many :fields, -> { order :priority, :group_name, :id }, dependent: :destroy
  has_many :subscriptions
  has_many :pages
  has_many :delegations
  has_many :notifications

  validates_presence_of :name, :identifier
  validates_uniqueness_of :identifier

  accepts_nested_attributes_for :fields, allow_destroy: true, :reject_if =>
      lambda { |f| f[:name].blank? }
  accepts_nested_attributes_for :delegations, allow_destroy: true, :reject_if =>
      lambda { |f| f[:user_id].blank? }

  validate :valid_period?
  scope :ongoing, -> { where('? between opens_at and closes_at', Time.zone.now) }
  scope :future, -> { where('? < opens_at and closes_at', Time.zone.now) }
  scope :by_name, ->(name) { where("lower(events.name) like lower(?)", "%#{name}%") }

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
      ff = nil
      ff = yield(f) if block_given?
      ff = FieldFill.new(field: f) unless ff
      result << ff
    end if fields
    result
  end

  def main_page
    pages.by_language(I18n.locale).where(main: true).first || pages.where(page_id: nil).first
  end

  def copy_fields_from(event)
    p = fields.last.try(:priority) || 0
    event.fields.each do |field|
      self.fields.build(field.attributes.with_indifferent_access.slice(
          :field_type, :name, :extra, :required, :show_receipt, :group_name,
          :searchable, :is_numeric, :hint, :allowed_file_extensions, :max_file_size).
          merge(priority: (p += 1)))
    end
  end

  def to_ng
    to_json(
      include: {
        fields: {},
        delegations: {
          include: {
            user: {
              only: [:id, :name]
            }
          }
        }
      }
    )
  end
end
