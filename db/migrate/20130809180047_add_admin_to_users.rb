class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
    User.update_all admin: false
    admin = User.find_by_email 'admin@inscreva.com'
    admin.update_attribute :admin, true if admin
    Role.delete_all name: 'superadmin'
  end
end
