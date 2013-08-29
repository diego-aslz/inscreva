class Subscription < ActiveRecord::Base
  belongs_to :event, :counter_cache => true
  belongs_to :user
  has_many :field_fills, dependent: :destroy, include: :field
  has_many :fills, class_name: 'FieldFill'

  validates_uniqueness_of :number

  attr_accessible :field_fills_attributes, :email, :id_card, :event_id, :name
  accepts_nested_attributes_for :field_fills
  scope :search, lambda { |term|
    where("upper(concat(subscriptions.name,subscriptions.email," +
        "subscriptions.number)) like upper(?)", "%#{term}%")
  }

  before_create :generate_number

  def receipt_fills
    field_fills.joins(:field).where('fields.show_receipt')
  end

  def self.to_csv(options = {})
    fields = ["created_at", "number", "name", "email"]
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

  private

  def generate_number
    begin
      self.number = Time.zone.now.strftime("%y%m%d%H%M%S") + sprintf("%03d", rand(999))
    end while Subscription.exists? number: self.number
  end
end
