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

ActiveRecord::Schema.define(version: 20150817031122) do

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.integer  "store_id"
    t.integer  "clicks"
    t.integer  "sales_cents"
    t.integer  "commission_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_kohls_categories", force: true do |t|
    t.integer "coupon_id",         null: false
    t.integer "kohls_category_id", null: false
  end

  add_index "coupon_kohls_categories", ["coupon_id"], name: "index_coupon_kohls_categories_on_coupon_id", using: :btree
  add_index "coupon_kohls_categories", ["kohls_category_id"], name: "index_coupon_kohls_categories_on_kohls_category_id", using: :btree

  create_table "coupon_kohls_onlies", force: true do |t|
    t.integer "coupon_id",     null: false
    t.integer "kohls_only_id", null: false
  end

  add_index "coupon_kohls_onlies", ["coupon_id"], name: "index_coupon_kohls_onlies_on_coupon_id", using: :btree
  add_index "coupon_kohls_onlies", ["kohls_only_id"], name: "index_coupon_kohls_onlies_on_kohls_only_id", using: :btree

  create_table "coupon_kohls_types", force: true do |t|
    t.integer "coupon_id",     null: false
    t.integer "kohls_type_id", null: false
  end

  add_index "coupon_kohls_types", ["coupon_id"], name: "index_coupon_kohls_types_on_coupon_id", using: :btree
  add_index "coupon_kohls_types", ["kohls_type_id"], name: "index_coupon_kohls_types_on_kohls_type_id", using: :btree

  create_table "coupons", force: true do |t|
    t.string   "id_of_coupon"
    t.text     "title"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "code"
    t.text     "restriction"
    t.text     "link"
    t.text     "impression_pixel"
    t.text     "image"
    t.integer  "store_id"
    t.integer  "coupon_source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupons", ["coupon_source_id"], name: "index_coupons_on_coupon_source_id", using: :btree
  add_index "coupons", ["store_id"], name: "index_coupons_on_store_id", using: :btree

  create_table "coupons_users", id: false, force: true do |t|
    t.integer "coupon_id", null: false
    t.integer "user_id",   null: false
  end

  add_index "coupons_users", ["coupon_id"], name: "index_coupons_users_on_coupon_id", using: :btree
  add_index "coupons_users", ["user_id"], name: "index_coupons_users_on_user_id", using: :btree

  create_table "kohls_categories", force: true do |t|
    t.string   "name"
    t.integer  "kc_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kohls_onlies", force: true do |t|
    t.string   "name"
    t.integer  "kc_id"
    t.string   "slug"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kohls_types", force: true do |t|
    t.string   "name"
    t.integer  "kc_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "removed_coupons", force: true do |t|
    t.integer  "id_of_coupon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", force: true do |t|
    t.string   "name"
    t.integer  "id_of_store"
    t.text     "description"
    t.text     "home_page_url"
    t.boolean  "active_commission"
    t.string   "store_img"
    t.float    "commission"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "stores", ["slug"], name: "index_stores_on_slug", unique: true, using: :btree

  create_table "stores_users", id: false, force: true do |t|
    t.integer "store_id", null: false
    t.integer "user_id",  null: false
  end

  add_index "stores_users", ["store_id"], name: "index_stores_users_on_store_id", using: :btree
  add_index "stores_users", ["user_id"], name: "index_stores_users_on_user_id", using: :btree

  create_table "transactions", force: true do |t|
    t.text     "description"
    t.integer  "amount_cents"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["user_id"], name: "index_transactions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "full_name"
    t.string   "token"
    t.boolean  "admin"
    t.string   "cashback_id"
    t.string   "paypal_email"
    t.string   "slug"
    t.boolean  "verified_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "terms"
    t.string   "user_name"
  end

  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

end
