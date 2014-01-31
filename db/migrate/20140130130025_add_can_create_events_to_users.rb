class AddCanCreateEventsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_create_events, :boolean, default: false
  end
end
