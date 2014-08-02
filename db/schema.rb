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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140710215505) do

  create_table "courses", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["user_id"], name: "index_courses_on_user_id"

  create_table "courses_students", force: true do |t|
    t.integer  "courses_id"
    t.integer  "students_id"
    t.integer  "answered",    default: 0
    t.integer  "passed",      default: 0
    t.integer  "absent",      default: 0
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses_students", ["courses_id"], name: "index_courses_students_on_courses_id"
  add_index "courses_students", ["students_id"], name: "index_courses_students_on_students_id"

  create_table "students", force: true do |t|
    t.string   "name"
    t.integer  "sid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
