class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  attr_accessible :details, :email, :id_card, :event_id, :name
  serialize :details, Hash

  def details_fields
    EventField.where(id: details.keys)
  end
end
