class CreateWikiFiles < ActiveRecord::Migration
  def change
    create_table :wiki_files do |t|
      t.belongs_to :wiki
      t.string :file
      t.string :name

      t.timestamps
    end
    add_index :wiki_files, :wiki_id
  end
end
