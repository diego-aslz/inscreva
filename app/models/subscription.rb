class Subscription < ActiveRecord::Base
  belongs_to :event, :counter_cache => true
  belongs_to :user
  has_many :field_fills, -> { includes :field }
  has_many :fills, class_name: 'FieldFill', dependent: :destroy

  validates_uniqueness_of :number

  accepts_nested_attributes_for :field_fills
  scope :search, lambda { |term|
    where("upper(concat(subscriptions.name,subscriptions.email," +
        "subscriptions.number)) like upper(?)", "%#{term}%")
  }

  scope :by_field, ->(field_id, value, type=nil) {
    table = "field_fills_#{field_id}"
    i = joins("LEFT OUTER JOIN field_fills #{table} ON " +
        "subscriptions.id = #{table}.subscription_id").references(:field_fills)
    type = Field.where(id: field_id).pluck(:field_type).first unless type
    return i unless valid_filter?(field_id, value, type)
    i = i.where "#{table}.field_id = ?", field_id

    if type == "date"
      clauses = []
      pars = []
      if !value[:b].blank? && (val = Concerns::DateFieldFill.to_date(value[:b]))
        clauses << "#{table}.value >= ?"
        pars << val
      end
      if !value[:e].blank? && (val = Concerns::DateFieldFill.to_date(value[:e]))
        clauses << "#{table}.value <= ?"
        pars << val
      end
      i.where(clauses.join(' and '), *pars)
    elsif %w(select country).include? type
      i.where("#{table}.value in (?)", value)
    elsif 'string' == type
      i.where("#{table}.value like ?", "%#{value}%")
    elsif 'text' == type
      i.where("#{table}.value_text like ?", "%#{value}%")
    elsif type == "check_boxes"
      clauses = []
      pars = []
      for val in value
        clauses << "FIND_IN_SET(?, #{table}.value) > 0"
        pars << val
      end
      i.where("(#{clauses.join ' or '})", *pars)
    else
      i.where("#{table}.value = ?", value)
    end
  }

  before_create :generate_number

  def receipt_fills
    field_fills.joins(:field).where('fields.show_receipt')
  end

  def self.to_csv(options = {})
    fields = ["created_at", "number", "name"] + (options.delete(:selects) || [])
    include_fields = options.delete(:include_fields) || []
    CSV.generate(options) do |csv|
      csv << fields.map { |f| self.human_attribute_name f } + include_fields.map(&:name)
      all.each do |sub|
        values = sub.attributes.values_at(*fields) + include_fields.map{ |f|
          fill = sub.field_fills.where(field_id: f.id).first
          next fill.value_to_s if fill
          ''
        }
        csv << values
      end
    end
  end

  def generate_number
    begin
      self.number = Time.zone.now.strftime("%y%m%d%H%M%S") + sprintf("%03d", rand(999))
    end while Subscription.exists? number: self.number
  end

  def self.valid_filter?(field_id, value, type)
    return false unless value
    (type == "date" and !(value[:b].blank? and value[:e].blank?)) or
    (type != "date" and not value.blank?)
  end
end
