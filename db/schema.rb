# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2017_11_07_182430) do

  create_table "chains", force: :cascade do |t|
    t.integer "company_id"
    t.string "symbol"
    t.integer "order"
    t.datetime "start_at"
    t.datetime "finish_at"
    t.integer "width"
    t.integer "timeframe"
    t.decimal "change_val"
    t.float "change_pct"
    t.decimal "prev_val"
    t.decimal "curr_val"
    t.index ["change_pct"], name: "index_chains_on_change_pct"
    t.index ["company_id"], name: "index_chains_on_company_id"
    t.index ["finish_at"], name: "index_chains_on_finish_at"
    t.index ["symbol", "start_at"], name: "index_chains_on_symbol_and_start_at"
  end

  create_table "companies", force: :cascade do |t|
    t.string "symbol"
    t.string "name"
    t.string "category_name"
    t.bigint "market_cap"
    t.integer "category_id"
    t.index ["category_id"], name: "index_companies_on_category_id"
  end

  create_table "crypto_currencies", force: :cascade do |t|
    t.string "sym"
    t.string "name"
  end

  create_table "cryptos", force: :cascade do |t|
    t.datetime "date"
    t.integer "crypto_currency_id"
    t.string "sym"
    t.string "name"
    t.string "symbol"
    t.integer "rank"
    t.decimal "price_usd"
    t.decimal "price_btc"
    t.decimal "volume_24h_usd"
    t.decimal "market_cap_usd"
    t.float "available_supply"
    t.float "total_supply"
    t.float "percent_change_1h"
    t.float "percent_change_24h"
    t.float "percent_change_7d"
    t.integer "last_updated"
    t.float "max_supply"
    t.index ["crypto_currency_id"], name: "index_cryptos_on_crypto_currency_id"
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
    t.index ["date"], name: "index_dailies_on_date"
    t.index ["symbol", "date"], name: "index_dailies_on_symbol_and_date"
  end

  create_table "daily_summaries", force: :cascade do |t|
    t.integer "company_id"
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
    t.index ["company_id"], name: "index_daily_summaries_on_company_id"
    t.index ["date"], name: "index_daily_summaries_on_date"
    t.index ["symbol", "date"], name: "index_daily_summaries_on_symbol_and_date"
  end

  add_foreign_key "chains", "companies"
  add_foreign_key "dailies", "companies"
  add_foreign_key "daily_summaries", "companies"
end
