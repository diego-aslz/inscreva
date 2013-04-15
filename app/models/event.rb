class Event < ActiveRecord::Base
  attr_accessible :allow_edit, :closes_at, :email, :name, :opens_at, :rules_url,
      :technical_email

  validates_presence_of :name, :opens_at, :closes_at

  def ongoing?
    opens_at && closes_at && Time.zone.now.between?(opens_at, closes_at)
  end
end
