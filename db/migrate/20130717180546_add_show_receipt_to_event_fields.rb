class AddShowReceiptToEventFields < ActiveRecord::Migration
  def change
    add_column :event_fields, :show_receipt, :boolean, default: false
  end
end
