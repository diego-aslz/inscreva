class AddContextToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :action, :string
    add_column :roles, :subject_class, :string
  end
end
