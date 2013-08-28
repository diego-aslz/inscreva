class RemoveAllowEditFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :allow_edit
  end

  def down
    add_column :events, :allow_edit, :boolean
  end
end
