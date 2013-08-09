
unless User.any?
  admin = User.create! name: 'Admin', email: 'admin@inscreva.com',
      password: 'admin1234', password_confirmation: 'admin1234', admin: true
end
