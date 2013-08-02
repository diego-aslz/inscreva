class AddCacheCountersToEvents < ActiveRecord::Migration
  def up
    add_column :events, :wikis_count, :integer, default: 0
    add_column :events, :subscriptions_count, :integer, default: 0

    Event.reset_column_information
    Event.all.each do |ev|
      Event.update_counters ev.id, wikis_count: ev.wikis.length
      Event.update_counters ev.id, subscriptions_count: ev.subscriptions.length
    end
  end

  def down
    remove_column :events, :wikis_count
    remove_column :events, :subscriptions_count
  end
end
