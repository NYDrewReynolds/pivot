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

ActiveRecord::Schema.define(version: 20150709164426) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "title",         null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
  end

  add_index "categories", ["restaurant_id"], name: "index_categories_on_restaurant_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "item_categories", force: :cascade do |t|
    t.integer  "item_id",     null: false
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: :cascade do |t|
    t.string   "title",                             null: false
    t.text     "description",                       null: false
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "active",             default: true
    t.integer  "restaurant_id"
  end

  add_index "items", ["restaurant_id"], name: "index_items_on_restaurant_id", using: :btree

  create_table "line_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["item_id"], name: "index_line_items_on_item_id", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status",        default: "ordered"
    t.string   "exchange"
    t.string   "street_number"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cuisine"
    t.string   "slug"
    t.string   "slug_name"
  end

  add_index "restaurants", ["slug"], name: "index_restaurants_on_slug", unique: true, using: :btree
  add_index "restaurants", ["slug_name"], name: "index_restaurants_on_slug_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",      default: ""
    t.string   "last_name",       default: ""
    t.string   "email",                            null: false
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",                  null: false
    t.string   "role",            default: "user"
    t.integer  "restaurant_id"
  end

  add_index "users", ["restaurant_id"], name: "index_users_on_restaurant_id", using: :btree

end
