class CreateEventFields < ActiveRecord::Migration
  def change
    create_table :event_fields do |t|
      t.string :name
      t.string :field_type
      t.boolean :required
      t.belongs_to :event

      t.timestamps
    end
    add_index :event_fields, :event_id
  end
end
