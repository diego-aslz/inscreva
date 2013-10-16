class PageFile < ActiveRecord::Base
  belongs_to :page
  mount_uploader :file, PublicFileUploader

  validates_presence_of :name
end
