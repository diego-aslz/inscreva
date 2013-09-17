class AddMaxFileSizeToField < ActiveRecord::Migration
  def change
    add_column :fields, :max_file_size, :integer
  end
end
