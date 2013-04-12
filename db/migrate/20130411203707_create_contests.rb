class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :name
      t.datetime :begin_at
      t.datetime :end_at
      t.boolean :allow_edit, default: false
      t.string :rules_url
      t.string :technical_email
      t.string :email

      t.timestamps
    end
  end
end
