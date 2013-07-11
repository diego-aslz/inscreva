class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  attr_accessible :details, :email, :id_card, :event_id, :name
  serialize :details, Hash

  validates_uniqueness_of :number

  before_create :generate_number

  def details_fields
    EventField.where(id: details.keys)
  end

  private

  def generate_number
    self.number = Time.zone.now.strftime("%Y%m%d%H%M%S") + sprintf("%03d", rand(999))
  end
end
