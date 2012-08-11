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

ActiveRecord::Schema.define(:version => 20120811120439) do

  create_table "admins", :force => true do |t|
    t.string    "email",                  :default => "", :null => false
    t.string    "encrypted_password",     :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "award_categories", :force => true do |t|
    t.string    "title"
    t.text      "description"
    t.integer   "event_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "format"
    t.string    "level"
    t.boolean   "featured",    :default => true
  end

  create_table "awards", :force => true do |t|
    t.integer   "award_category_id"
    t.integer   "project_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "centres", :force => true do |t|
    t.string    "name"
    t.string    "slug"
    t.integer   "event_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string    "title"
    t.string    "slug"
    t.string    "hashtag"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "secret"
    t.boolean   "active",                  :default => true
    t.boolean   "use_centres",             :default => false
    t.string    "url"
    t.boolean   "enable_project_creation", :default => true
  end

  create_table "projects", :force => true do |t|
    t.string    "title"
    t.string    "slug"
    t.integer   "event_id"
    t.text      "description"
    t.string    "team"
    t.string    "url"
    t.text      "ideas"
    t.text      "costs"
    t.text      "data"
    t.string    "twitter"
    t.string    "github_url"
    t.string    "svn_url"
    t.string    "code_url"
    t.string    "secret"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "image_file_name"
    t.string    "image_content_type"
    t.integer   "image_file_size"
    t.timestamp "image_updated_at"
    t.string    "summary"
    t.integer   "centre_id"
  end

  create_table "versions", :force => true do |t|
    t.string    "item_type",  :null => false
    t.integer   "item_id",    :null => false
    t.string    "event",      :null => false
    t.string    "whodunnit"
    t.text      "object"
    t.timestamp "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
