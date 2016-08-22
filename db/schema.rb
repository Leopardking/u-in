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

ActiveRecord::Schema.define(version: 20160701151136) do

  create_table "billing_details", force: true do |t|
    t.string   "card_type"
    t.string   "ccard_last4"
    t.string   "stripe_profile_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "zipcode"
    t.string   "state"
    t.boolean  "always_use"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_id"
    t.boolean  "same_as_company_address", default: false
    t.string   "street_address_2"
    t.string   "email"
    t.string   "phone"
    t.string   "name_card"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.string   "security_code"
  end

  add_index "billing_details", ["user_id"], name: "index_billing_details_on_user_id", using: :btree

  create_table "booking_details", force: true do |t|
    t.integer  "booking_criterion"
    t.time     "booking_start_time"
    t.time     "booking_end_time"
    t.time     "blackout_from"
    t.time     "blackout_to"
    t.decimal  "booking_duration",        precision: 10, scale: 0
    t.integer  "bookings_per_duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "maximum_bookings"
    t.integer  "booking_detailable_id"
    t.string   "booking_detailable_type"
  end

  create_table "bookings", force: true do |t|
    t.integer  "user_id"
    t.integer  "promotion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "segment_id"
    t.date     "book_date"
    t.boolean  "status",                                   default: true
    t.string   "charge_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "check_discount",                           default: false
    t.decimal  "promotion_price", precision: 10, scale: 0
    t.decimal  "paid_price",      precision: 10, scale: 0
  end

  add_index "bookings", ["promotion_id"], name: "index_bookings_on_promotion_id", using: :btree
  add_index "bookings", ["segment_id"], name: "index_bookings_on_segment_id", using: :btree
  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "categories_promotions", force: true do |t|
    t.integer "category_id"
    t.integer "promotion_id"
  end

  add_index "categories_promotions", ["category_id"], name: "index_categories_promotions_on_category_id", using: :btree
  add_index "categories_promotions", ["promotion_id"], name: "index_categories_promotions_on_promotion_id", using: :btree

  create_table "categories_temp_promotions", force: true do |t|
    t.integer "category_id"
    t.integer "temp_promotion_id"
  end

  add_index "categories_temp_promotions", ["category_id"], name: "index_categories_temp_promotions_on_category_id", using: :btree
  add_index "categories_temp_promotions", ["temp_promotion_id"], name: "index_categories_temp_promotions_on_temp_promotion_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "faqs", force: true do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "history_v_moneys", force: true do |t|
    t.integer  "user_id"
    t.integer  "action"
    t.integer  "promotion_id"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "booking_id"
  end

  add_index "history_v_moneys", ["booking_id"], name: "index_history_v_moneys_on_booking_id", using: :btree
  add_index "history_v_moneys", ["promotion_id"], name: "index_history_v_moneys_on_promotion_id", using: :btree
  add_index "history_v_moneys", ["user_id"], name: "index_history_v_moneys_on_user_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description_image"
    t.integer  "image_no"
    t.boolean  "image_default",                                default: false
    t.decimal  "crop_x",              precision: 10, scale: 0
    t.decimal  "crop_y",              precision: 10, scale: 0
    t.decimal  "crop_w",              precision: 10, scale: 0
    t.decimal  "crop_h",              precision: 10, scale: 0
    t.integer  "user_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "using_image"
    t.integer  "imageable_id"
    t.string   "imageable_type"
  end

  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree

  create_table "merchant_details", force: true do |t|
    t.string   "business_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.float    "lat"
    t.float    "lng"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "business_desc"
  end

  add_index "merchant_details", ["user_id"], name: "index_merchant_details_on_user_id", using: :btree

  create_table "other_blackouts", force: true do |t|
    t.datetime "blackout_from"
    t.datetime "blackout_to"
    t.integer  "promotion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "other_blackouts", ["promotion_id"], name: "index_other_blackouts_on_promotion_id", using: :btree

  create_table "promotions", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "google_map_link"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "phone_number"
    t.string   "youtube_video"
    t.float    "price"
    t.float    "discount_percent"
    t.float    "discount_price"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "repeat"
    t.string   "cancellation_minimum"
    t.float    "cancellation_fee"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "same_as_business_address", default: false
    t.boolean  "cancel_status",            default: false
    t.integer  "current_rank"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "frequency"
    t.integer  "end_date_type"
    t.text     "days_of_week"
    t.integer  "occurrence"
    t.datetime "deleted_at"
    t.text     "bring_item"
    t.text     "expect"
    t.string   "occurrence_extend"
    t.float    "saving_price"
    t.integer  "active_times",             default: 0
  end

  add_index "promotions", ["deleted_at"], name: "index_promotions_on_deleted_at", using: :btree
  add_index "promotions", ["end_date"], name: "index_promotions_on_end_date", using: :btree
  add_index "promotions", ["frequency"], name: "index_promotions_on_frequency", using: :btree
  add_index "promotions", ["occurrence"], name: "index_promotions_on_occurrence", using: :btree
  add_index "promotions", ["start_date"], name: "index_promotions_on_start_date", using: :btree
  add_index "promotions", ["user_id"], name: "index_promotions_on_user_id", using: :btree

  create_table "temp_promotions", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "google_map_link"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "phone_number"
    t.string   "youtube_video"
    t.float    "price"
    t.float    "discount_percent"
    t.float    "discount_price"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "repeat"
    t.string   "cancellation_minimum"
    t.float    "cancellation_fee"
    t.integer  "user_id"
    t.boolean  "same_as_business_address", default: false
    t.boolean  "cancel_status",            default: false
    t.integer  "current_rank"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "frequency"
    t.integer  "end_date_type"
    t.text     "days_of_week"
    t.integer  "occurrence"
    t.datetime "deleted_at"
    t.text     "bring_item"
    t.text     "expect"
    t.string   "occurrence_extend"
    t.float    "saving_price"
    t.integer  "active_times",             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "promotion_id"
  end

  add_index "temp_promotions", ["promotion_id"], name: "index_temp_promotions_on_promotion_id", using: :btree
  add_index "temp_promotions", ["user_id"], name: "index_temp_promotions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "user_type"
    t.boolean  "admin",                  default: false
    t.float    "virtual_money",          default: 0.0
    t.integer  "booking_free",           default: 0
    t.boolean  "charge_payment",         default: false
    t.datetime "time_charge"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "avatar_url"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
