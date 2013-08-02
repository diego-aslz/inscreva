class Wiki < ActiveRecord::Base
  has_many :wikis
  belongs_to :wiki
  belongs_to :event
  attr_accessible :content, :name, :wiki_id, :event_id, :title

  validates_presence_of :name, :event, :title
  validates_uniqueness_of :name, scope: :event_id
end
