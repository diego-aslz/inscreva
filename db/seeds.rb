
unless User.any?
  admin = User.create! name: 'Admin', email: 'admin@inscreva.com',
      password: 'admin1234', password_confirmation: 'admin1234', admin: true
end

event_permissions = {
    [:edit, :update, :show, :index] => 'Event',
    [:edit, :update, :show, :index, :new, :create] => 'Page',
    [:edit, :update, :show, :index, :new, :create, :receipt] => 'Subscription'
  }
unless Permission.any?
  event_permissions.each do |k,v|
    for permission in k do
      Permission.create!(action: permission.to_s, subject_class: v)
    end
  end
end

# Default roles
unless Role.any?
  manager = Role.create!(name: 'Manager')
  event_permissions.each do |k,v|
    for permission in k do
      p = Permission.where(action: permission.to_s, subject_class: v).first
      manager.permissions << p if p
    end
  end

  consultant = Role.create!(name: 'Consultant')
  {
    [:show, :index] => 'Event',
    [:show, :index] => 'Page',
    [:show, :index, :receipt] => 'Subscription'
  }.each do |k,v|
    for permission in k do
      p = Permission.where(action: permission.to_s, subject_class: v).first
      consultant.permissions << p if p
    end
  end
end
