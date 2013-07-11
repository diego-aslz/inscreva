class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  attr_accessible :details, :email, :id_card, :event_id, :name
  serialize :details, Hash

  before_save :save_files

  FILE_STORE = 'public/files'

  def details_fields
    EventField.where(id: details.keys)
  end

  def save_files
    details_fields.each do |f|
      if f.type == "file"
        upload = details[f.id.to_s]
        if upload
          file_name = "candidate_#{id}#{File.extname(upload.original_filename)}"
          dir = File.join FILE_STORE, f.id.to_s
          details[f.id.to_s] = File.join dir, file_name
          save_file_data upload, dir, file_name
        end
      end
    end
  end
end
