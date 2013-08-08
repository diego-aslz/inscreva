class PageFile < ActiveRecord::Base
  belongs_to :page
  attr_accessible :file, :name
  mount_uploader :file, PublicFileUploader

  validates_presence_of :name
end
