class RemoveNameFromRoles < ActiveRecord::Migration
  def up
    remove_column :roles, :name
  end

  def down
    add_column :roles, :name, :string
  end
end
