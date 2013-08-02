class CreateWikis < ActiveRecord::Migration
  def change
    create_table :wikis do |t|
      t.string :name
      t.string :title
      t.integer :wiki_id
      t.integer :event_id
      t.text :content

      t.timestamps
    end
    add_index :wikis, :wiki_id
    add_index :wikis, :event_id
  end
end
