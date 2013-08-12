class CreateDelegations < ActiveRecord::Migration
  def change
    create_table :delegations do |t|
      t.belongs_to :user
      t.belongs_to :event
      t.belongs_to :role

      t.timestamps
    end
    add_index :delegations, :user_id
    add_index :delegations, :event_id
    add_index :delegations, :role_id
  end
end
