class AddExtraToEventField < ActiveRecord::Migration
  def change
    add_column :event_fields, :extra, :text
  end
end
