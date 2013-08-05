class Wiki < ActiveRecord::Base
  has_many :wikis
  has_many :wiki_files
  belongs_to :wiki
  belongs_to :event, :counter_cache => true
  attr_accessible :content, :name, :wiki_id, :event_id, :title

  validates_presence_of :name, :event, :title
  validates_uniqueness_of :name, scope: :event_id
end