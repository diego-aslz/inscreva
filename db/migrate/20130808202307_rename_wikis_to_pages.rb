class RenameWikisToPages < ActiveRecord::Migration
  def up
    rename_column :wikis, :wiki_id, :page_id
    rename_table :wikis, :pages
    rename_column :wiki_files, :wiki_id, :page_id
    rename_table :wiki_files, :page_files
    rename_column :events, :wikis_count, :pages_count
  end

  def down
    rename_column :pages, :page_id, :wiki_id
    rename_table :pages, :wikis
    rename_column :page_files, :page_id, :wiki_id
    rename_table :page_files, :wiki_files
    rename_column :events, :pages_count, :wikis_count
  end
end
