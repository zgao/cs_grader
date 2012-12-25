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

ActiveRecord::Schema.define(:version => 20121225154224) do

  create_table "cs_classes", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "course_id"
  end

  create_table "cs_classes_users", :force => true do |t|
    t.integer "cs_class_id"
    t.integer "user_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "problems", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "due_date"
    t.integer  "cs_class_id"
    t.integer  "time_limit"
    t.boolean  "visible"
  end

  create_table "requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cs_class_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "requests", ["cs_class_id"], :name => "index_requests_on_cs_class_id"
  add_index "requests", ["user_id"], :name => "index_requests_on_user_id"

  create_table "solution_states", :force => true do |t|
    t.integer  "user_id"
    t.integer  "problem_id"
    t.integer  "solution_id"
    t.integer  "test_cases_passed"
    t.integer  "test_cases_total"
    t.string   "comments"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "solution_states", ["problem_id"], :name => "index_solution_states_on_problem_id"
  add_index "solution_states", ["solution_id"], :name => "index_solution_states_on_solution_id"
  add_index "solution_states", ["user_id"], :name => "index_solution_states_on_user_id"

  create_table "solutions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "problem_id"
    t.boolean  "validated"
    t.integer  "test_cases_passed"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.boolean  "tested"
    t.string   "comments"
  end

  add_index "solutions", ["problem_id"], :name => "index_solutions_on_problem_id"
  add_index "solutions", ["user_id"], :name => "index_solutions_on_user_id"

  create_table "test_cases", :force => true do |t|
    t.integer  "problem_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "input_file_name"
    t.string   "input_content_type"
    t.integer  "input_file_size"
    t.datetime "input_updated_at"
    t.string   "output_file_name"
    t.string   "output_content_type"
    t.integer  "output_file_size"
    t.datetime "output_updated_at"
  end

  add_index "test_cases", ["problem_id"], :name => "index_test_cases_on_problem_id"

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
    t.boolean  "admin"
    t.boolean  "approved"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
