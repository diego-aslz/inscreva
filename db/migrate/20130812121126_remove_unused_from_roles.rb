class RemoveUnusedFromRoles < ActiveRecord::Migration
  def up
    remove_column :roles, :role_id
    remove_column :roles, :user_type
    remove_column :roles, :user_id
    remove_column :roles, :event_id
  end

  def down
    remove_index :roles, :event_id
    add_column :roles, :user_type, :string
    add_column :roles, :role_id, :integer
    add_column :roles, :user_id, :integer
    add_column :roles, :event_id, :integer
    add_index :roles, [:user_id, :user_type], name: 'index_permissions_on_user_id_and_user_type'
    add_index :roles, :event_id, name: 'index_permissions_on_event_id'
  end
end
