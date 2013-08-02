class WikiFile < ActiveRecord::Base
  belongs_to :wiki
  attr_accessible :file, :name
  mount_uploader :file, WikiFileUploader
end
