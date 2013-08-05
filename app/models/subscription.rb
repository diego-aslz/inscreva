class Subscription < ActiveRecord::Base
  belongs_to :event, :counter_cache => true
  belongs_to :user
  has_many :field_fills, dependent: :destroy, include: :field

  validates_uniqueness_of :number

  attr_accessible :field_fills_attributes, :email, :id_card, :event_id, :name
  accepts_nested_attributes_for :field_fills
  scope :search, lambda { |term|
    where("upper(concat(name,email,number)) like upper(?)", "%#{term}%")
  }

  before_create :generate_number

  def receipt_fills
    field_fills.joins(:field).where('fields.show_receipt')
  end

  private

  def generate_number
    begin
      self.number = Time.zone.now.strftime("%y%m%d%H%M%S") + sprintf("%03d", rand(999))
    end while Subscription.exists? number: self.number
  end
end
