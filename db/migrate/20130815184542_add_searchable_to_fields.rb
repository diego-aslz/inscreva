class AddSearchableToFields < ActiveRecord::Migration
  def change
    add_column :fields, :searchable, :boolean, default: false
  end
end
