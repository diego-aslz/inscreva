class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  attr_accessible :details, :email, :id_card, :event_id, :name
  serialize :details, Hash

  validates_uniqueness_of :number

  before_create :generate_number
  before_save :save_files

  FILE_STORE = 'public/files'

  def details_fields
    EventField.where(id: details.keys)
  end

  private

  def save_files
    details_fields.each do |f|
      if f.type == "file"
        upload = details[f.id.to_s]
        if upload
          dir = File.join FILE_STORE, f.id.to_s
          file_name = "candidate_#{number}#{File.extname(upload.original_filename)}"
          details[f.id.to_s] = File.join dir, file_name
          save_file_data upload, dir, file_name
        end
      end
    end

  def generate_number
    self.number = Time.zone.now.strftime("%Y%m%d%H%M%S") + sprintf("%03d", rand(999))
  end
end
