# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130819193326) do

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.string   "requirement"
    t.integer  "vacation"
    t.integer  "special_vacation"
    t.integer  "event_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "areas", ["event_id"], :name => "index_areas_on_event_id"

  create_table "delegations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "delegations", ["event_id"], :name => "index_delegations_on_event_id"
  add_index "delegations", ["role_id"], :name => "index_delegations_on_role_id"
  add_index "delegations", ["user_id"], :name => "index_delegations_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "opens_at"
    t.datetime "closes_at"
    t.boolean  "allow_edit"
    t.string   "rules_url"
    t.string   "technical_email"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "identifier"
    t.integer  "pages_count",         :default => 0
    t.integer  "subscriptions_count", :default => 0
  end

  create_table "field_fills", :force => true do |t|
    t.integer  "field_id"
    t.integer  "subscription_id"
    t.string   "type"
    t.string   "value"
    t.string   "file"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "field_fills", ["field_id"], :name => "index_field_fills_on_event_field_id"
  add_index "field_fills", ["subscription_id"], :name => "index_field_fills_on_subscription_id"

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.string   "field_type"
    t.boolean  "required"
    t.integer  "event_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.text     "extra"
    t.boolean  "show_receipt", :default => false
    t.string   "group_name"
    t.integer  "priority",     :default => 0
    t.boolean  "searchable",   :default => false
    t.boolean  "is_numeric",   :default => false
  end

  add_index "fields", ["event_id"], :name => "index_event_fields_on_event_id"

  create_table "page_files", :force => true do |t|
    t.integer  "page_id"
    t.string   "file"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "page_files", ["page_id"], :name => "index_wiki_files_on_wiki_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "page_id"
    t.integer  "event_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "main"
    t.string   "language"
  end

  add_index "pages", ["event_id"], :name => "index_wikis_on_event_id"
  add_index "pages", ["page_id"], :name => "index_wikis_on_wiki_id"

  create_table "permissions", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "action"
    t.string   "subject_class"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "role_id"
  end

  add_index "permissions_roles", ["permission_id"], :name => "index_permissions_roles_on_permission_id"
  add_index "permissions_roles", ["role_id"], :name => "index_permissions_roles_on_role_id"

  create_table "roles", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "id_card"
    t.string   "email"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.string   "name"
    t.string   "number"
  end

  add_index "subscriptions", ["event_id"], :name => "index_subscriptions_on_event_id"
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
    t.datetime "activated_at"
    t.datetime "deactivated_at"
    t.integer  "activated_by_id"
    t.integer  "deactivated_by_id"
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
