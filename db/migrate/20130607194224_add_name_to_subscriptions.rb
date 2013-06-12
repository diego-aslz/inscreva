class AddNameToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :name, :string
  end
end
