class AddMainToWikis < ActiveRecord::Migration
  def change
    add_column :wikis, :main, :boolean
  end
end
