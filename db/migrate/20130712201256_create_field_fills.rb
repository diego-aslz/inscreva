class CreateFieldFills < ActiveRecord::Migration
  def change
    create_table :field_fills do |t|
      t.belongs_to :event_field
      t.belongs_to :subscription
      t.string :type
      t.string :value
      t.string :file

      t.timestamps
    end
    add_index :field_fills, :event_field_id
    add_index :field_fills, :subscription_id
  end
end
