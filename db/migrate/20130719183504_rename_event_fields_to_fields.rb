class RenameEventFieldsToFields < ActiveRecord::Migration
  def up
    rename_table :event_fields, :fields
  end

  def down
    rename_table :fields, :event_fields
  end
end
