class RenameEventFieldToFieldInFieldFills < ActiveRecord::Migration
  def up
    rename_column :field_fills, :event_field_id, :field_id
  end

  def down
    rename_column :field_fills, :field_id, :event_field_id
  end
end
