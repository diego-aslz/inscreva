class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.string :requirement
      t.integer :vacation
      t.integer :special_vacation
      t.belongs_to :event

      t.timestamps
    end
    add_index :areas, :event_id
  end
end
