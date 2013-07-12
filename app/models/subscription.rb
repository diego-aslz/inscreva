class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  attr_accessible :details, :email, :id_card, :event_id, :name
  serialize :details, Hash

  validates_uniqueness_of :number

  before_save :save_files

  FILE_STORE = '/tmp/files'

  def details_fields
    EventField.where(id: details.keys)
  end

  private

  def save_files
    generate_number unless self.number
    details_fields.each do |f|
      if f.field_type == "file"
        upload = details[f.id.to_s]
        if upload
          file_name = "subscription_#{number}#{File.extname(upload.original_filename)}"
          details[f.id.to_s] = file_name
          save_file_data upload, File.join(FILE_STORE, f.id.to_s), file_name
        end
      end
    end
  end

  def save_file_data(data, dir, file_name)
    if data
      FileUtils.mkdir_p dir
      File.open(File.join(dir, file_name), "wb") { |f| f.write(data.read) }
    end
  end

  def generate_number
    self.number = Time.zone.now.strftime("%Y%m%d%H%M%S") + sprintf("%03d", rand(999))
  end
end
