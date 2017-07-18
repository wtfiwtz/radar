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

ActiveRecord::Schema.define(version: 20170718095049) do

  create_table "chains", force: :cascade do |t|
    t.string "symbol"
    t.integer "order"
    t.datetime "start_at"
    t.datetime "finish_at"
    t.integer "width"
    t.integer "timeframe"
    t.decimal "change_val"
    t.float "change_pct"
  end

  create_table "companies", force: :cascade do |t|
    t.string "symbol"
    t.string "name"
    t.string "category_name"
    t.integer "category_id"
    t.index ["category_id"], name: "index_companies_on_category_id"
  end

  create_table "dailies", force: :cascade do |t|
    t.integer "company_id"
    t.string "symbol"
    t.datetime "date"
    t.decimal "open"
    t.decimal "high"
    t.decimal "low"
    t.decimal "close"
    t.decimal "volume"
    t.index ["company_id"], name: "index_dailies_on_company_id"
  end

  create_table "daily_summaries", force: :cascade do |t|
    t.string "symbol"
    t.string "kind"
    t.text "parameters"
    t.datetime "date"
    t.integer "timeframe"
    t.integer "index"
    t.decimal "prev_val"
    t.decimal "curr_val"
    t.decimal "change_val"
    t.float "change_pct"
  end

end
