class Event < ActiveRecord::Base
  attr_accessible :allow_edit, :closes_at, :email, :name, :opens_at, :rules_url,
      :technical_email, :fields_attributes
  validates_presence_of :name, :opens_at, :closes_at
  has_many :fields, class_name: "EventField"
  accepts_nested_attributes_for :fields, allow_destroy: true, :reject_if =>
      lambda { |f| f[:name].blank? }

  def ongoing?
    opens_at && closes_at && Time.zone.now.between?(opens_at, closes_at)
  end
end
