# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

r = Role.find_or_create_by_name('superadmin')
admin = User.find_by_email 'admin@inscreva.com'
admin = User.create! name: 'Admin', email: 'admin@inscreva.com',
    password: 'admin1234', password_confirmation: 'admin1234' unless admin
admin.roles << r unless admin.has_role? r
