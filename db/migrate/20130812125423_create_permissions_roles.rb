class CreatePermissionsRoles < ActiveRecord::Migration
  def change
    create_table :permissions_roles, id: false do |t|
      t.belongs_to :permission
      t.belongs_to :role
    end
    add_index :permissions_roles, :permission_id
    add_index :permissions_roles, :role_id
  end
end
