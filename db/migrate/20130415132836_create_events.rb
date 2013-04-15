class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :opens_at
      t.datetime :closes_at
      t.boolean :allow_edit
      t.string :rules_url
      t.string :technical_email
      t.string :email

      t.timestamps
    end
  end
end
