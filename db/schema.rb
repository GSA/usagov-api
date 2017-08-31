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

ActiveRecord::Schema.define(version: 20170215174853) do

  create_table "agency_taxonomies", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.integer  "tid",        limit: 4
    t.integer  "parent_tid", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "changed_at"
  end

  create_table "asset_taxonomies", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.integer  "tid",        limit: 4
    t.integer  "parent_tid", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "changed_at"
  end

  create_table "asset_taxonomy_site_level_taxonomies", force: :cascade do |t|
    t.integer "site_level_taxonomy_id", limit: 4
    t.integer "asset_taxonomy_id",      limit: 4
  end

  create_table "directory_record_sites", force: :cascade do |t|
    t.integer "directory_record_id", limit: 4
    t.integer "site_id",             limit: 4
  end

  create_table "directory_records", force: :cascade do |t|
    t.integer  "node_id",               limit: 4
    t.string   "title",                 limit: 255
    t.string   "language",              limit: 255
    t.string   "alpha_order_name",      limit: 255
    t.string   "street_one",            limit: 255
    t.string   "street_two",            limit: 255
    t.string   "city",                  limit: 255
    t.string   "state",                 limit: 255
    t.string   "zip",                   limit: 255
    t.text     "contact_links",         limit: 65535
    t.text     "description",           limit: 65535
    t.string   "directory_type",        limit: 255
    t.string   "donated_money",         limit: 255
    t.string   "government_branch",     limit: 255
    t.string   "phone_number",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",                limit: 255
    t.integer  "parent_node_id",        limit: 4
    t.integer  "state_detail_node_id",  limit: 4
    t.string   "group_by",              limit: 255
    t.string   "notify_marketing_team", limit: 255
    t.string   "scoap_member",          limit: 255
    t.string   "show_on_az_index",      limit: 255
    t.text     "website_links",         limit: 65535
    t.string   "acronym",               limit: 255
    t.string   "cfo_agency",            limit: 255
    t.string   "for_use_by_text",       limit: 255
    t.datetime "changed_at"
  end

  create_table "multimedia_asset_agency_taxonomies", force: :cascade do |t|
    t.integer "multimedia_asset_id", limit: 4
    t.integer "agency_taxonomy_id",  limit: 4
  end

  create_table "multimedia_asset_asset_taxonomies", force: :cascade do |t|
    t.integer "multimedia_asset_id", limit: 4
    t.integer "asset_taxonomy_id",   limit: 4
  end

  create_table "multimedia_asset_sites", force: :cascade do |t|
    t.integer "multimedia_asset_id", limit: 4
    t.integer "site_id",             limit: 4
  end

  create_table "multimedia_assets", force: :cascade do |t|
    t.integer  "node_id",          limit: 4
    t.string   "title",            limit: 255
    t.text     "summary",          limit: 65535
    t.string   "language",         limit: 255
    t.string   "media_type",       limit: 255
    t.text     "widget_code",      limit: 65535
    t.string   "high_res_version", limit: 255
    t.string   "status",           limit: 255
    t.string   "file_name",        limit: 255
    t.string   "file_location",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "changed_at"
  end

  create_table "site_level_taxonomies", force: :cascade do |t|
    t.string   "value",              limit: 255
    t.integer  "tid",                limit: 4
    t.integer  "parent_tid",         limit: 4
    t.text     "friendly_url",       limit: 65535
    t.text     "description",        limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "page_title",         limit: 65535
    t.string   "site_membership",    limit: 255
    t.boolean  "generate_page",      limit: 1
    t.datetime "asset_last_updated"
    t.string   "page_type",          limit: 255
    t.datetime "changed_at"
  end

  create_table "sites", force: :cascade do |t|
    t.string "value", limit: 255
  end

  create_table "state_details", force: :cascade do |t|
    t.integer  "node_id",                          limit: 4
    t.string   "title",                            limit: 255
    t.text     "html",                             limit: 65535
    t.string   "state_details_page",               limit: 255
    t.string   "state_homepage_text",              limit: 255
    t.string   "state_homepage_url",               limit: 255
    t.string   "governor",                         limit: 255
    t.string   "governor_contact_text",            limit: 255
    t.string   "governor_contact_url",             limit: 255
    t.string   "state_contact_text",               limit: 255
    t.string   "state_contact_url",                limit: 255
    t.string   "nickname",                         limit: 255
    t.string   "capital",                          limit: 255
    t.string   "state_motto",                      limit: 255
    t.string   "state_symbols_text",               limit: 255
    t.string   "state_symbols_url",                limit: 255
    t.string   "agriculture_department_text",      limit: 255
    t.string   "agriculture_department_url",       limit: 255
    t.string   "alcoholic_beverage_control_text",  limit: 255
    t.string   "alcoholic_beverage_control_url",   limit: 255
    t.string   "attorney_general_text",            limit: 255
    t.string   "attorney_general_url",             limit: 255
    t.string   "authentication_office_text",       limit: 255
    t.string   "authentication_office_url",        limit: 255
    t.string   "consumer_protection_office_text",  limit: 255
    t.string   "consumer_protection_office_url",   limit: 255
    t.string   "corrections_department_text",      limit: 255
    t.string   "corrections_department_url",       limit: 255
    t.string   "district_attorneys_text",          limit: 255
    t.string   "district_attorneys_url",           limit: 255
    t.string   "education_department_text",        limit: 255
    t.string   "education_department_url",         limit: 255
    t.string   "election_office_text",             limit: 255
    t.string   "election_office_url",              limit: 255
    t.string   "emergency_management_agency_text", limit: 255
    t.string   "emergency_management_agency_url",  limit: 255
    t.string   "fish_and_wildlife_agency_text",    limit: 255
    t.string   "fish_and_wildlife_agency_url",     limit: 255
    t.string   "forestry_department_text",         limit: 255
    t.string   "forestry_department_url",          limit: 255
    t.string   "gaming_commision_text",            limit: 255
    t.string   "gaming_commision_url",             limit: 255
    t.string   "health_department_text",           limit: 255
    t.string   "health_department_url",            limit: 255
    t.string   "lottery_results_text",             limit: 255
    t.string   "lottery_results_url",              limit: 255
    t.string   "maps_text",                        limit: 255
    t.string   "maps_url",                         limit: 255
    t.string   "motor_vehicle_offices_text",       limit: 255
    t.string   "motor_vehicle_offices_url",        limit: 255
    t.string   "photos_and_multimedia_text",       limit: 255
    t.string   "photos_and_multimedia_url",        limit: 255
    t.string   "racing_commission_text",           limit: 255
    t.string   "racing_commission_url",            limit: 255
    t.string   "state_defense_force_text",         limit: 255
    t.string   "state_defense_force_url",          limit: 255
    t.string   "surplus_property_sales_text",      limit: 255
    t.string   "surplus_property_sales_url",       limit: 255
    t.string   "travel_tourism_text",              limit: 255
    t.string   "travel_tourism_url",               limit: 255
    t.string   "language",                         limit: 255
    t.string   "language_field",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "changed_at"
  end

  create_table "text_asset_agency_taxonomies", force: :cascade do |t|
    t.integer "text_asset_id",      limit: 4
    t.integer "agency_taxonomy_id", limit: 4
  end

  create_table "text_asset_asset_taxonomies", force: :cascade do |t|
    t.integer "text_asset_id",     limit: 4
    t.integer "asset_taxonomy_id", limit: 4
  end

  create_table "text_asset_site_level_taxonomies", force: :cascade do |t|
    t.integer "text_asset_id",          limit: 4
    t.integer "site_level_taxonomy_id", limit: 4
  end

  create_table "text_asset_sites", force: :cascade do |t|
    t.integer "text_asset_id", limit: 4
    t.integer "site_id",       limit: 4
  end

  create_table "text_assets", force: :cascade do |t|
    t.integer  "node_id",             limit: 4
    t.string   "title",               limit: 255
    t.text     "summary",             limit: 65535
    t.string   "language",            limit: 255
    t.text     "html",                limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",              limit: 255
    t.string   "location",            limit: 255
    t.string   "owner",               limit: 255
    t.string   "author",              limit: 255
    t.text     "locations",           limit: 65535
    t.datetime "changed_at"
    t.string   "for_use_by",          limit: 255
    t.text     "contact_center_only", limit: 65535
  end

  create_table "usa_gov_text_asset_usa_gov_asset_topic_taxonomies", force: :cascade do |t|
    t.integer "usa_gov_text_asset_id",                limit: 4
    t.integer "usa_gov_text_asset_topic_taxonomy_id", limit: 4
  end

  create_table "usa_gov_text_asset_uses", force: :cascade do |t|
  end

  create_table "usa_gov_text_assets", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.text     "summary",             limit: 65535
    t.string   "language",            limit: 255
    t.text     "html",                limit: 65535
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "contact_center_only", limit: 65535
  end

end
