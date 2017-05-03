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

ActiveRecord::Schema.define(version: 20170502085139) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_controls", force: :cascade do |t|
    t.integer  "user_group_id"
    t.text     "permissions"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "",            null: false
    t.string   "encrypted_password",     default: "",            null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,             null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "group_id"
    t.string   "role",                   default: "super_admin"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "advertisement_packages", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "amount"
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "advertisements", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "status",                   default: 1
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "advertisement_package_id"
    t.string   "starting_date"
    t.string   "end_date"
    t.string   "target_location"
    t.boolean  "interest_based",           default: false
  end

  create_table "block_users", force: :cascade do |t|
    t.integer  "user_id"
    t.json     "block_user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
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
    t.string   "slug"
    t.integer  "parent_id"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "image"
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree

  create_table "category_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "description"
    t.string   "slug"
    t.integer  "parent_id"
    t.integer  "status",      default: 0
    t.string   "image"
  end

  create_table "challenges", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "upload_button_text"
    t.integer  "challenge_type_id",  default: 0
    t.string   "closing_date"
    t.string   "tags"
    t.text     "awards"
    t.text     "terms_condition"
    t.text     "judging"
    t.text     "faq"
    t.integer  "status",             default: 1
    t.integer  "is_save_to_draft",   default: 1
    t.integer  "visibility",         default: 1
    t.integer  "publish",            default: 1
    t.string   "company_logo"
    t.json     "where_to_show"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "schedule_time"
    t.integer  "user_id",            default: 0
    t.string   "is_admin"
    t.string   "opening_date"
    t.string   "team_member"
    t.string   "hosts"
    t.integer  "is_submitted",       default: 0
    t.integer  "view_count",         default: 0
    t.string   "paramlink"
  end

  create_table "collection_details", force: :cascade do |t|
    t.integer  "gallery_id",    default: 0
    t.integer  "collection_id", default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "collections", force: :cascade do |t|
    t.string   "title"
    t.integer  "gallery_id", default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "is_pending",  default: true
    t.boolean  "is_approve",  default: true
    t.boolean  "is_spam",     default: true
    t.boolean  "is_trash",    default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "email"
  end

  create_table "contest_follows", force: :cascade do |t|
    t.integer  "user_id",    default: 0
    t.integer  "contest_id", default: 0
    t.string   "post_type"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "contest_likes", force: :cascade do |t|
    t.integer  "user_id",    default: 0
    t.integer  "post_id",    default: 0
    t.integer  "artist_id",  default: 0
    t.string   "post_type"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "contests", force: :cascade do |t|
    t.string   "title"
    t.string   "paramlink"
    t.string   "schedule_time"
    t.string   "is_admin"
    t.text     "description"
    t.integer  "post_type_category_id",        default: 0
    t.integer  "user_id"
    t.integer  "medium_category_id",           default: 0
    t.json     "subject_matter_id"
    t.boolean  "has_adult_content",            default: false
    t.json     "software_used"
    t.string   "tags"
    t.boolean  "use_tag_from_previous_upload", default: false
    t.boolean  "is_featured",                  default: false
    t.integer  "status",                       default: 1
    t.integer  "is_save_to_draft",             default: 1
    t.integer  "visibility",                   default: 1
    t.integer  "publish",                      default: 1
    t.string   "company_logo"
    t.json     "where_to_show"
    t.json     "skill"
    t.string   "location"
    t.json     "team_member"
    t.boolean  "show_on_cgmeetup"
    t.boolean  "show_on_website"
    t.boolean  "is_spam",                      default: false
    t.integer  "like_count",                   default: 0
    t.integer  "comment_count",                default: 0
    t.integer  "view_count",                   default: 0
    t.integer  "is_trash",                     default: 0
    t.string   "zoom_w"
    t.string   "zoom_h"
    t.string   "zoom_x"
    t.string   "zoom_y"
    t.string   "drag_x"
    t.string   "drag_y"
    t.string   "rotation_angle"
    t.string   "crop_x"
    t.string   "crop_y"
    t.string   "crop_w"
    t.string   "crop_h"
    t.json     "challenge"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "winner_type"
    t.integer  "follow_count",                 default: 0
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "code",       limit: 3
    t.integer  "status",               default: 1
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "downloads", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.json     "topic"
    t.json     "software_used"
    t.integer  "is_paid",               default: 0
    t.float    "price"
    t.string   "tags"
    t.integer  "status",                default: 1
    t.integer  "is_save_to_draft",      default: 1
    t.integer  "visibility",            default: 1
    t.integer  "publish",               default: 1
    t.string   "company_logo"
    t.string   "schedule_time"
    t.integer  "user_id",               default: 0
    t.string   "is_admin"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.json     "sub_topic"
    t.boolean  "animated",              default: false
    t.boolean  "rigged",                default: false
    t.boolean  "lowpoly",               default: true
    t.boolean  "texture",               default: false
    t.boolean  "material",              default: false
    t.boolean  "uv_mapping",            default: false
    t.boolean  "plugin_used",           default: false
    t.string   "unwrapped_uv"
    t.string   "polygon"
    t.string   "vertice"
    t.string   "geometry"
    t.json     "post_type_category_id"
    t.json     "sub_category_id"
    t.boolean  "free",                  default: false
    t.text     "changelog"
    t.boolean  "is_feature",            default: false
    t.json     "post_type_id"
    t.json     "challenge"
  end

  create_table "education_experiences", force: :cascade do |t|
    t.string   "school_name"
    t.string   "field_of_study"
    t.string   "month_val"
    t.string   "year_val"
    t.text     "description"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_id"
    t.integer  "educationexperienceable_id"
    t.string   "educationexperienceable_type"
  end

  create_table "faqs", force: :cascade do |t|
    t.text     "question"
    t.text     "answer"
    t.boolean  "active",     default: true, null: false
    t.integer  "position"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "user_id",    default: 0
    t.integer  "artist_id",  default: 0
    t.string   "post_type"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "galleries", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "post_type_category_id",        default: 0
    t.integer  "medium_category_id",           default: 0
    t.string   "tags"
    t.integer  "status",                       default: 1
    t.integer  "is_save_to_draft",             default: 1
    t.integer  "visibility",                   default: 1
    t.integer  "publish",                      default: 1
    t.string   "company_logo"
    t.integer  "where_to_show",                default: 1
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "paramlink"
    t.string   "schedule_time"
    t.string   "location"
    t.boolean  "show_on_cgmeetup"
    t.boolean  "show_on_website"
    t.json     "skill"
    t.json     "software_used"
    t.json     "subject_matter_id"
    t.json     "team_member"
    t.boolean  "use_tag_from_previous_upload", default: false
    t.boolean  "has_adult_content",            default: false
    t.boolean  "is_featured",                  default: false
    t.integer  "user_id"
    t.string   "is_admin"
    t.boolean  "is_spam",                      default: false
    t.string   "zoom_w"
    t.string   "zoom_h"
    t.string   "zoom_x"
    t.string   "zoom_y"
    t.string   "drag_x"
    t.string   "drag_y"
    t.string   "rotation_angle"
    t.string   "crop_x"
    t.string   "crop_y"
    t.string   "crop_w"
    t.string   "crop_h"
    t.json     "challenge"
    t.integer  "is_trash",                     default: 0
    t.integer  "view_count",                   default: 0
    t.integer  "like_count",                   default: 0
    t.integer  "comment_count",                default: 0
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

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

  create_table "invitations", force: :cascade do |t|
    t.integer  "user_id",    default: 0
    t.string   "email"
    t.string   "status"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "job_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "description"
    t.string   "slug"
    t.integer  "parent_id"
    t.integer  "status",      default: 0
    t.string   "image"
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.string   "paramlink"
    t.text     "description"
    t.string   "company_name"
    t.string   "job_type",                     default: "0"
    t.string   "from_amount"
    t.string   "to_amount"
    t.string   "application_email_or_url"
    t.string   "city"
    t.string   "closing_date"
    t.json     "skill"
    t.json     "software_expertise"
    t.string   "tags"
    t.integer  "status",                       default: 1
    t.integer  "is_save_to_draft",             default: 1
    t.integer  "visibility",                   default: 1
    t.integer  "publish",                      default: 1
    t.string   "company_logo"
    t.json     "where_to_show"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "schedule_time"
    t.integer  "company_id"
    t.boolean  "show_on_cgmeetup"
    t.boolean  "show_on_website"
    t.json     "job_category"
    t.boolean  "work_remotely",                default: false
    t.boolean  "relocation_asistance",         default: false
    t.boolean  "use_tag_from_previous_upload", default: false
    t.boolean  "is_featured",                  default: false
    t.integer  "user_id"
    t.string   "is_admin"
    t.boolean  "is_spam",                      default: false
    t.string   "apply_type"
    t.text     "apply_instruction"
    t.string   "apply_url"
    t.string   "apply_email"
    t.string   "company_url"
    t.json     "package_id"
    t.string   "state"
    t.integer  "country_id"
    t.string   "zoom_w"
    t.string   "zoom_h"
    t.string   "zoom_x"
    t.string   "zoom_y"
    t.string   "drag_x"
    t.string   "drag_y"
    t.string   "rotation_angle"
    t.string   "crop_x"
    t.string   "crop_y"
    t.string   "crop_w"
    t.string   "crop_h"
    t.integer  "is_trash",                     default: 0
    t.integer  "like_count",                   default: 0
    t.integer  "view_count",                   default: 0
    t.integer  "comment_count",                default: 0
    t.integer  "follow_count",                 default: 0
  end

  create_table "latest_activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "artist_id"
    t.string   "activity_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "section_type"
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "lesson_title"
    t.string   "lesson_video"
    t.string   "lesson_video_link"
    t.integer  "lessonable_id",      null: false
    t.string   "lessonable_type",    null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "lesson_description"
    t.string   "lesson_image"
  end

  add_index "lessons", ["lessonable_id"], name: "index_lessons_on_lessonableable_id", using: :btree
  add_index "lessons", ["lessonable_type"], name: "index_lessons_on_lessonableable_type", using: :btree

  create_table "marmo_sets", force: :cascade do |t|
    t.string   "marmoset"
    t.integer  "marmosetable_id",   null: false
    t.string   "marmosetable_type", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "caption_marmoset"
  end

  add_index "marmo_sets", ["marmosetable_id"], name: "index_marmo_sets_on_marmosetable_id", using: :btree
  add_index "marmo_sets", ["marmosetable_type"], name: "index_marmo_sets_on_marmosetable_type", using: :btree

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

  create_table "menus", force: :cascade do |t|
    t.string   "title"
    t.integer  "parent_id",        default: 0
    t.string   "url"
    t.string   "navigation_label"
    t.integer  "position",         default: 0
    t.boolean  "status",           default: true
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "is_custom_link",   default: false
    t.string   "pagename"
    t.string   "menulocation"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "message"
    t.boolean  "is_read",     default: false
    t.boolean  "is_admin",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.json     "topic"
    t.json     "software_used"
    t.float    "price"
    t.string   "tags"
    t.integer  "is_featured",      default: 0
    t.integer  "status",           default: 1
    t.integer  "is_save_to_draft", default: 1
    t.integer  "visibility",       default: 1
    t.integer  "publish",          default: 1
    t.string   "company_logo"
    t.string   "schedule_time"
    t.integer  "user_id",          default: 0
    t.string   "is_admin"
    t.boolean  "show_on_cgmeetup", default: true
    t.boolean  "show_on_website",  default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.json     "sub_topic"
    t.json     "category_id"
    t.json     "sub_category_id"
  end

  create_table "news_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.text     "description"
    t.string   "slug"
    t.integer  "parent_id"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "news_categories", ["parent_id"], name: "index_news_categories_on_parent_id", using: :btree

  create_table "newsletter_settings", force: :cascade do |t|
    t.string   "email_digest_option"
    t.boolean  "job_email",           default: false
    t.boolean  "gallery_email",       default: false
    t.boolean  "download_email",      default: false
    t.boolean  "tutorial_email",      default: false
    t.boolean  "news_email",          default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",           default: 0
    t.integer  "post_id",           default: 0
    t.integer  "artist_id",         default: 0
    t.string   "notification_type"
    t.string   "section_type"
    t.integer  "is_read",           default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "packages", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "amount"
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "post_comments", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "is_pending",   default: false
    t.boolean  "is_approve",   default: true
    t.boolean  "is_spam",      default: false
    t.boolean  "is_trash",     default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "post_id",      default: 0
    t.string   "section_type"
  end

  create_table "post_likes", force: :cascade do |t|
    t.integer  "user_id",    default: 0
    t.integer  "post_id",    default: 0
    t.string   "post_type"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "artist_id"
  end

  create_table "post_type_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.text     "description"
    t.string   "slug"
    t.integer  "parent_id"
    t.integer  "status",       default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "post_type_id"
  end

  add_index "post_type_categories", ["parent_id"], name: "index_post_type_categories_on_parent_id", using: :btree

  create_table "post_types", force: :cascade do |t|
    t.string   "type_name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "image"
    t.text     "description"
    t.string   "slug"
    t.integer  "status",      default: 0
    t.integer  "parent_id"
  end

  create_table "production_experiences", force: :cascade do |t|
    t.string   "production_title"
    t.string   "release_year"
    t.string   "production_type"
    t.string   "your_role"
    t.string   "company"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "user_id"
    t.integer  "productionexperienceable_id"
    t.string   "productionexperienceable_type"
  end

  create_table "professional_experiences", force: :cascade do |t|
    t.string   "company_name"
    t.string   "title"
    t.string   "location"
    t.text     "description"
    t.string   "from_month"
    t.string   "from_year"
    t.string   "to_month"
    t.string   "to_year"
    t.string   "currently_worked"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "professionalexperienceable_id"
    t.string   "professionalexperienceable_type"
  end

  create_table "questionaires", force: :cascade do |t|
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id",      default: 0
    t.integer  "post_id",      default: 0
    t.string   "post_type"
    t.text     "report_issue"
    t.string   "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "site_settings", force: :cascade do |t|
    t.string   "site_title"
    t.string   "site_email"
    t.string   "site_phone"
    t.string   "copyright_text"
    t.string   "no_of_image"
    t.string   "no_of_video"
    t.string   "no_of_marmoset"
    t.string   "no_of_sketchfeb"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "licence"
  end

  create_table "sketchfebs", force: :cascade do |t|
    t.string   "sketchfeb"
    t.integer  "sketchfebable_id",   null: false
    t.string   "sketchfebable_type", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "caption_sketchfeb"
  end

  add_index "sketchfebs", ["sketchfebable_id"], name: "index_sketchfebs_on_sketchfebable_id", using: :btree
  add_index "sketchfebs", ["sketchfebable_type"], name: "index_sketchfebs_on_sketchfebable_type", using: :btree

  create_table "software_expertises", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "description"
    t.string   "slug"
    t.integer  "parent_id"
    t.integer  "status",      default: 0
    t.string   "image"
  end

  create_table "static_pages", force: :cascade do |t|
    t.string   "title"
    t.string   "page_url"
    t.text     "description"
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

  create_table "system_emails", force: :cascade do |t|
    t.string   "title"
    t.string   "subject"
    t.text     "content"
    t.text     "footer"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "identifier"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "tag"
    t.integer  "tagable_id",   null: false
    t.string   "tagable_type", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "tags", ["tagable_id"], name: "index_tags_on_tagable_id", using: :btree
  add_index "tags", ["tagable_type"], name: "index_tags_on_tagable_type", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.string   "image"
    t.integer  "parent_id"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "topic_for",   default: 0
  end

  add_index "topics", ["parent_id"], name: "index_topics_on_parent_id", using: :btree

  create_table "tutorial_skills", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tutorials", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.json     "topic"
    t.json     "software_used"
    t.integer  "is_paid",             default: 0
    t.float    "price"
    t.string   "tags"
    t.integer  "is_featured",         default: 0
    t.integer  "status",              default: 1
    t.integer  "is_save_to_draft",    default: 1
    t.integer  "visibility",          default: 1
    t.integer  "publish",             default: 1
    t.string   "company_logo"
    t.string   "schedule_time"
    t.boolean  "show_on_cgmeetup",    default: true
    t.boolean  "show_on_website",     default: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "is_admin"
    t.integer  "user_id",             default: 0
    t.string   "skill_level"
    t.string   "language"
    t.integer  "total_lecture",       default: 0
    t.text     "include_description"
    t.string   "sub_title"
    t.json     "sub_topic"
    t.boolean  "free",                default: false
    t.json     "challenge"
  end

  create_table "upload_videos", force: :cascade do |t|
    t.string   "uploadvideo"
    t.integer  "uploadvideoable_id",   null: false
    t.string   "uploadvideoable_type", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "caption_upload_video"
  end

  add_index "upload_videos", ["uploadvideoable_id"], name: "index_upload_videos_on_uploadvideoable_id", using: :btree
  add_index "upload_videos", ["uploadvideoable_type"], name: "index_upload_videos_on_uploadvideoable_type", using: :btree

  create_table "user_groups", force: :cascade do |t|
    t.string   "name"
    t.boolean  "can_access_acp", default: true
    t.boolean  "is_super_mod",   default: true
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "user_settings", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "emailnotify_like_myartwork",                        default: false
    t.boolean  "emailnotify_comment_myartwork",                     default: false
    t.boolean  "emailnotify_followme",                              default: false
    t.boolean  "emailnotify_like_mycomment",                        default: false
    t.boolean  "emailnotify_following_user_newartwork",             default: false
    t.boolean  "emailnotify_comment_on_mycommentedpost",            default: false
    t.boolean  "emailnotify_reply_on_mycomment",                    default: false
    t.boolean  "emailnotify_subcribed_challengesubmission",         default: false
    t.boolean  "emailnotify_like_mysubmission",                     default: false
    t.boolean  "emailnotify_like_mysubmissionupdate",               default: false
    t.boolean  "emailnotify_challenge_announcements",               default: false
    t.boolean  "emailnotify_newreply_on_challengeannouncement",     default: false
    t.boolean  "emailnotify_newreply_on_challengesubmissionupdate", default: false
    t.boolean  "emailnotify_like_repliestodiscussion",              default: false
    t.boolean  "emailnotify_like_postedchallengeannouncement",      default: false
    t.boolean  "notifyme_like_myartwork",                           default: false
    t.boolean  "notifyme_comment_myartwork",                        default: false
    t.boolean  "notifyme_followme",                                 default: false
    t.boolean  "notifyme_like_mycomment",                           default: false
    t.boolean  "notifyme_following_user_newartwork",                default: false
    t.boolean  "notifyme_comment_on_mycommentedpost",               default: false
    t.boolean  "notifyme_reply_on_mycomment",                       default: false
    t.boolean  "notifyme_subcribed_challengesubmission",            default: false
    t.boolean  "notifyme_like_mysubmission",                        default: false
    t.boolean  "notifyme_like_mysubmissionupdate",                  default: false
    t.boolean  "notifyme_challenge_announcements",                  default: false
    t.boolean  "notifyme_newreply_on_challengeannouncement",        default: false
    t.boolean  "notifyme_newreply_on_challengesubmissionupdate",    default: false
    t.boolean  "notifyme_like_repliestodiscussion",                 default: false
    t.boolean  "notifyme_like_postedchallengeannouncement",         default: false
    t.boolean  "emailnotify_announcement_subscription",             default: false
    t.boolean  "emailnotify_newjob_jobdigest_subscription",         default: false
    t.boolean  "emailnotify_newtutorials_jobdigest_subscription",   default: false
    t.boolean  "emailnotify_newdownloads_jobdigest_subscription",   default: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
  end

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
    t.string   "firstname"
    t.string   "lastname"
    t.string   "professional_headline"
    t.string   "phone_number"
    t.string   "profile_type"
    t.string   "city"
    t.string   "image"
    t.string   "demo_reel"
    t.text     "summary"
    t.string   "available_from"
    t.string   "show_message_button"
    t.string   "public_email_address"
    t.string   "website_url"
    t.string   "facebook_url"
    t.string   "linkedin_profile_url"
    t.string   "twitter_handle"
    t.string   "instagram_username"
    t.string   "behance_username"
    t.string   "tumbler_url"
    t.string   "pinterest_url"
    t.string   "youtube_url"
    t.string   "vimeo_url"
    t.string   "google_plus_url"
    t.string   "stream_profile_url"
    t.boolean  "full_time_employment"
    t.boolean  "contract"
    t.boolean  "freelance"
    t.string   "username"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "is_deleted",             default: 0
    t.string   "cover_art_image"
    t.integer  "country_id"
    t.json     "skill_expertise"
    t.json     "software_expertise"
    t.integer  "follow_count",           default: 0
    t.integer  "view_count",             default: 0
    t.integer  "like_count",             default: 0
    t.string   "qb_id"
    t.string   "qb_password"
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

  create_table "widgets", force: :cascade do |t|
    t.string   "title"
    t.string   "sectionname"
    t.text     "widgetcode"
    t.string   "position"
    t.integer  "status",      default: 1
    t.integer  "sort_order",  default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "zip_files", force: :cascade do |t|
    t.string   "zipfile"
    t.integer  "zipfileable_id",   null: false
    t.string   "zipfileable_type", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "zip_caption"
  end

  add_index "zip_files", ["zipfileable_id"], name: "index_zip_files_on_zipfileable_id", using: :btree
  add_index "zip_files", ["zipfileable_type"], name: "index_zip_files_on_zipfileable_type", using: :btree

  add_foreign_key "identities", "users"
end
