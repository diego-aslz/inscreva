class AddAllowedFileExtensionsToFields < ActiveRecord::Migration
  def change
    add_column :fields, :allowed_file_extensions, :text
  end
end
