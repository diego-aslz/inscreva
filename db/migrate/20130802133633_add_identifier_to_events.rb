class AddIdentifierToEvents < ActiveRecord::Migration
  def change
    add_column :events, :identifier, :string
  end
end
