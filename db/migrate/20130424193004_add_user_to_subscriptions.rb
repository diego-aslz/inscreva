class AddUserToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :user_id, :integer
    add_index :subscriptions, :user_id
  end
end
