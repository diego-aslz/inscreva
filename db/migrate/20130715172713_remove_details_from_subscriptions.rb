class RemoveDetailsFromSubscriptions < ActiveRecord::Migration
  def up
    remove_column :subscriptions, :details
  end

  def down
    add_column :subscriptions, :details, :text
  end
end
