
module Concerns
  module FileFieldFill
    extend ActiveSupport::Concern

    included do
      mount_uploader :file, FileFieldUploader
      after_save :clean_remove_file
      validates_presence_of :file, if: :require_file?
      # validates :file, file_size: { maximum: 1.megabyte.to_i }
      validate :file_size
    end

    def changed?
      !!(super or remove_file)
    end

    def clean_remove_file
      self.remove_file = nil
    end

    private

    def require_file?
      field.required && field.file?
    end

    def file_size
      if file.try(:file) && field.max_file_size && file.file.size > field.max_file_size
        errors[:file] << I18n.t(:'activerecord.errors.messages.size_too_big',
            file_size: field.max_file_size)
      end
    end
  end
end
