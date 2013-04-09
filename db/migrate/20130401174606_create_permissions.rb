class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :user
      t.references :role

      t.timestamps
    end
    add_index :permissions, :user_id
    add_index :permissions, :role_id
  end
end
