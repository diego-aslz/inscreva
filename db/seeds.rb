# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

r = Role.find_or_create_by_name('superadmin')
admin = AdminUser.first
admin.roles << r unless admin.has_role? r

=begin
u = User.find_by_email 'admin@inscreva.com.br'
unless u
  u = User.create!(email: 'admin@inscreva.com.br', password: 'admin1234',
      password_confirmation: 'admin1234', name: 'Admin')
  u.permissions.create!(role_id: r.id)
end
=end
