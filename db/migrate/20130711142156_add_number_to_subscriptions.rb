class AddNumberToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :number, :string
  end
end
