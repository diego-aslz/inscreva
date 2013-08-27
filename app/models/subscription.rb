class Subscription < ActiveRecord::Base
  belongs_to :event, :counter_cache => true
  belongs_to :user
  has_many :field_fills, dependent: :destroy, include: :field

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
    fields = ["number", "name", "email"]
    CSV.generate(options) do |csv|
      csv << fields.map { |f| self.human_attribute_name f }
      all.each do |sub|
        csv << sub.attributes.values_at(*fields)
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
