class ReverseRolesAndPermissions < ActiveRecord::Migration
  def up
    rename_table :roles, :roles1
    rename_table :permissions, :roles
    rename_table :roles1, :permissions
  end

  def down
    rename_table :roles, :roles1
    rename_table :permissions, :roles
    rename_table :roles1, :permissions
  end
end
