class AddHintToFields < ActiveRecord::Migration
  def change
    add_column :fields, :hint, :string
  end
end
