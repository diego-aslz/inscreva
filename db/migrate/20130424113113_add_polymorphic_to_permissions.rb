class AddPolymorphicToPermissions < ActiveRecord::Migration
  def up
    remove_index :permissions, :user_id
    remove_column :permissions, :user_id
    add_column :permissions, :user_id, :integer
    add_column :permissions, :user_type, :string
    add_index :permissions, [:user_id, :user_type]
  end

  def down
    remove_index :permissions, [:user_id, :user_type]
    remove_column :permissions, :user_id
    remove_column :permissions, :user_type
    add_column :permissions, :user_id, :integer
    add_index :permissions, :user_id
  end
end
