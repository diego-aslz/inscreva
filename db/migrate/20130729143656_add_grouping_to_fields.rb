class AddGroupingToFields < ActiveRecord::Migration
  def change
    add_column :fields, :group_name, :string
    add_column :fields, :priority, :integer, default: 0
  end
end
