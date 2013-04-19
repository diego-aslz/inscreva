ActiveAdmin.register User do
  filter :email
  filter :name

  index do
    column :email
    column :name
    column :current_sign_in_ip
    column :created_at
  end
end
