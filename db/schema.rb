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

ActiveRecord::Schema.define(:version => 20130802184020) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

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
    t.integer  "wikis_count",         :default => 0
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
  end

  add_index "fields", ["event_id"], :name => "index_event_fields_on_event_id"

  create_table "permissions", :force => true do |t|
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.string   "user_type"
  end

  add_index "permissions", ["role_id"], :name => "index_permissions_on_role_id"
  add_index "permissions", ["user_id", "user_type"], :name => "index_permissions_on_user_id_and_user_type"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.datetime "activated_at"
    t.datetime "deactivated_at"
    t.integer  "activated_by_id"
    t.integer  "deactivated_by_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "wiki_files", :force => true do |t|
    t.integer  "wiki_id"
    t.string   "file"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "wiki_files", ["wiki_id"], :name => "index_wiki_files_on_wiki_id"

  create_table "wikis", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "wiki_id"
    t.integer  "event_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "wikis", ["event_id"], :name => "index_wikis_on_event_id"
  add_index "wikis", ["wiki_id"], :name => "index_wikis_on_wiki_id"

end
