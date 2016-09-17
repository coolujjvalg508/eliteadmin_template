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

ActiveRecord::Schema.define(version: 20160917093757) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "advertisements", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.integer  "status",      default: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "parent_id",   default: 0
    t.string   "slug"
    t.string   "image"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "faqs", force: :cascade do |t|
    t.text     "question"
    t.text     "answer"
    t.boolean  "active",     default: true, null: false
    t.integer  "position"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "galleries", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "post_type_category_id",        default: 0
    t.integer  "medium_category_id",           default: 0
    t.integer  "subject_matter_id",            default: 0
    t.integer  "has_adult_content",            default: 0
    t.string   "software_used"
    t.string   "tags"
    t.integer  "use_tag_from_previous_upload", default: 0
    t.integer  "is_featured",                  default: 0
    t.integer  "status",                       default: 1
    t.integer  "is_save_to_draft",             default: 0
    t.integer  "visibility",                   default: 1
    t.integer  "publish",                      default: 1
    t.string   "company_logo"
    t.integer  "where_to_show",                default: 1
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "paramlink"
    t.string   "schedule_time"
    t.string   "skill"
    t.string   "location"
  end

  create_table "images", force: :cascade do |t|
    t.string   "image"
    t.integer  "imageable_id",   null: false
    t.string   "imageable_type", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "caption_image"
  end

  add_index "images", ["imageable_id"], name: "index_images_on_imageable_id", using: :btree
  add_index "images", ["imageable_type"], name: "index_images_on_imageable_type", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.string   "paramlink"
    t.text     "description"
    t.string   "company_name"
    t.integer  "job_type",                     default: 0
    t.string   "from_amount"
    t.string   "to_amount"
    t.string   "job_category"
    t.string   "application_email_or_url"
    t.string   "country"
    t.string   "city"
    t.integer  "work_remotely",                default: 1
    t.integer  "relocation_asistance",         default: 1
    t.string   "closing_date"
    t.string   "skill"
    t.string   "software_expertise"
    t.string   "tags"
    t.integer  "use_tag_from_previous_upload", default: 0
    t.integer  "is_featured",                  default: 0
    t.integer  "status",                       default: 1
    t.integer  "is_save_to_draft",             default: 1
    t.integer  "visibility",                   default: 1
    t.integer  "publish",                      default: 1
    t.string   "company_logo"
    t.integer  "where_to_show",                default: 1
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "schedule_time"
  end

  create_table "marmo_sets", force: :cascade do |t|
    t.string   "marmoset"
    t.integer  "marmosetable_id",   null: false
    t.string   "marmosetable_type", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "marmo_sets", ["marmosetable_id"], name: "index_marmo_sets_on_marmosetable_id", using: :btree
  add_index "marmo_sets", ["marmosetable_type"], name: "index_marmo_sets_on_marmosetable_type", using: :btree

  create_table "marmosets", force: :cascade do |t|
    t.string   "marmoset"
    t.integer  "marmosetable_id",   null: false
    t.string   "marmosetable_type", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "marmosets", ["marmosetable_id"], name: "index_marmosets_on_marmosetable_id", using: :btree
  add_index "marmosets", ["marmosetable_type"], name: "index_marmosets_on_marmosetable_type", using: :btree

  create_table "medium_categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.integer  "parent_id"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "image"
  end

  add_index "medium_categories", ["parent_id"], name: "index_medium_categories_on_parent_id", using: :btree

  create_table "sketchfebs", force: :cascade do |t|
    t.string   "sketchfeb"
    t.integer  "sketchfebable_id",   null: false
    t.string   "sketchfebable_type", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "sketchfebs", ["sketchfebable_id"], name: "index_sketchfebs_on_sketchfebable_id", using: :btree
  add_index "sketchfebs", ["sketchfebable_type"], name: "index_sketchfebs_on_sketchfebable_type", using: :btree

  create_table "static_pages", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "page_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "subject_matters", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.string   "image"
    t.integer  "parent_id"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "subject_matters", ["parent_id"], name: "index_subject_matters_on_parent_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "title"
    t.text     "tags"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 1
  end

  create_table "upload_videos", force: :cascade do |t|
    t.string   "uploadvideo"
    t.integer  "uploadvideoable_id",   null: false
    t.string   "uploadvideoable_type", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "caption_upload_video"
  end

  add_index "upload_videos", ["uploadvideoable_id"], name: "index_upload_videos_on_videoable_id", using: :btree
  add_index "upload_videos", ["uploadvideoable_type"], name: "index_upload_videos_on_videoable_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "video"
    t.integer  "videoable_id",   null: false
    t.string   "videoable_type", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "caption_video"
  end

  add_index "videos", ["videoable_id"], name: "index_videos_on_videoable_id", using: :btree
  add_index "videos", ["videoable_type"], name: "index_videos_on_videoable_type", using: :btree

end
