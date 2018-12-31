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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_30_073927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.text "content"
    t.datetime "do_date"
    t.integer "message_id"
    t.boolean "done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actions_myusers", id: false, force: :cascade do |t|
    t.integer "action_id"
    t.integer "myuser_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients_myusers", id: false, force: :cascade do |t|
    t.integer "client_id"
    t.integer "myuser_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "telephone_number"
    t.string "email"
    t.string "position"
    t.integer "priority"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id"
  end

  create_table "hides", force: :cascade do |t|
    t.integer "myuser_id"
    t.string "element"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client"
    t.text "comment"
    t.datetime "start"
    t.datetime "end"
    t.integer "client_id"
    t.boolean "daily_flag"
    t.text "comments"
    t.string "time_zone"
    t.datetime "working_day_start"
    t.datetime "working_day_end"
    t.boolean "include_weekends"
  end

  create_table "jobs_myusers", id: false, force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "myuser_id", null: false
  end

  create_table "logged_on_logs", force: :cascade do |t|
    t.string "token"
    t.integer "user"
    t.datetime "last_use"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "encrypted_content"
    t.string "forum_name"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number"
    t.integer "myuser_id"
    t.integer "colour"
  end

  create_table "myusers", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "user_status"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.binary "has_confirmed_flag"
    t.string "office"
    t.string "experience"
    t.string "team"
    t.string "position"
    t.boolean "request_another_confirmation_email"
    t.string "work_tel"
    t.string "mobile_tel"
    t.string "home_tel"
    t.string "other_tel1"
    t.string "other_tel2"
    t.text "server_private_key"
    t.text "client_public_key"
    t.integer "messageroom_id"
    t.boolean "show_jobs_by_client"
    t.boolean "show_jobs_by_job"
    t.boolean "show_tasks_by_client"
    t.boolean "show_tasks_by_job"
    t.boolean "show_tasks_by_task"
    t.string "order_jobs_field"
    t.string "order_tasks_field"
  end

  create_table "myusers_tasks", id: false, force: :cascade do |t|
    t.bigint "myuser_id", null: false
    t.bigint "task_id", null: false
  end

  create_table "reminder_schedules", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supervisers", force: :cascade do |t|
    t.integer "myuser_id"
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "job_id"
    t.integer "linked_to_task_id"
    t.boolean "linked_flag"
    t.boolean "link_to_start"
    t.float "offset"
    t.float "duration"
    t.boolean "completed_flag"
    t.float "percentage_completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "bespoke_offset_flag"
    t.boolean "bespoke_duration_flag"
    t.boolean "fixed_end_date"
    t.integer "template_id"
    t.boolean "for_template_flag"
    t.boolean "date_error"
    t.boolean "duration_in_days"
    t.boolean "offset_in_days"
  end

  create_table "temp_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "position"
    t.string "team"
    t.string "office"
    t.string "experience"
    t.string "user_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "name"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "daily_flag"
  end

  create_table "update_reminders", force: :cascade do |t|
    t.integer "update_type"
    t.float "proportion"
    t.boolean "start_end"
    t.integer "offset_days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "task_id"
    t.boolean "before_after"
    t.string "offset_hours"
    t.boolean "repeat_weekday"
    t.string "repeat_time"
    t.boolean "allow_email_flag"
    t.boolean "update_window_percentage_flag"
    t.integer "update_window_days"
    t.string "update_window_hours"
    t.float "update_window_percentage"
    t.integer "reminder_schedule_id"
    t.boolean "is_for_task"
    t.boolean "updated_flag"
    t.datetime "window_start_date"
    t.datetime "window_end_date"
  end

  create_table "updates", force: :cascade do |t|
    t.integer "myuser_id"
    t.integer "task_id"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed_flag"
    t.float "percentage_completed"
    t.float "percentage_time_passed"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "user_status"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
