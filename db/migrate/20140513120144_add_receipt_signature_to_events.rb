class AddReceiptSignatureToEvents < ActiveRecord::Migration
  def change
    add_column :events, :receipt_signature, :boolean, default: false
  end
end
