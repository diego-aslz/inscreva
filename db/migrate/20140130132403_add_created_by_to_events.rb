class AddCreatedByToEvents < ActiveRecord::Migration
  def change
    add_column :events, :created_by_id, :integer
    add_index :events, :created_by_id
  end
end
