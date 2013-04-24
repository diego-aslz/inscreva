class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :id_card
      t.string :email
      t.belongs_to :event
      t.text :details

      t.timestamps
    end
    add_index :subscriptions, :event_id
  end
end
