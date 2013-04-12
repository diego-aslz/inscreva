class Contest < ActiveRecord::Base
  attr_accessible :allow_edit, :begin_at, :email, :end_at, :name, :rules_url,
      :technical_email

  validates_presence_of :name, :begin_at, :end_at

  def ongoing?
    begin_at && end_at && Time.zone.now.between?(begin_at, end_at)
  end
end
