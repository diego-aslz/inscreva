class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  attr_accessible :details, :email, :id_card, :event_id
  validates_presence_of :email, :id_card, :event_id
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end
