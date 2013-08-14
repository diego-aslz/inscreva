
unless User.any?
  admin = User.create! name: 'Admin', email: 'admin@inscreva.com',
      password: 'admin1234', password_confirmation: 'admin1234', admin: true
end

event_permissions = {
    'Event' => [:update, :read],
    'Page' => [:update, :read, :create],
    'Subscription' => [:update, :read, :create, :receipt]
  }
unless Permission.any?
  event_permissions.each do |v,k|
    for permission in k do
      Permission.create!(action: permission.to_s, subject_class: v)
    end
  end
end

# Default roles
unless Role.any?
  manager = Role.create!(name: 'Manager')
  event_permissions.each do |v,k|
    for permission in k do
      p = Permission.where(action: permission.to_s, subject_class: v).first
      manager.permissions << p if p
    end
  end

  consultant = Role.create!(name: 'Consultant')
  {
    'Event' => [:read],
    'Page' => [:read],
    'Subscription' => [:read, :receipt]
  }.each do |v,k|
    for permission in k do
      p = Permission.where(action: permission.to_s, subject_class: v).first
      consultant.permissions << p if p
    end
  end
end
