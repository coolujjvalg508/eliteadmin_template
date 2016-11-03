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

ActiveRecord::Schema.define(version: 20161103091151) do

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
  end

  create_table "education_experiences", force: :cascade do |t|
    t.string   "school_name"
    t.string   "field_of_study"
    t.string   "month_val"
    t.string   "year_val"
    t.text     "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
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
  end

  create_table "home_sidebars", force: :cascade do |t|
    t.text     "description"
    t.boolean  "open_link_in_new_window",        default: true
    t.boolean  "show_button",                    default: true
    t.string   "fb_page_name"
    t.string   "fb_default"
    t.string   "fb_position"
    t.string   "tw_username"
    t.string   "tw_default"
    t.string   "tw_position"
    t.string   "youtube_channel"
    t.string   "youtube_default"
    t.string   "youtube_position"
    t.string   "viemo_channel"
    t.string   "viemo_default"
    t.string   "viemo_position"
    t.string   "feedburner_feedname"
    t.string   "feedburner_default"
    t.string   "feedburner_position"
    t.string   "dribbble_username"
    t.string   "dribbble_default"
    t.string   "dribbble_position"
    t.string   "forrst_username"
    t.string   "forrst_default"
    t.string   "forrst_position"
    t.string   "digg_username"
    t.string   "digg_default"
    t.string   "digg_position"
    t.string   "custom_menu_title"
    t.string   "dp_title"
    t.integer  "dp_number"
    t.integer  "dp_order_by"
    t.string   "dp_order"
    t.integer  "dp_category"
    t.boolean  "limit_post_by_current_category", default: true
    t.boolean  "limit_post_by_current_author",   default: true
    t.string   "dp_includes"
    t.string   "dp_style"
    t.string   "rss_url"
    t.string   "give_feed"
    t.integer  "number_of_display_item"
    t.boolean  "display_item_content",           default: true
    t.boolean  "display_item_author",            default: false
    t.boolean  "display_item_date",              default: false
    t.string   "cat_title"
    t.boolean  "cat_display_as_dropdown",        default: true
    t.boolean  "cat_show_post_count",            default: false
    t.boolean  "cat_show_hierarchy",             default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
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
    t.integer  "job_type",                     default: 0
    t.string   "from_amount"
    t.string   "to_amount"
    t.string   "application_email_or_url"
    t.string   "country"
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
    t.boolean  "is_paid",                      default: true
    t.integer  "package_id"
    t.integer  "user_id"
    t.string   "is_admin"
    t.boolean  "is_spam",                      default: false
  end

  create_table "main_sidebars", force: :cascade do |t|
    t.text     "description"
    t.string   "dp_title"
    t.integer  "dp_number"
    t.integer  "dp_style"
    t.string   "cat_title"
    t.boolean  "cat_display_as_dropdown", default: true
    t.boolean  "cat_show_post_count",     default: false
    t.boolean  "cat_show_hierarchy",      default: false
    t.boolean  "open_link_in_new_window", default: true
    t.boolean  "show_button",             default: true
    t.string   "fb_page_name"
    t.string   "fb_default"
    t.string   "fb_position"
    t.string   "tw_username"
    t.string   "tw_default"
    t.string   "tw_position"
    t.string   "youtube_channel"
    t.string   "youtube_default"
    t.string   "youtube_position"
    t.string   "viemo_channel"
    t.string   "viemo_default"
    t.string   "viemo_position"
    t.string   "feedburner_feedname"
    t.string   "feedburner_default"
    t.string   "feedburner_position"
    t.string   "dribbble_username"
    t.string   "dribbble_default"
    t.string   "dribbble_position"
    t.string   "forrst_username"
    t.string   "forrst_default"
    t.string   "forrst_position"
    t.string   "digg_username"
    t.string   "digg_default"
    t.string   "digg_position"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
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
  end

  create_table "news", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "media_type",  default: 0
    t.string   "image"
    t.string   "video"
    t.string   "uploaded_by"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "status",      default: true
    t.string   "paramlink"
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
    t.boolean  "is_pending",  default: false
    t.boolean  "is_approve",  default: true
    t.boolean  "is_spam",     default: false
    t.boolean  "is_trash",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "production_experiences", force: :cascade do |t|
    t.string   "production_title"
    t.string   "release_year"
    t.string   "production_type"
    t.string   "your_role"
    t.string   "company"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
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
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.integer  "company_id"
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
  end

  create_table "sketchfebs", force: :cascade do |t|
    t.string   "sketchfeb"
    t.integer  "sketchfebable_id",   null: false
    t.string   "sketchfebable_type", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
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

  create_table "tags", force: :cascade do |t|
    t.string   "title"
    t.text     "tags"
    t.integer  "status",     default: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tutorials", force: :cascade do |t|
    t.string   "title"
    t.string   "paramlink"
    t.text     "description"
    t.integer  "media_type",  default: 0
    t.string   "image"
    t.string   "video"
    t.string   "uploaded_by"
    t.boolean  "status",      default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
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
    t.string   "country"
    t.string   "city"
    t.string   "image"
    t.string   "demo_reel"
    t.text     "summary"
    t.string   "available_from"
    t.string   "show_message_button"
    t.string   "skill_expertise"
    t.string   "software_expertise"
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
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
