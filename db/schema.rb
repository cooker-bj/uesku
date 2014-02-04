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

ActiveRecord::Schema.define(:version => 20140201140149) do

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "in_active",              :default => true, :null => false
    t.string   "name"
    t.integer  "roles",                  :default => 0,    :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "alerts", :force => true do |t|
    t.string   "calendar_event_id"
    t.integer  "alert_before_event", :default => 15,      :null => false
    t.string   "when_to_alert",      :default => "start", :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "authenticated_tokens", :force => true do |t|
    t.string   "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "branches", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "website"
    t.integer  "province_id", :null => false
    t.integer  "city_id",     :null => false
    t.integer  "district_id", :null => false
    t.string   "street"
    t.string   "geolng"
    t.string   "geolat"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "company_id"
  end

  create_table "calendar_events", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",                              :null => false
    t.datetime "start_time",                         :null => false
    t.datetime "end_time",                           :null => false
    t.string   "location"
    t.text     "description"
    t.integer  "notify1",        :default => 60,     :null => false
    t.integer  "notify2"
    t.string   "event_group_id"
    t.string   "source",         :default => "self", :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "all_day",        :default => false,  :null => false
    t.boolean  "repeat",         :default => false,  :null => false
    t.string   "timetable_name"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "ancestry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "class_times", :force => true do |t|
    t.integer  "timetable_id"
    t.date     "start_day"
    t.date     "end_day"
    t.integer  "week"
    t.string   "start_time_hour"
    t.string   "start_time_minute"
    t.string   "end_time_hour"
    t.string   "end_time_minute"
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.datetime "comment_time"
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "score_id"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.string   "tags"
    t.text     "description"
    t.string   "image"
    t.boolean  "audit",       :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "courses", :force => true do |t|
    t.string   "title",                          :null => false
    t.string   "age_range"
    t.integer  "category_id",                    :null => false
    t.float    "price"
    t.text     "description"
    t.string   "tags"
    t.string   "website"
    t.boolean  "free_try",    :default => false, :null => false
    t.integer  "company_id",                     :null => false
    t.string   "special"
    t.integer  "creator_id"
    t.integer  "auditor_id"
    t.boolean  "audit",       :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.boolean  "status",     :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "tag",        :default => 0,     :null => false
  end

  create_table "group_lessons", :force => true do |t|
    t.integer  "group_id"
    t.integer  "lesson_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.integer  "owner_id"
    t.datetime "created_time"
    t.integer  "lesson_id"
    t.string   "logo"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "locked",       :default => false, :null => false
    t.string   "description"
  end

  create_table "lessons", :force => true do |t|
    t.integer  "course_id",                                                          :null => false
    t.integer  "branch_id",                                                          :null => false
    t.decimal  "rank",              :precision => 2, :scale => 1, :default => 0.0,   :null => false
    t.integer  "rank_counter",                                    :default => 0,     :null => false
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.decimal  "course_score",      :precision => 2, :scale => 1, :default => 0.0,   :null => false
    t.decimal  "environment_score", :precision => 2, :scale => 1, :default => 0.0,   :null => false
    t.decimal  "security_score",    :precision => 2, :scale => 1, :default => 0.0,   :null => false
    t.decimal  "teacher_score",     :precision => 2, :scale => 1, :default => 0.0,   :null => false
    t.boolean  "audit",                                           :default => false, :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "ancestry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "locations", ["ancestry"], :name => "index_locations_on_ancestry"

  create_table "members", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "status",     :default => "pending", :null => false
    t.string   "role",       :default => "member",  :null => false
  end

  create_table "message_group_users", :force => true do |t|
    t.integer  "message_group_id"
    t.integer  "user_id"
    t.boolean  "has_new_messages", :default => true, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "message_groups", :force => true do |t|
    t.integer  "creator_id"
    t.datetime "create_time"
    t.datetime "update_time"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "messengers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_group_id"
    t.integer  "short_message_id"
    t.boolean  "read_status",      :default => false, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "my_lessons", :force => true do |t|
    t.string   "title"
    t.decimal  "price"
    t.string   "age_range"
    t.string   "special"
    t.boolean  "free_try"
    t.string   "company"
    t.string   "address"
    t.text     "description"
    t.string   "website"
    t.string   "phone"
    t.datetime "create_time"
    t.integer  "creator_id"
    t.string   "status",      :default => "pending", :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "calendar_event_id"
    t.integer  "alert_before_event", :default => 15,      :null => false
    t.string   "when_to_alert",      :default => "start", :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "post_comments", :force => true do |t|
    t.integer  "user_id"
    t.datetime "comment_time"
    t.text     "message"
    t.integer  "post_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.integer  "poster_id"
    t.datetime "posted_time"
    t.integer  "group_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "distillate",        :default => false, :null => false
    t.integer  "set_to_top",        :default => 0,     :null => false
    t.integer  "comment_count",     :default => -1,    :null => false
    t.integer  "last_replier_id"
    t.datetime "last_replied_time"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.text     "resume"
    t.string   "address"
    t.string   "phone"
    t.integer  "district_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "recommendations", :force => true do |t|
    t.integer  "lesson_id"
    t.string   "position"
    t.datetime "recommend_date"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "city_id"
    t.string   "image"
    t.string   "description"
  end

  create_table "replies", :force => true do |t|
    t.string   "message"
    t.datetime "reply_time"
    t.integer  "comment_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scores", :force => true do |t|
    t.integer  "security",    :default => 0, :null => false
    t.integer  "teacher",     :default => 0, :null => false
    t.integer  "course",      :default => 0, :null => false
    t.integer  "environment", :default => 0, :null => false
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "short_messages", :force => true do |t|
    t.datetime "create_time"
    t.string   "message"
    t.string   "media"
    t.boolean  "read_status",      :default => false, :null => false
    t.integer  "sender_id"
    t.integer  "message_group_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "category",         :default => 0,     :null => false
  end

  create_table "taken_classes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "timetable_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "timetables", :force => true do |t|
    t.integer  "creator_id"
    t.string   "title"
    t.text     "description"
    t.integer  "lesson_id"
    t.date     "start_day"
    t.date     "end_day"
    t.datetime "create_time"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

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
    t.integer  "score",                  :default => 0,  :null => false
    t.string   "real_name"
    t.string   "nickname"
    t.string   "gender"
    t.date     "birthday"
    t.string   "avatar"
    t.integer  "location_id"
    t.datetime "registration_date"
    t.integer  "points"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
