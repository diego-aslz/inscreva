class AddReceiptTitleToEvents < ActiveRecord::Migration
  def change
    add_column :events, :receipt_title, :string, size: 100
  end
end
