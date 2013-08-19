class AddIsNumericToFields < ActiveRecord::Migration
  def change
    add_column :fields, :is_numeric, :boolean, default: false
  end
end
