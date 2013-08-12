class AddEventToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :event_id, :integer
    add_index :permissions, :event_id
  end
end
