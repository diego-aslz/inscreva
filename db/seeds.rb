# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

r = Role.find_or_create_by_name('superadmin')
admin = AdminUser.first
admin.update_attribute :email, 'admin@inscreva.com'
admin.update_attributes password: 'admin1234', password_confirmation: 'admin1234'
admin.roles << r unless admin.has_role? r
