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

ActiveRecord::Schema.define(version: 20181121192008) do

  create_table "Inserenten", id: false, force: :cascade do |t|
    t.string  "Firmenname",    limit: 35
    t.string  "Titel",         limit: 5
    t.string  "Vorname",       limit: 12
    t.string  "Name",          limit: 8
    t.string  "Adresszeile 1", limit: 17
    t.string  "Postleitzahl",  limit: 7
    t.string  "Stadt",         limit: 14
    t.integer "Stückzahl",     limit: 4
  end

  create_table "advertisers", force: :cascade do |t|
    t.integer  "contact_id_off",  limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "konto",           limit: 255
    t.string   "iban",            limit: 255
    t.string   "bic",             limit: 255
    t.string   "customer_number", limit: 255
    t.string   "account_owner",   limit: 255
    t.boolean  "direct_debit"
  end

  add_index "advertisers", ["contact_id_off"], name: "contact_id", using: :btree

  create_table "blacklist", force: :cascade do |t|
    t.string   "ip",          limit: 16, null: false
    t.datetime "blacklisted",            null: false
  end

  add_index "blacklist", ["ip"], name: "ip", unique: true, using: :btree

  create_table "board_contacts", force: :cascade do |t|
    t.integer  "contact_id_off", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "bundeslaender", force: :cascade do |t|
    t.string   "name",         limit: 255, null: false
    t.date     "created_on",               null: false
    t.datetime "created_at",               null: false
    t.date     "updated_on",               null: false
    t.datetime "updated_at",               null: false
    t.string   "country_code", limit: 2
  end

  create_table "classifieds", force: :cascade do |t|
    t.integer  "adv_type",    limit: 4,     default: 0,     null: false
    t.string   "name",        limit: 255,   default: "",    null: false
    t.string   "email",       limit: 255,   default: "",    null: false
    t.string   "url",         limit: 255,   default: "",    null: false
    t.string   "object",      limit: 255,   default: "",    null: false
    t.text     "description", limit: 65535,                 null: false
    t.date     "validuntil",                                null: false
    t.datetime "entrydate",                                 null: false
    t.datetime "confirmed"
    t.string   "ip",          limit: 45,                    null: false
    t.boolean  "visible",                   default: false, null: false
  end

  create_table "competition_entries", force: :cascade do |t|
    t.date     "date_of_birth"
    t.integer  "contact_id",    limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.string   "street",        limit: 255
    t.string   "city",          limit: 255
    t.string   "zip",           limit: 255
    t.string   "country_code",  limit: 255
    t.string   "email",         limit: 255
    t.string   "like",          limit: 255
    t.string   "missing",       limit: 255
    t.string   "improve",       limit: 255
    t.boolean  "correct"
    t.string   "response1",     limit: 255
    t.string   "response2",     limit: 255
    t.string   "response3",     limit: 255
    t.string   "response4",     limit: 255
    t.boolean  "winner",                    default: false
  end

  create_table "composers", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "vorname",        limit: 255
    t.string   "gebjahr",        limit: 255
    t.string   "sterbejahr",     limit: 255
    t.boolean  "ca_geb"
    t.boolean  "ca_sterb"
    t.integer  "fk_ref_komp_id", limit: 4
    t.string   "comment",        limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "link",           limit: 255
  end

  add_index "composers", ["fk_ref_komp_id"], name: "index_composers_on_fk_ref_komp_id", using: :btree

  create_table "concertino_category", force: :cascade do |t|
    t.string "title", limit: 255, null: false
  end

  create_table "concertino_inhalt", force: :cascade do |t|
    t.integer "year",     limit: 4,   null: false
    t.integer "volume",   limit: 4,   null: false
    t.integer "category", limit: 8,   null: false
    t.string  "title",    limit: 255, null: false
    t.string  "subtitle", limit: 255, null: false
    t.string  "author",   limit: 255, null: false
    t.string  "page",     limit: 10,  null: false
  end

  add_index "concertino_inhalt", ["category"], name: "category", using: :btree

  create_table "concerts", force: :cascade do |t|
    t.date     "datum"
    t.time     "zeit",                                      default: '2000-01-01 00:00:00'
    t.decimal  "eintritt",                   precision: 10,                                 null: false
    t.datetime "reported",                                                                  null: false
    t.datetime "confirmed"
    t.string   "token",        limit: 255,                                                  null: false
    t.string   "stadt",        limit: 255,                                                  null: false
    t.text     "titel",        limit: 65535,                                                null: false
    t.string   "ort",          limit: 255
    t.integer  "festival_id",  limit: 8,                    default: 0,                     null: false
    t.string   "interpret",    limit: 255,                                                  null: false
    t.string   "url",          limit: 255,                                                  null: false
    t.string   "comment",      limit: 255,                                                  null: false
    t.string   "bundesland",   limit: 255,                  default: "",                    null: false
    t.integer  "bland",        limit: 8,                    default: 0
    t.string   "email",        limit: 255,                  default: "",                    null: false
    t.integer  "owner",        limit: 8,                    default: 1,                     null: false
    t.integer  "visible",      limit: 2,                    default: 1,                     null: false
    t.integer  "orchestra_id", limit: 4
    t.string   "uid",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country_code", limit: 2
    t.datetime "concert_date"
    t.integer  "mglnr",        limit: 4
  end

  add_index "concerts", ["bland"], name: "bland", using: :btree
  add_index "concerts", ["datum", "zeit", "interpret"], name: "unique_event", unique: true, length: {"datum"=>nil, "zeit"=>nil, "interpret"=>30}, using: :btree
  add_index "concerts", ["festival_id"], name: "festival", using: :btree
  add_index "concerts", ["owner"], name: "fk_owner", using: :btree
  add_index "concerts", ["uid"], name: "index_concerts_on_uid", unique: true, using: :btree

  create_table "contact_events", force: :cascade do |t|
    t.string   "event_type",        limit: 255
    t.datetime "event_date"
    t.string   "event_id",          limit: 255
    t.integer  "contact_person_id", limit: 4
    t.string   "comment",           limit: 255
    t.string   "filename",          limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "contact_people", force: :cascade do |t|
    t.string   "salutation",              limit: 255
    t.string   "first_name",              limit: 255
    t.string   "last_name",               limit: 255
    t.string   "street",                  limit: 255
    t.string   "zip",                     limit: 255
    t.string   "city",                    limit: 255
    t.string   "email",                   limit: 255
    t.string   "phone",                   limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "country_code",            limit: 2
    t.integer  "festival_application_id", limit: 4
  end

  add_index "contact_people", ["festival_application_id"], name: "index_contact_people_on_festival_application_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string  "subtype",             limit: 50
    t.string  "company",             limit: 100
    t.string  "department",          limit: 100
    t.string  "salutation",          limit: 10,  null: false
    t.string  "title",               limit: 50
    t.string  "first_name",          limit: 50,  null: false
    t.string  "last_name",           limit: 50,  null: false
    t.string  "street",              limit: 50,  null: false
    t.string  "zip",                 limit: 10,  null: false
    t.string  "city",                limit: 50,  null: false
    t.string  "phone",               limit: 50
    t.string  "office_phone",        limit: 100
    t.string  "mobile",              limit: 50
    t.string  "fax",                 limit: 50
    t.string  "email",               limit: 50
    t.string  "bic",                 limit: 255
    t.string  "iban",                limit: 255
    t.string  "country_code",        limit: 2
    t.integer "contact_entity_id",   limit: 4
    t.string  "contact_entity_type", limit: 255
  end

  create_table "contests", force: :cascade do |t|
    t.date     "startdate",                                 null: false
    t.date     "enddate",                                   null: false
    t.text     "titel",        limit: 65535,                null: false
    t.text     "beschreibung", limit: 65535,                null: false
    t.text     "gebuehr",      limit: 65535,                null: false
    t.text     "preis",        limit: 65535,                null: false
    t.text     "anmeldung",    limit: 65535,                null: false
    t.date     "deadline",                                  null: false
    t.string   "email",        limit: 50,                   null: false
    t.datetime "reported",                                  null: false
    t.datetime "confirmed"
    t.boolean  "visible",                    default: true, null: false
  end

  create_table "country", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.string   "ccode",      limit: 5,   default: "", null: false
    t.date     "created_on",                          null: false
    t.datetime "created_at",                          null: false
    t.date     "updated_on",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "country", ["name"], name: "name", unique: true, using: :btree

  create_table "courses", force: :cascade do |t|
    t.datetime "startdate",                              null: false
    t.datetime "enddate",                                null: false
    t.datetime "reported",                               null: false
    t.datetime "confirmed"
    t.integer  "bland",        limit: 8,                 null: false
    t.integer  "fk_festival",  limit: 8,     default: 0
    t.text     "more_dates",   limit: 65535,             null: false
    t.text     "titel",        limit: 65535,             null: false
    t.string   "ort",          limit: 255,               null: false
    t.text     "beschreibung", limit: 65535,             null: false
    t.text     "inhalt",       limit: 65535,             null: false
    t.text     "gebuehr",      limit: 65535,             null: false
    t.text     "zielgruppe",   limit: 65535,             null: false
    t.text     "dozenten",     limit: 65535,             null: false
    t.text     "anmeldung",    limit: 65535,             null: false
    t.date     "deadline",                               null: false
    t.string   "email",        limit: 255,               null: false
    t.string   "token",        limit: 40
    t.integer  "visible",      limit: 4,     default: 0, null: false
    t.string   "country_code", limit: 2
  end

  add_index "courses", ["bland"], name: "bland", using: :btree
  add_index "courses", ["fk_festival"], name: "fk_festival", using: :btree

  create_table "d7_actions", primary_key: "aid", force: :cascade do |t|
    t.string "type",       limit: 32,         default: "",  null: false
    t.string "callback",   limit: 255,        default: "",  null: false
    t.binary "parameters", limit: 4294967295,               null: false
    t.string "label",      limit: 255,        default: "0", null: false
  end

  create_table "d7_advanced_help_index", primary_key: "sid", force: :cascade do |t|
    t.string "module",   limit: 255, default: "", null: false
    t.string "topic",    limit: 255, default: "", null: false
    t.string "language", limit: 12,  default: "", null: false
  end

  add_index "d7_advanced_help_index", ["language"], name: "language", using: :btree

  create_table "d7_authmap", primary_key: "aid", force: :cascade do |t|
    t.integer "uid",      limit: 4,   default: 0,  null: false
    t.string  "authname", limit: 128, default: "", null: false
    t.string  "module",   limit: 128, default: "", null: false
  end

  add_index "d7_authmap", ["authname"], name: "authname", unique: true, using: :btree
  add_index "d7_authmap", ["uid", "module"], name: "uid_module", using: :btree

  create_table "d7_batch", primary_key: "bid", force: :cascade do |t|
    t.string  "token",     limit: 64,         null: false
    t.integer "timestamp", limit: 4,          null: false
    t.binary  "batch",     limit: 4294967295
  end

  add_index "d7_batch", ["token"], name: "token", using: :btree

  create_table "d7_block", primary_key: "bid", force: :cascade do |t|
    t.string  "module",     limit: 64,       default: "",  null: false
    t.string  "delta",      limit: 32,       default: "0", null: false
    t.string  "theme",      limit: 64,       default: "",  null: false
    t.integer "status",     limit: 1,        default: 0,   null: false
    t.integer "weight",     limit: 4,        default: 0,   null: false
    t.string  "region",     limit: 64,       default: "",  null: false
    t.integer "custom",     limit: 1,        default: 0,   null: false
    t.integer "visibility", limit: 1,        default: 0,   null: false
    t.text    "pages",      limit: 16777215,               null: false
    t.string  "title",      limit: 255,      default: "",  null: false
    t.integer "cache",      limit: 1,        default: 1,   null: false
    t.integer "i18n_mode",  limit: 4,        default: 0,   null: false
  end

  add_index "d7_block", ["theme", "module", "delta"], name: "tmd", unique: true, using: :btree
  add_index "d7_block", ["theme", "status", "region", "weight", "module"], name: "list", using: :btree

  create_table "d7_block_custom", primary_key: "bid", force: :cascade do |t|
    t.text   "body",   limit: 4294967295
    t.string "info",   limit: 128,        default: "", null: false
    t.string "format", limit: 255
  end

  add_index "d7_block_custom", ["info"], name: "info", unique: true, using: :btree

  create_table "d7_block_node_type", id: false, force: :cascade do |t|
    t.string "module", limit: 64, null: false
    t.string "delta",  limit: 32, null: false
    t.string "type",   limit: 32, null: false
  end

  add_index "d7_block_node_type", ["type"], name: "type", using: :btree

  create_table "d7_block_role", id: false, force: :cascade do |t|
    t.string  "module", limit: 64, null: false
    t.string  "delta",  limit: 32, null: false
    t.integer "rid",    limit: 4,  null: false
  end

  add_index "d7_block_role", ["rid"], name: "rid", using: :btree

  create_table "d7_blocked_ips", primary_key: "iid", force: :cascade do |t|
    t.string "ip", limit: 40, default: "", null: false
  end

  add_index "d7_blocked_ips", ["ip"], name: "blocked_ip", using: :btree

  create_table "d7_cache", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_block", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_block", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_bootstrap", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_bootstrap", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_field", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_field", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_filter", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_filter", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_form", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_form", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_image", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_image", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_libraries", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_libraries", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_menu", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_menu", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_page", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_page", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_path", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_path", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_token", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_token", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_update", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_update", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_variable", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_variable", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_views", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 0, null: false
  end

  add_index "d7_cache_views", ["expire"], name: "expire", using: :btree

  create_table "d7_cache_views_data", primary_key: "cid", force: :cascade do |t|
    t.binary  "data",       limit: 4294967295
    t.integer "expire",     limit: 4,          default: 0, null: false
    t.integer "created",    limit: 4,          default: 0, null: false
    t.integer "serialized", limit: 2,          default: 1, null: false
  end

  add_index "d7_cache_views_data", ["expire"], name: "expire", using: :btree

  create_table "d7_ckeditor_input_format", id: false, force: :cascade do |t|
    t.string "name",   limit: 128, default: "", null: false
    t.string "format", limit: 128, default: "", null: false
  end

  create_table "d7_ckeditor_settings", primary_key: "name", force: :cascade do |t|
    t.text "settings", limit: 16777215
  end

  create_table "d7_comment", primary_key: "cid", force: :cascade do |t|
    t.integer "pid",      limit: 4,   default: 0,  null: false
    t.integer "nid",      limit: 4,   default: 0,  null: false
    t.integer "uid",      limit: 4,   default: 0,  null: false
    t.string  "subject",  limit: 64,  default: "", null: false
    t.string  "hostname", limit: 128, default: "", null: false
    t.integer "created",  limit: 4,   default: 0,  null: false
    t.integer "changed",  limit: 4,   default: 0,  null: false
    t.integer "status",   limit: 1,   default: 1,  null: false
    t.string  "thread",   limit: 255,              null: false
    t.string  "name",     limit: 60
    t.string  "mail",     limit: 64
    t.string  "homepage", limit: 255
    t.string  "language", limit: 12,  default: "", null: false
  end

  add_index "d7_comment", ["created"], name: "comment_created", using: :btree
  add_index "d7_comment", ["nid", "language"], name: "comment_nid_language", using: :btree
  add_index "d7_comment", ["nid", "status", "created", "cid", "thread"], name: "comment_num_new", using: :btree
  add_index "d7_comment", ["pid", "status"], name: "comment_status_pid", using: :btree
  add_index "d7_comment", ["uid"], name: "comment_uid", using: :btree

  create_table "d7_contact", primary_key: "cid", force: :cascade do |t|
    t.string  "category",   limit: 255,        default: "", null: false
    t.text    "recipients", limit: 4294967295,              null: false
    t.text    "reply",      limit: 4294967295,              null: false
    t.integer "weight",     limit: 4,          default: 0,  null: false
    t.integer "selected",   limit: 1,          default: 0,  null: false
  end

  add_index "d7_contact", ["category"], name: "category", unique: true, using: :btree
  add_index "d7_contact", ["weight", "category"], name: "list", using: :btree

  create_table "d7_css_injector_rule", primary_key: "crid", force: :cascade do |t|
    t.string  "title",           limit: 255,                  null: false
    t.integer "rule_type",       limit: 4,        default: 0, null: false
    t.text    "rule_conditions", limit: 16777215,             null: false
    t.string  "media",           limit: 255,                  null: false
    t.integer "preprocess",      limit: 4,        default: 0, null: false
    t.integer "enabled",         limit: 4,        default: 1, null: false
    t.text    "rule_themes",     limit: 16777215
  end

  create_table "d7_ctools_css_cache", primary_key: "cid", force: :cascade do |t|
    t.string  "filename", limit: 255
    t.text    "css",      limit: 4294967295
    t.integer "filter",   limit: 1
  end

  create_table "d7_ctools_object_cache", id: false, force: :cascade do |t|
    t.string  "sid",     limit: 64,                     null: false
    t.string  "name",    limit: 128,                    null: false
    t.string  "obj",     limit: 128,                    null: false
    t.integer "updated", limit: 4,          default: 0, null: false
    t.binary  "data",    limit: 4294967295
  end

  add_index "d7_ctools_object_cache", ["updated"], name: "updated", using: :btree

  create_table "d7_data_tables", primary_key: "name", force: :cascade do |t|
    t.string "title",        limit: 255,      default: "", null: false
    t.text   "table_schema", limit: 16777215
    t.text   "meta",         limit: 16777215
  end

  create_table "d7_date_format_locale", id: false, force: :cascade do |t|
    t.string "format",   limit: 100, null: false
    t.string "type",     limit: 64,  null: false
    t.string "language", limit: 12,  null: false
  end

  create_table "d7_date_format_type", primary_key: "type", force: :cascade do |t|
    t.string  "title",  limit: 255,             null: false
    t.integer "locked", limit: 1,   default: 0, null: false
  end

  add_index "d7_date_format_type", ["title"], name: "title", using: :btree

  create_table "d7_date_formats", primary_key: "dfid", force: :cascade do |t|
    t.string  "format", limit: 100,             null: false
    t.string  "type",   limit: 64,              null: false
    t.integer "locked", limit: 1,   default: 0, null: false
  end

  add_index "d7_date_formats", ["format", "type"], name: "formats", unique: true, using: :btree

  create_table "d7_delta", primary_key: "machine_name", force: :cascade do |t|
    t.string "name",        limit: 128,        null: false
    t.text   "description", limit: 4294967295, null: false
    t.string "theme",       limit: 128,        null: false
    t.string "mode",        limit: 32,         null: false
    t.string "parent",      limit: 32,         null: false
    t.binary "settings",    limit: 4294967295
  end

  create_table "d7_eu_cookie_compliance_basic_consent", primary_key: "cid", force: :cascade do |t|
    t.integer "uid",          limit: 4,   default: 0,  null: false
    t.integer "timestamp",    limit: 4,   default: 0,  null: false
    t.string  "ip_address",   limit: 45,  default: "", null: false
    t.string  "consent_type", limit: 255, default: "", null: false
    t.integer "revision_id",  limit: 4,   default: 0,  null: false
  end

  add_index "d7_eu_cookie_compliance_basic_consent", ["uid"], name: "uid", using: :btree

  create_table "d7_field_config", force: :cascade do |t|
    t.string  "field_name",     limit: 32,                      null: false
    t.string  "type",           limit: 128,                     null: false
    t.string  "module",         limit: 128,        default: "", null: false
    t.integer "active",         limit: 1,          default: 0,  null: false
    t.string  "storage_type",   limit: 128,                     null: false
    t.string  "storage_module", limit: 128,        default: "", null: false
    t.integer "storage_active", limit: 1,          default: 0,  null: false
    t.integer "locked",         limit: 1,          default: 0,  null: false
    t.binary  "data",           limit: 4294967295,              null: false
    t.integer "cardinality",    limit: 1,          default: 0,  null: false
    t.integer "translatable",   limit: 1,          default: 0,  null: false
    t.integer "deleted",        limit: 1,          default: 0,  null: false
  end

  add_index "d7_field_config", ["active"], name: "active", using: :btree
  add_index "d7_field_config", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_config", ["field_name"], name: "field_name", using: :btree
  add_index "d7_field_config", ["module"], name: "module", using: :btree
  add_index "d7_field_config", ["storage_active"], name: "storage_active", using: :btree
  add_index "d7_field_config", ["storage_module"], name: "storage_module", using: :btree
  add_index "d7_field_config", ["storage_type"], name: "storage_type", using: :btree
  add_index "d7_field_config", ["type"], name: "type", using: :btree

  create_table "d7_field_config_instance", force: :cascade do |t|
    t.integer "field_id",    limit: 4,                       null: false
    t.string  "field_name",  limit: 32,         default: "", null: false
    t.string  "entity_type", limit: 32,         default: "", null: false
    t.string  "bundle",      limit: 128,        default: "", null: false
    t.binary  "data",        limit: 4294967295,              null: false
    t.integer "deleted",     limit: 1,          default: 0,  null: false
  end

  add_index "d7_field_config_instance", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_config_instance", ["field_name", "entity_type", "bundle"], name: "field_name_bundle", using: :btree

  create_table "d7_field_data_body", id: false, force: :cascade do |t|
    t.string  "entity_type",  limit: 128,        default: "", null: false
    t.string  "bundle",       limit: 128,        default: "", null: false
    t.integer "deleted",      limit: 1,          default: 0,  null: false
    t.integer "entity_id",    limit: 4,                       null: false
    t.integer "revision_id",  limit: 4
    t.string  "language",     limit: 32,         default: "", null: false
    t.integer "delta",        limit: 4,                       null: false
    t.text    "body_value",   limit: 4294967295
    t.text    "body_summary", limit: 4294967295
    t.string  "body_format",  limit: 255
  end

  add_index "d7_field_data_body", ["body_format"], name: "body_format", using: :btree
  add_index "d7_field_data_body", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_data_body", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_data_body", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_data_body", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_data_body", ["language"], name: "language", using: :btree
  add_index "d7_field_data_body", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_data_comment_body", id: false, force: :cascade do |t|
    t.string  "entity_type",         limit: 128,        default: "", null: false
    t.string  "bundle",              limit: 128,        default: "", null: false
    t.integer "deleted",             limit: 1,          default: 0,  null: false
    t.integer "entity_id",           limit: 4,                       null: false
    t.integer "revision_id",         limit: 4
    t.string  "language",            limit: 32,         default: "", null: false
    t.integer "delta",               limit: 4,                       null: false
    t.text    "comment_body_value",  limit: 4294967295
    t.string  "comment_body_format", limit: 255
  end

  add_index "d7_field_data_comment_body", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_data_comment_body", ["comment_body_format"], name: "comment_body_format", using: :btree
  add_index "d7_field_data_comment_body", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_data_comment_body", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_data_comment_body", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_data_comment_body", ["language"], name: "language", using: :btree
  add_index "d7_field_data_comment_body", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_data_field_attachment", id: false, force: :cascade do |t|
    t.string  "entity_type",                  limit: 128,      default: "", null: false
    t.string  "bundle",                       limit: 128,      default: "", null: false
    t.integer "deleted",                      limit: 1,        default: 0,  null: false
    t.integer "entity_id",                    limit: 4,                     null: false
    t.integer "revision_id",                  limit: 4
    t.string  "language",                     limit: 32,       default: "", null: false
    t.integer "delta",                        limit: 4,                     null: false
    t.integer "field_attachment_fid",         limit: 4
    t.integer "field_attachment_display",     limit: 1,        default: 1,  null: false
    t.text    "field_attachment_description", limit: 16777215
  end

  add_index "d7_field_data_field_attachment", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_data_field_attachment", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_data_field_attachment", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_data_field_attachment", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_data_field_attachment", ["field_attachment_fid"], name: "field_attachment_fid", using: :btree
  add_index "d7_field_data_field_attachment", ["language"], name: "language", using: :btree
  add_index "d7_field_data_field_attachment", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_data_field_dateianhang", id: false, force: :cascade do |t|
    t.string  "entity_type",                   limit: 128,      default: "", null: false
    t.string  "bundle",                        limit: 128,      default: "", null: false
    t.integer "deleted",                       limit: 1,        default: 0,  null: false
    t.integer "entity_id",                     limit: 4,                     null: false
    t.integer "revision_id",                   limit: 4
    t.string  "language",                      limit: 32,       default: "", null: false
    t.integer "delta",                         limit: 4,                     null: false
    t.integer "field_dateianhang_fid",         limit: 4
    t.integer "field_dateianhang_display",     limit: 1,        default: 1,  null: false
    t.text    "field_dateianhang_description", limit: 16777215
  end

  add_index "d7_field_data_field_dateianhang", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_data_field_dateianhang", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_data_field_dateianhang", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_data_field_dateianhang", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_data_field_dateianhang", ["field_dateianhang_fid"], name: "field_dateianhang_fid", using: :btree
  add_index "d7_field_data_field_dateianhang", ["language"], name: "language", using: :btree
  add_index "d7_field_data_field_dateianhang", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_data_field_email", id: false, force: :cascade do |t|
    t.string  "entity_type",       limit: 128, default: "", null: false
    t.string  "bundle",            limit: 128, default: "", null: false
    t.integer "deleted",           limit: 1,   default: 0,  null: false
    t.integer "entity_id",         limit: 4,                null: false
    t.integer "revision_id",       limit: 4
    t.string  "language",          limit: 32,  default: "", null: false
    t.integer "delta",             limit: 4,                null: false
    t.string  "field_email_email", limit: 255
  end

  add_index "d7_field_data_field_email", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_data_field_email", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_data_field_email", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_data_field_email", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_data_field_email", ["language"], name: "language", using: :btree
  add_index "d7_field_data_field_email", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_data_field_farbschema", id: false, force: :cascade do |t|
    t.string  "entity_type",            limit: 128, default: "", null: false
    t.string  "bundle",                 limit: 128, default: "", null: false
    t.integer "deleted",                limit: 1,   default: 0,  null: false
    t.integer "entity_id",              limit: 4,                null: false
    t.integer "revision_id",            limit: 4
    t.string  "language",               limit: 32,  default: "", null: false
    t.integer "delta",                  limit: 4,                null: false
    t.string  "field_farbschema_value", limit: 255
  end

  add_index "d7_field_data_field_farbschema", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_data_field_farbschema", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_data_field_farbschema", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_data_field_farbschema", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_data_field_farbschema", ["field_farbschema_value"], name: "field_farbschema_value", using: :btree
  add_index "d7_field_data_field_farbschema", ["language"], name: "language", using: :btree
  add_index "d7_field_data_field_farbschema", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_data_field_image", id: false, force: :cascade do |t|
    t.string  "entity_type",        limit: 128,  default: "", null: false
    t.string  "bundle",             limit: 128,  default: "", null: false
    t.integer "deleted",            limit: 1,    default: 0,  null: false
    t.integer "entity_id",          limit: 4,                 null: false
    t.integer "revision_id",        limit: 4
    t.string  "language",           limit: 32,   default: "", null: false
    t.integer "delta",              limit: 4,                 null: false
    t.integer "field_image_fid",    limit: 4
    t.string  "field_image_alt",    limit: 512
    t.string  "field_image_title",  limit: 1024
    t.integer "field_image_width",  limit: 4
    t.integer "field_image_height", limit: 4
  end

  add_index "d7_field_data_field_image", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_data_field_image", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_data_field_image", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_data_field_image", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_data_field_image", ["field_image_fid"], name: "field_image_fid", using: :btree
  add_index "d7_field_data_field_image", ["language"], name: "language", using: :btree
  add_index "d7_field_data_field_image", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_data_field_tags", id: false, force: :cascade do |t|
    t.string  "entity_type",    limit: 128, default: "", null: false
    t.string  "bundle",         limit: 128, default: "", null: false
    t.integer "deleted",        limit: 1,   default: 0,  null: false
    t.integer "entity_id",      limit: 4,                null: false
    t.integer "revision_id",    limit: 4
    t.string  "language",       limit: 32,  default: "", null: false
    t.integer "delta",          limit: 4,                null: false
    t.integer "field_tags_tid", limit: 4
  end

  add_index "d7_field_data_field_tags", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_data_field_tags", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_data_field_tags", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_data_field_tags", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_data_field_tags", ["field_tags_tid"], name: "field_tags_tid", using: :btree
  add_index "d7_field_data_field_tags", ["language"], name: "language", using: :btree
  add_index "d7_field_data_field_tags", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_data_field_zielseite", id: false, force: :cascade do |t|
    t.string  "entity_type",                  limit: 128,  default: "",     null: false
    t.string  "bundle",                       limit: 128,  default: "",     null: false
    t.integer "deleted",                      limit: 1,    default: 0,      null: false
    t.integer "entity_id",                    limit: 4,                     null: false
    t.integer "revision_id",                  limit: 4
    t.string  "language",                     limit: 32,   default: "",     null: false
    t.integer "delta",                        limit: 4,                     null: false
    t.string  "field_zielseite_url",          limit: 1024
    t.string  "field_zielseite_title",        limit: 255
    t.string  "field_zielseite_class",        limit: 255
    t.string  "field_zielseite_width",        limit: 4
    t.string  "field_zielseite_height",       limit: 4
    t.integer "field_zielseite_frameborder",  limit: 1,    default: 0,      null: false
    t.string  "field_zielseite_scrolling",    limit: 4,    default: "auto", null: false
    t.integer "field_zielseite_transparency", limit: 1,    default: 0,      null: false
    t.integer "field_zielseite_tokensupport", limit: 1,    default: 0,      null: false
  end

  add_index "d7_field_data_field_zielseite", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_data_field_zielseite", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_data_field_zielseite", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_data_field_zielseite", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_data_field_zielseite", ["field_zielseite_url"], name: "field_zielseite_url", length: {"field_zielseite_url"=>255}, using: :btree
  add_index "d7_field_data_field_zielseite", ["language"], name: "language", using: :btree
  add_index "d7_field_data_field_zielseite", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_data_taxonomy_forums", id: false, force: :cascade do |t|
    t.string  "entity_type",         limit: 128, default: "", null: false
    t.string  "bundle",              limit: 128, default: "", null: false
    t.integer "deleted",             limit: 1,   default: 0,  null: false
    t.integer "entity_id",           limit: 4,                null: false
    t.integer "revision_id",         limit: 4
    t.string  "language",            limit: 32,  default: "", null: false
    t.integer "delta",               limit: 4,                null: false
    t.integer "taxonomy_forums_tid", limit: 4
  end

  add_index "d7_field_data_taxonomy_forums", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_data_taxonomy_forums", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_data_taxonomy_forums", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_data_taxonomy_forums", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_data_taxonomy_forums", ["language"], name: "language", using: :btree
  add_index "d7_field_data_taxonomy_forums", ["revision_id"], name: "revision_id", using: :btree
  add_index "d7_field_data_taxonomy_forums", ["taxonomy_forums_tid"], name: "taxonomy_forums_tid", using: :btree

  create_table "d7_field_revision_body", id: false, force: :cascade do |t|
    t.string  "entity_type",  limit: 128,        default: "", null: false
    t.string  "bundle",       limit: 128,        default: "", null: false
    t.integer "deleted",      limit: 1,          default: 0,  null: false
    t.integer "entity_id",    limit: 4,                       null: false
    t.integer "revision_id",  limit: 4,                       null: false
    t.string  "language",     limit: 32,         default: "", null: false
    t.integer "delta",        limit: 4,                       null: false
    t.text    "body_value",   limit: 4294967295
    t.text    "body_summary", limit: 4294967295
    t.string  "body_format",  limit: 255
  end

  add_index "d7_field_revision_body", ["body_format"], name: "body_format", using: :btree
  add_index "d7_field_revision_body", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_revision_body", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_revision_body", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_revision_body", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_revision_body", ["language"], name: "language", using: :btree
  add_index "d7_field_revision_body", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_revision_comment_body", id: false, force: :cascade do |t|
    t.string  "entity_type",         limit: 128,        default: "", null: false
    t.string  "bundle",              limit: 128,        default: "", null: false
    t.integer "deleted",             limit: 1,          default: 0,  null: false
    t.integer "entity_id",           limit: 4,                       null: false
    t.integer "revision_id",         limit: 4,                       null: false
    t.string  "language",            limit: 32,         default: "", null: false
    t.integer "delta",               limit: 4,                       null: false
    t.text    "comment_body_value",  limit: 4294967295
    t.string  "comment_body_format", limit: 255
  end

  add_index "d7_field_revision_comment_body", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_revision_comment_body", ["comment_body_format"], name: "comment_body_format", using: :btree
  add_index "d7_field_revision_comment_body", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_revision_comment_body", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_revision_comment_body", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_revision_comment_body", ["language"], name: "language", using: :btree
  add_index "d7_field_revision_comment_body", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_revision_field_attachment", id: false, force: :cascade do |t|
    t.string  "entity_type",                  limit: 128,      default: "", null: false
    t.string  "bundle",                       limit: 128,      default: "", null: false
    t.integer "deleted",                      limit: 1,        default: 0,  null: false
    t.integer "entity_id",                    limit: 4,                     null: false
    t.integer "revision_id",                  limit: 4,                     null: false
    t.string  "language",                     limit: 32,       default: "", null: false
    t.integer "delta",                        limit: 4,                     null: false
    t.integer "field_attachment_fid",         limit: 4
    t.integer "field_attachment_display",     limit: 1,        default: 1,  null: false
    t.text    "field_attachment_description", limit: 16777215
  end

  add_index "d7_field_revision_field_attachment", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_revision_field_attachment", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_revision_field_attachment", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_revision_field_attachment", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_revision_field_attachment", ["field_attachment_fid"], name: "field_attachment_fid", using: :btree
  add_index "d7_field_revision_field_attachment", ["language"], name: "language", using: :btree
  add_index "d7_field_revision_field_attachment", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_revision_field_dateianhang", id: false, force: :cascade do |t|
    t.string  "entity_type",                   limit: 128,      default: "", null: false
    t.string  "bundle",                        limit: 128,      default: "", null: false
    t.integer "deleted",                       limit: 1,        default: 0,  null: false
    t.integer "entity_id",                     limit: 4,                     null: false
    t.integer "revision_id",                   limit: 4,                     null: false
    t.string  "language",                      limit: 32,       default: "", null: false
    t.integer "delta",                         limit: 4,                     null: false
    t.integer "field_dateianhang_fid",         limit: 4
    t.integer "field_dateianhang_display",     limit: 1,        default: 1,  null: false
    t.text    "field_dateianhang_description", limit: 16777215
  end

  add_index "d7_field_revision_field_dateianhang", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_revision_field_dateianhang", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_revision_field_dateianhang", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_revision_field_dateianhang", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_revision_field_dateianhang", ["field_dateianhang_fid"], name: "field_dateianhang_fid", using: :btree
  add_index "d7_field_revision_field_dateianhang", ["language"], name: "language", using: :btree
  add_index "d7_field_revision_field_dateianhang", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_revision_field_email", id: false, force: :cascade do |t|
    t.string  "entity_type",       limit: 128, default: "", null: false
    t.string  "bundle",            limit: 128, default: "", null: false
    t.integer "deleted",           limit: 1,   default: 0,  null: false
    t.integer "entity_id",         limit: 4,                null: false
    t.integer "revision_id",       limit: 4,                null: false
    t.string  "language",          limit: 32,  default: "", null: false
    t.integer "delta",             limit: 4,                null: false
    t.string  "field_email_email", limit: 255
  end

  add_index "d7_field_revision_field_email", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_revision_field_email", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_revision_field_email", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_revision_field_email", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_revision_field_email", ["language"], name: "language", using: :btree
  add_index "d7_field_revision_field_email", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_revision_field_farbschema", id: false, force: :cascade do |t|
    t.string  "entity_type",            limit: 128, default: "", null: false
    t.string  "bundle",                 limit: 128, default: "", null: false
    t.integer "deleted",                limit: 1,   default: 0,  null: false
    t.integer "entity_id",              limit: 4,                null: false
    t.integer "revision_id",            limit: 4,                null: false
    t.string  "language",               limit: 32,  default: "", null: false
    t.integer "delta",                  limit: 4,                null: false
    t.string  "field_farbschema_value", limit: 255
  end

  add_index "d7_field_revision_field_farbschema", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_revision_field_farbschema", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_revision_field_farbschema", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_revision_field_farbschema", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_revision_field_farbschema", ["field_farbschema_value"], name: "field_farbschema_value", using: :btree
  add_index "d7_field_revision_field_farbschema", ["language"], name: "language", using: :btree
  add_index "d7_field_revision_field_farbschema", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_revision_field_image", id: false, force: :cascade do |t|
    t.string  "entity_type",        limit: 128,  default: "", null: false
    t.string  "bundle",             limit: 128,  default: "", null: false
    t.integer "deleted",            limit: 1,    default: 0,  null: false
    t.integer "entity_id",          limit: 4,                 null: false
    t.integer "revision_id",        limit: 4,                 null: false
    t.string  "language",           limit: 32,   default: "", null: false
    t.integer "delta",              limit: 4,                 null: false
    t.integer "field_image_fid",    limit: 4
    t.string  "field_image_alt",    limit: 512
    t.string  "field_image_title",  limit: 1024
    t.integer "field_image_width",  limit: 4
    t.integer "field_image_height", limit: 4
  end

  add_index "d7_field_revision_field_image", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_revision_field_image", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_revision_field_image", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_revision_field_image", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_revision_field_image", ["field_image_fid"], name: "field_image_fid", using: :btree
  add_index "d7_field_revision_field_image", ["language"], name: "language", using: :btree
  add_index "d7_field_revision_field_image", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_revision_field_tags", id: false, force: :cascade do |t|
    t.string  "entity_type",    limit: 128, default: "", null: false
    t.string  "bundle",         limit: 128, default: "", null: false
    t.integer "deleted",        limit: 1,   default: 0,  null: false
    t.integer "entity_id",      limit: 4,                null: false
    t.integer "revision_id",    limit: 4,                null: false
    t.string  "language",       limit: 32,  default: "", null: false
    t.integer "delta",          limit: 4,                null: false
    t.integer "field_tags_tid", limit: 4
  end

  add_index "d7_field_revision_field_tags", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_revision_field_tags", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_revision_field_tags", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_revision_field_tags", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_revision_field_tags", ["field_tags_tid"], name: "field_tags_tid", using: :btree
  add_index "d7_field_revision_field_tags", ["language"], name: "language", using: :btree
  add_index "d7_field_revision_field_tags", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_revision_field_zielseite", id: false, force: :cascade do |t|
    t.string  "entity_type",                  limit: 128,  default: "",     null: false
    t.string  "bundle",                       limit: 128,  default: "",     null: false
    t.integer "deleted",                      limit: 1,    default: 0,      null: false
    t.integer "entity_id",                    limit: 4,                     null: false
    t.integer "revision_id",                  limit: 4,                     null: false
    t.string  "language",                     limit: 32,   default: "",     null: false
    t.integer "delta",                        limit: 4,                     null: false
    t.string  "field_zielseite_url",          limit: 1024
    t.string  "field_zielseite_title",        limit: 255
    t.string  "field_zielseite_class",        limit: 255
    t.string  "field_zielseite_width",        limit: 4
    t.string  "field_zielseite_height",       limit: 4
    t.integer "field_zielseite_frameborder",  limit: 1,    default: 0,      null: false
    t.string  "field_zielseite_scrolling",    limit: 4,    default: "auto", null: false
    t.integer "field_zielseite_transparency", limit: 1,    default: 0,      null: false
    t.integer "field_zielseite_tokensupport", limit: 1,    default: 0,      null: false
  end

  add_index "d7_field_revision_field_zielseite", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_revision_field_zielseite", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_revision_field_zielseite", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_revision_field_zielseite", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_revision_field_zielseite", ["field_zielseite_url"], name: "field_zielseite_url", length: {"field_zielseite_url"=>255}, using: :btree
  add_index "d7_field_revision_field_zielseite", ["language"], name: "language", using: :btree
  add_index "d7_field_revision_field_zielseite", ["revision_id"], name: "revision_id", using: :btree

  create_table "d7_field_revision_taxonomy_forums", id: false, force: :cascade do |t|
    t.string  "entity_type",         limit: 128, default: "", null: false
    t.string  "bundle",              limit: 128, default: "", null: false
    t.integer "deleted",             limit: 1,   default: 0,  null: false
    t.integer "entity_id",           limit: 4,                null: false
    t.integer "revision_id",         limit: 4,                null: false
    t.string  "language",            limit: 32,  default: "", null: false
    t.integer "delta",               limit: 4,                null: false
    t.integer "taxonomy_forums_tid", limit: 4
  end

  add_index "d7_field_revision_taxonomy_forums", ["bundle"], name: "bundle", using: :btree
  add_index "d7_field_revision_taxonomy_forums", ["deleted"], name: "deleted", using: :btree
  add_index "d7_field_revision_taxonomy_forums", ["entity_id"], name: "entity_id", using: :btree
  add_index "d7_field_revision_taxonomy_forums", ["entity_type"], name: "entity_type", using: :btree
  add_index "d7_field_revision_taxonomy_forums", ["language"], name: "language", using: :btree
  add_index "d7_field_revision_taxonomy_forums", ["revision_id"], name: "revision_id", using: :btree
  add_index "d7_field_revision_taxonomy_forums", ["taxonomy_forums_tid"], name: "taxonomy_forums_tid", using: :btree

  create_table "d7_file_managed", primary_key: "fid", force: :cascade do |t|
    t.integer "uid",       limit: 4,   default: 0,  null: false
    t.string  "filename",  limit: 255, default: "", null: false
    t.string  "uri",       limit: 255, default: "", null: false
    t.string  "filemime",  limit: 255, default: "", null: false
    t.integer "filesize",  limit: 8,   default: 0,  null: false
    t.integer "status",    limit: 1,   default: 0,  null: false
    t.integer "timestamp", limit: 4,   default: 0,  null: false
  end

  add_index "d7_file_managed", ["status"], name: "status", using: :btree
  add_index "d7_file_managed", ["timestamp"], name: "timestamp", using: :btree
  add_index "d7_file_managed", ["uid"], name: "uid", using: :btree
  add_index "d7_file_managed", ["uri"], name: "uri", unique: true, using: :btree

  create_table "d7_file_usage", id: false, force: :cascade do |t|
    t.integer "fid",    limit: 4,                null: false
    t.string  "module", limit: 255, default: "", null: false
    t.string  "type",   limit: 64,  default: "", null: false
    t.integer "id",     limit: 4,   default: 0,  null: false
    t.integer "count",  limit: 4,   default: 0,  null: false
  end

  add_index "d7_file_usage", ["fid", "count"], name: "fid_count", using: :btree
  add_index "d7_file_usage", ["fid", "module"], name: "fid_module", using: :btree
  add_index "d7_file_usage", ["type", "id"], name: "type_id", using: :btree

  create_table "d7_filter", id: false, force: :cascade do |t|
    t.string  "format",   limit: 255,                     null: false
    t.string  "module",   limit: 64,         default: "", null: false
    t.string  "name",     limit: 32,         default: "", null: false
    t.integer "weight",   limit: 4,          default: 0,  null: false
    t.integer "status",   limit: 4,          default: 0,  null: false
    t.binary  "settings", limit: 4294967295
  end

  add_index "d7_filter", ["weight", "module", "name"], name: "list", using: :btree

  create_table "d7_filter_format", primary_key: "format", force: :cascade do |t|
    t.string  "name",   limit: 255, default: "", null: false
    t.integer "cache",  limit: 1,   default: 0,  null: false
    t.integer "status", limit: 1,   default: 1,  null: false
    t.integer "weight", limit: 4,   default: 0,  null: false
  end

  add_index "d7_filter_format", ["name"], name: "name", unique: true, using: :btree
  add_index "d7_filter_format", ["status", "weight"], name: "status_weight", using: :btree

  create_table "d7_flood", primary_key: "fid", force: :cascade do |t|
    t.string  "event",      limit: 64,  default: "", null: false
    t.string  "identifier", limit: 128, default: "", null: false
    t.integer "timestamp",  limit: 4,   default: 0,  null: false
    t.integer "expiration", limit: 4,   default: 0,  null: false
  end

  add_index "d7_flood", ["event", "identifier", "timestamp"], name: "allow", using: :btree
  add_index "d7_flood", ["expiration"], name: "purge", using: :btree

  create_table "d7_forum", primary_key: "vid", force: :cascade do |t|
    t.integer "nid", limit: 4, default: 0, null: false
    t.integer "tid", limit: 4, default: 0, null: false
  end

  add_index "d7_forum", ["nid", "tid"], name: "forum_topic", using: :btree
  add_index "d7_forum", ["tid"], name: "tid", using: :btree

  create_table "d7_forum_index", id: false, force: :cascade do |t|
    t.integer "nid",                    limit: 4,   default: 0,  null: false
    t.string  "title",                  limit: 255, default: "", null: false
    t.integer "tid",                    limit: 4,   default: 0,  null: false
    t.integer "sticky",                 limit: 1,   default: 0
    t.integer "created",                limit: 4,   default: 0,  null: false
    t.integer "last_comment_timestamp", limit: 4,   default: 0,  null: false
    t.integer "comment_count",          limit: 4,   default: 0,  null: false
  end

  add_index "d7_forum_index", ["created"], name: "created", using: :btree
  add_index "d7_forum_index", ["last_comment_timestamp"], name: "last_comment_timestamp", using: :btree
  add_index "d7_forum_index", ["nid", "tid", "sticky", "last_comment_timestamp"], name: "forum_topics", using: :btree

  create_table "d7_gdpr_consent_accepted", primary_key: "gdpr_consent_id", force: :cascade do |t|
    t.integer "version",  limit: 4,  default: 0,  null: false
    t.integer "revision", limit: 4,  default: 0,  null: false
    t.string  "language", limit: 12, default: "", null: false
    t.integer "uid",      limit: 4,  default: 0,  null: false
    t.integer "accepted", limit: 4,  default: 0,  null: false
    t.integer "revoked",  limit: 4,  default: 0,  null: false
    t.integer "tc_id",    limit: 4,  default: 0,  null: false
  end

  add_index "d7_gdpr_consent_accepted", ["uid"], name: "uid", using: :btree

  create_table "d7_gdpr_consent_conditions", primary_key: "tc_id", force: :cascade do |t|
    t.integer "version",        limit: 4,          default: 0,  null: false
    t.integer "revision",       limit: 4,          default: 0,  null: false
    t.string  "language",       limit: 12,         default: "", null: false
    t.text    "conditions",     limit: 4294967295,              null: false
    t.text    "data_details",   limit: 4294967295
    t.integer "date",           limit: 4,          default: 0,  null: false
    t.text    "changes",        limit: 65535
    t.string  "format",         limit: 255
    t.string  "format_Details", limit: 255
  end

  create_table "d7_history", id: false, force: :cascade do |t|
    t.integer "uid",       limit: 4, default: 0, null: false
    t.integer "nid",       limit: 4, default: 0, null: false
    t.integer "timestamp", limit: 4, default: 0, null: false
  end

  add_index "d7_history", ["nid"], name: "nid", using: :btree

  create_table "d7_i18n_block_language", id: false, force: :cascade do |t|
    t.string "module",   limit: 64,              null: false
    t.string "delta",    limit: 32,              null: false
    t.string "language", limit: 12, default: "", null: false
  end

  add_index "d7_i18n_block_language", ["language"], name: "language", using: :btree

  create_table "d7_i18n_path", primary_key: "tpid", force: :cascade do |t|
    t.integer "tsid",     limit: 4,                null: false
    t.string  "path",     limit: 255, default: "", null: false
    t.string  "language", limit: 12,  default: "", null: false
    t.integer "pid",      limit: 4,   default: 0,  null: false
  end

  add_index "d7_i18n_path", ["path"], name: "path", using: :btree
  add_index "d7_i18n_path", ["tsid", "language"], name: "set_language", unique: true, using: :btree

  create_table "d7_i18n_string", primary_key: "lid", force: :cascade do |t|
    t.string  "textgroup",   limit: 50,  default: "default", null: false
    t.string  "context",     limit: 255, default: "",        null: false
    t.string  "objectid",    limit: 255, default: "",        null: false
    t.string  "type",        limit: 255, default: "",        null: false
    t.string  "property",    limit: 255, default: "",        null: false
    t.integer "objectindex", limit: 8
    t.string  "format",      limit: 255
  end

  add_index "d7_i18n_string", ["textgroup", "context"], name: "group_context", using: :btree

  create_table "d7_i18n_translation_set", primary_key: "tsid", force: :cascade do |t|
    t.string  "title",     limit: 255, default: "", null: false
    t.string  "type",      limit: 32,  default: "", null: false
    t.string  "bundle",    limit: 128, default: "", null: false
    t.integer "master_id", limit: 4,   default: 0,  null: false
    t.integer "status",    limit: 4,   default: 1,  null: false
    t.integer "created",   limit: 4,   default: 0,  null: false
    t.integer "changed",   limit: 4,   default: 0,  null: false
  end

  add_index "d7_i18n_translation_set", ["type", "bundle"], name: "entity_bundle", using: :btree

  create_table "d7_image_effects", primary_key: "ieid", force: :cascade do |t|
    t.integer "isid",   limit: 4,          default: 0, null: false
    t.integer "weight", limit: 4,          default: 0, null: false
    t.string  "name",   limit: 255,                    null: false
    t.binary  "data",   limit: 4294967295,             null: false
  end

  add_index "d7_image_effects", ["isid"], name: "isid", using: :btree
  add_index "d7_image_effects", ["weight"], name: "weight", using: :btree

  create_table "d7_image_styles", primary_key: "isid", force: :cascade do |t|
    t.string "name",  limit: 255,              null: false
    t.string "label", limit: 255, default: "", null: false
  end

  add_index "d7_image_styles", ["name"], name: "name", unique: true, using: :btree

  create_table "d7_languages", primary_key: "language", force: :cascade do |t|
    t.string  "name",       limit: 64,  default: "", null: false
    t.string  "native",     limit: 64,  default: "", null: false
    t.integer "direction",  limit: 4,   default: 0,  null: false
    t.integer "enabled",    limit: 4,   default: 0,  null: false
    t.integer "plurals",    limit: 4,   default: 0,  null: false
    t.string  "formula",    limit: 255, default: "", null: false
    t.string  "domain",     limit: 128, default: "", null: false
    t.string  "prefix",     limit: 128, default: "", null: false
    t.integer "weight",     limit: 4,   default: 0,  null: false
    t.string  "javascript", limit: 64,  default: "", null: false
  end

  add_index "d7_languages", ["weight", "name"], name: "list", using: :btree

  create_table "d7_locales_source", primary_key: "lid", force: :cascade do |t|
    t.text   "location",  limit: 4294967295
    t.string "textgroup", limit: 255,        default: "default", null: false
    t.binary "source",    limit: 65535,                          null: false
    t.string "context",   limit: 255,        default: "",        null: false
    t.string "version",   limit: 20,         default: "none",    null: false
  end

  add_index "d7_locales_source", ["source", "context"], name: "source_context", length: {"source"=>30, "context"=>nil}, using: :btree
  add_index "d7_locales_source", ["textgroup", "context"], name: "textgroup_context", using: :btree

  create_table "d7_locales_target", id: false, force: :cascade do |t|
    t.integer "lid",         limit: 4,     default: 0,  null: false
    t.binary  "translation", limit: 65535,              null: false
    t.string  "language",    limit: 12,    default: "", null: false
    t.integer "plid",        limit: 4,     default: 0,  null: false
    t.integer "plural",      limit: 4,     default: 0,  null: false
    t.integer "i18n_status", limit: 4,     default: 0,  null: false
  end

  add_index "d7_locales_target", ["lid"], name: "lid", using: :btree
  add_index "d7_locales_target", ["plid"], name: "plid", using: :btree
  add_index "d7_locales_target", ["plural"], name: "plural", using: :btree

  create_table "d7_menu_custom", primary_key: "menu_name", force: :cascade do |t|
    t.string  "title",       limit: 255,      default: "",    null: false
    t.text    "description", limit: 16777215
    t.string  "language",    limit: 12,       default: "und", null: false
    t.integer "i18n_mode",   limit: 4,        default: 0,     null: false
  end

  create_table "d7_menu_links", primary_key: "mlid", force: :cascade do |t|
    t.string  "menu_name",    limit: 32,    default: "",       null: false
    t.integer "plid",         limit: 4,     default: 0,        null: false
    t.string  "link_path",    limit: 255,   default: "",       null: false
    t.string  "router_path",  limit: 255,   default: "",       null: false
    t.string  "link_title",   limit: 255,   default: "",       null: false
    t.binary  "options",      limit: 65535
    t.string  "module",       limit: 255,   default: "system", null: false
    t.integer "hidden",       limit: 2,     default: 0,        null: false
    t.integer "external",     limit: 2,     default: 0,        null: false
    t.integer "has_children", limit: 2,     default: 0,        null: false
    t.integer "expanded",     limit: 2,     default: 0,        null: false
    t.integer "weight",       limit: 4,     default: 0,        null: false
    t.integer "depth",        limit: 2,     default: 0,        null: false
    t.integer "customized",   limit: 2,     default: 0,        null: false
    t.integer "p1",           limit: 4,     default: 0,        null: false
    t.integer "p2",           limit: 4,     default: 0,        null: false
    t.integer "p3",           limit: 4,     default: 0,        null: false
    t.integer "p4",           limit: 4,     default: 0,        null: false
    t.integer "p5",           limit: 4,     default: 0,        null: false
    t.integer "p6",           limit: 4,     default: 0,        null: false
    t.integer "p7",           limit: 4,     default: 0,        null: false
    t.integer "p8",           limit: 4,     default: 0,        null: false
    t.integer "p9",           limit: 4,     default: 0,        null: false
    t.integer "updated",      limit: 2,     default: 0,        null: false
    t.string  "language",     limit: 12,    default: "und",    null: false
    t.integer "i18n_tsid",    limit: 4,     default: 0,        null: false
  end

  add_index "d7_menu_links", ["link_path", "menu_name"], name: "path_menu", length: {"link_path"=>128, "menu_name"=>nil}, using: :btree
  add_index "d7_menu_links", ["menu_name", "p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9"], name: "menu_parents", using: :btree
  add_index "d7_menu_links", ["menu_name", "plid", "expanded", "has_children"], name: "menu_plid_expand_child", using: :btree
  add_index "d7_menu_links", ["router_path"], name: "router_path", length: {"router_path"=>128}, using: :btree

  create_table "d7_menu_router", primary_key: "path", force: :cascade do |t|
    t.binary  "load_functions",    limit: 65535,                 null: false
    t.binary  "to_arg_functions",  limit: 65535,                 null: false
    t.string  "access_callback",   limit: 255,      default: "", null: false
    t.binary  "access_arguments",  limit: 65535
    t.string  "page_callback",     limit: 255,      default: "", null: false
    t.binary  "page_arguments",    limit: 65535
    t.string  "delivery_callback", limit: 255,      default: "", null: false
    t.integer "fit",               limit: 4,        default: 0,  null: false
    t.integer "number_parts",      limit: 2,        default: 0,  null: false
    t.integer "context",           limit: 4,        default: 0,  null: false
    t.string  "tab_parent",        limit: 255,      default: "", null: false
    t.string  "tab_root",          limit: 255,      default: "", null: false
    t.string  "title",             limit: 255,      default: "", null: false
    t.string  "title_callback",    limit: 255,      default: "", null: false
    t.string  "title_arguments",   limit: 255,      default: "", null: false
    t.string  "theme_callback",    limit: 255,      default: "", null: false
    t.string  "theme_arguments",   limit: 255,      default: "", null: false
    t.integer "type",              limit: 4,        default: 0,  null: false
    t.text    "description",       limit: 65535,                 null: false
    t.string  "position",          limit: 255,      default: "", null: false
    t.integer "weight",            limit: 4,        default: 0,  null: false
    t.text    "include_file",      limit: 16777215
  end

  add_index "d7_menu_router", ["fit"], name: "fit", using: :btree
  add_index "d7_menu_router", ["tab_parent", "weight", "title"], name: "tab_parent", length: {"tab_parent"=>64, "weight"=>nil, "title"=>nil}, using: :btree
  add_index "d7_menu_router", ["tab_root", "weight", "title"], name: "tab_root_weight_title", length: {"tab_root"=>64, "weight"=>nil, "title"=>nil}, using: :btree

  create_table "d7_node", primary_key: "nid", force: :cascade do |t|
    t.integer "vid",       limit: 4
    t.string  "type",      limit: 32,  default: "", null: false
    t.string  "language",  limit: 12,  default: "", null: false
    t.string  "title",     limit: 255, default: "", null: false
    t.integer "uid",       limit: 4,   default: 0,  null: false
    t.integer "status",    limit: 4,   default: 1,  null: false
    t.integer "created",   limit: 4,   default: 0,  null: false
    t.integer "changed",   limit: 4,   default: 0,  null: false
    t.integer "comment",   limit: 4,   default: 0,  null: false
    t.integer "promote",   limit: 4,   default: 0,  null: false
    t.integer "sticky",    limit: 4,   default: 0,  null: false
    t.integer "tnid",      limit: 4,   default: 0,  null: false
    t.integer "translate", limit: 4,   default: 0,  null: false
  end

  add_index "d7_node", ["changed"], name: "node_changed", using: :btree
  add_index "d7_node", ["created"], name: "node_created", using: :btree
  add_index "d7_node", ["language"], name: "language", using: :btree
  add_index "d7_node", ["promote", "status", "sticky", "created"], name: "node_frontpage", using: :btree
  add_index "d7_node", ["status", "type", "nid"], name: "node_status_type", using: :btree
  add_index "d7_node", ["title", "type"], name: "node_title_type", length: {"title"=>nil, "type"=>4}, using: :btree
  add_index "d7_node", ["tnid"], name: "tnid", using: :btree
  add_index "d7_node", ["translate"], name: "translate", using: :btree
  add_index "d7_node", ["type"], name: "node_type", length: {"type"=>4}, using: :btree
  add_index "d7_node", ["uid"], name: "uid", using: :btree
  add_index "d7_node", ["vid"], name: "vid", unique: true, using: :btree

  create_table "d7_node_access", id: false, force: :cascade do |t|
    t.integer "nid",          limit: 4,   default: 0,  null: false
    t.integer "gid",          limit: 4,   default: 0,  null: false
    t.string  "realm",        limit: 255, default: "", null: false
    t.integer "grant_view",   limit: 1,   default: 0,  null: false
    t.integer "grant_update", limit: 1,   default: 0,  null: false
    t.integer "grant_delete", limit: 1,   default: 0,  null: false
  end

  create_table "d7_node_comment_statistics", primary_key: "nid", force: :cascade do |t|
    t.integer "cid",                    limit: 4,  default: 0, null: false
    t.integer "last_comment_timestamp", limit: 4,  default: 0, null: false
    t.string  "last_comment_name",      limit: 60
    t.integer "last_comment_uid",       limit: 4,  default: 0, null: false
    t.integer "comment_count",          limit: 4,  default: 0, null: false
  end

  add_index "d7_node_comment_statistics", ["comment_count"], name: "comment_count", using: :btree
  add_index "d7_node_comment_statistics", ["last_comment_timestamp"], name: "node_comment_timestamp", using: :btree
  add_index "d7_node_comment_statistics", ["last_comment_uid"], name: "last_comment_uid", using: :btree

  create_table "d7_node_revision", primary_key: "vid", force: :cascade do |t|
    t.integer "nid",       limit: 4,          default: 0,  null: false
    t.integer "uid",       limit: 4,          default: 0,  null: false
    t.string  "title",     limit: 255,        default: "", null: false
    t.text    "log",       limit: 4294967295,              null: false
    t.integer "timestamp", limit: 4,          default: 0,  null: false
    t.integer "status",    limit: 4,          default: 1,  null: false
    t.integer "comment",   limit: 4,          default: 0,  null: false
    t.integer "promote",   limit: 4,          default: 0,  null: false
    t.integer "sticky",    limit: 4,          default: 0,  null: false
  end

  add_index "d7_node_revision", ["nid"], name: "nid", using: :btree
  add_index "d7_node_revision", ["uid"], name: "uid", using: :btree

  create_table "d7_node_type", primary_key: "type", force: :cascade do |t|
    t.string  "name",        limit: 255,        default: "", null: false
    t.string  "base",        limit: 255,                     null: false
    t.string  "module",      limit: 255,                     null: false
    t.text    "description", limit: 4294967295,              null: false
    t.text    "help",        limit: 4294967295,              null: false
    t.integer "has_title",   limit: 1,                       null: false
    t.string  "title_label", limit: 255,        default: "", null: false
    t.integer "custom",      limit: 1,          default: 0,  null: false
    t.integer "modified",    limit: 1,          default: 0,  null: false
    t.integer "locked",      limit: 1,          default: 0,  null: false
    t.integer "disabled",    limit: 1,          default: 0,  null: false
    t.string  "orig_type",   limit: 255,        default: "", null: false
  end

  create_table "d7_queue", primary_key: "item_id", force: :cascade do |t|
    t.string  "name",    limit: 255,        default: "", null: false
    t.binary  "data",    limit: 4294967295
    t.integer "expire",  limit: 4,          default: 0,  null: false
    t.integer "created", limit: 4,          default: 0,  null: false
  end

  add_index "d7_queue", ["expire"], name: "expire", using: :btree
  add_index "d7_queue", ["name", "created"], name: "name_created", using: :btree

  create_table "d7_rdf_mapping", id: false, force: :cascade do |t|
    t.string "type",    limit: 128,        null: false
    t.string "bundle",  limit: 128,        null: false
    t.binary "mapping", limit: 4294967295
  end

  create_table "d7_registry", id: false, force: :cascade do |t|
    t.string  "name",     limit: 255, default: "", null: false
    t.string  "type",     limit: 9,   default: "", null: false
    t.string  "filename", limit: 255,              null: false
    t.string  "module",   limit: 255, default: "", null: false
    t.integer "weight",   limit: 4,   default: 0,  null: false
  end

  add_index "d7_registry", ["type", "weight", "module"], name: "hook", using: :btree

  create_table "d7_registry_file", primary_key: "filename", force: :cascade do |t|
    t.string "hash", limit: 64, null: false
  end

  create_table "d7_role", primary_key: "rid", force: :cascade do |t|
    t.string  "name",   limit: 64, default: "", null: false
    t.integer "weight", limit: 4,  default: 0,  null: false
  end

  add_index "d7_role", ["name", "weight"], name: "name_weight", using: :btree
  add_index "d7_role", ["name"], name: "name", unique: true, using: :btree

  create_table "d7_role_permission", id: false, force: :cascade do |t|
    t.integer "rid",        limit: 4,                null: false
    t.string  "permission", limit: 128, default: "", null: false
    t.string  "module",     limit: 255, default: "", null: false
  end

  add_index "d7_role_permission", ["permission"], name: "permission", using: :btree

  create_table "d7_search_dataset", id: false, force: :cascade do |t|
    t.integer "sid",     limit: 4,          default: 0, null: false
    t.string  "type",    limit: 16,                     null: false
    t.text    "data",    limit: 4294967295,             null: false
    t.integer "reindex", limit: 4,          default: 0, null: false
  end

  create_table "d7_search_index", id: false, force: :cascade do |t|
    t.string  "word",  limit: 50, default: "", null: false
    t.integer "sid",   limit: 4,  default: 0,  null: false
    t.string  "type",  limit: 16,              null: false
    t.float   "score", limit: 24
  end

  add_index "d7_search_index", ["sid", "type"], name: "sid_type", using: :btree

  create_table "d7_search_node_links", id: false, force: :cascade do |t|
    t.integer "sid",     limit: 4,          default: 0,  null: false
    t.string  "type",    limit: 16,         default: "", null: false
    t.integer "nid",     limit: 4,          default: 0,  null: false
    t.text    "caption", limit: 4294967295
  end

  add_index "d7_search_node_links", ["nid"], name: "nid", using: :btree

  create_table "d7_search_total", primary_key: "word", force: :cascade do |t|
    t.float "count", limit: 24
  end

  create_table "d7_semaphore", primary_key: "name", force: :cascade do |t|
    t.string "value",  limit: 255, default: "", null: false
    t.float  "expire", limit: 53,               null: false
  end

  add_index "d7_semaphore", ["expire"], name: "expire", using: :btree
  add_index "d7_semaphore", ["value"], name: "value", using: :btree

  create_table "d7_sequences", primary_key: "value", force: :cascade do |t|
  end

  create_table "d7_sessions", id: false, force: :cascade do |t|
    t.integer "uid",       limit: 4,                       null: false
    t.string  "sid",       limit: 128,                     null: false
    t.string  "ssid",      limit: 128,        default: "", null: false
    t.string  "hostname",  limit: 128,        default: "", null: false
    t.integer "timestamp", limit: 4,          default: 0,  null: false
    t.integer "cache",     limit: 4,          default: 0,  null: false
    t.binary  "session",   limit: 4294967295
  end

  add_index "d7_sessions", ["ssid"], name: "ssid", using: :btree
  add_index "d7_sessions", ["timestamp"], name: "timestamp", using: :btree
  add_index "d7_sessions", ["uid"], name: "uid", using: :btree

  create_table "d7_shortcut_set", primary_key: "set_name", force: :cascade do |t|
    t.string "title", limit: 255, default: "", null: false
  end

  create_table "d7_shortcut_set_users", primary_key: "uid", force: :cascade do |t|
    t.string "set_name", limit: 32, default: "", null: false
  end

  add_index "d7_shortcut_set_users", ["set_name"], name: "set_name", using: :btree

  create_table "d7_spamicide", primary_key: "form_id", force: :cascade do |t|
    t.string  "form_field", limit: 64, default: "feed_me", null: false
    t.integer "enabled",    limit: 1,  default: 0,         null: false
    t.integer "removable",  limit: 1,  default: 1,         null: false
  end

  create_table "d7_system", primary_key: "filename", force: :cascade do |t|
    t.string  "name",           limit: 255,   default: "", null: false
    t.string  "type",           limit: 12,    default: "", null: false
    t.string  "owner",          limit: 255,   default: "", null: false
    t.integer "status",         limit: 4,     default: 0,  null: false
    t.integer "bootstrap",      limit: 4,     default: 0,  null: false
    t.integer "schema_version", limit: 2,     default: -1, null: false
    t.integer "weight",         limit: 4,     default: 0,  null: false
    t.binary  "info",           limit: 65535
  end

  add_index "d7_system", ["status", "bootstrap", "type", "weight", "name"], name: "system_list", using: :btree
  add_index "d7_system", ["type", "name"], name: "type_name", using: :btree

  create_table "d7_taxonomy_index", id: false, force: :cascade do |t|
    t.integer "nid",     limit: 4, default: 0, null: false
    t.integer "tid",     limit: 4, default: 0, null: false
    t.integer "sticky",  limit: 1, default: 0
    t.integer "created", limit: 4, default: 0, null: false
  end

  add_index "d7_taxonomy_index", ["nid"], name: "nid", using: :btree
  add_index "d7_taxonomy_index", ["tid", "sticky", "created"], name: "term_node", using: :btree

  create_table "d7_taxonomy_term_data", primary_key: "tid", force: :cascade do |t|
    t.integer "vid",         limit: 4,          default: 0,  null: false
    t.string  "name",        limit: 255,        default: "", null: false
    t.text    "description", limit: 4294967295
    t.string  "format",      limit: 255
    t.integer "weight",      limit: 4,          default: 0,  null: false
  end

  add_index "d7_taxonomy_term_data", ["name"], name: "name", using: :btree
  add_index "d7_taxonomy_term_data", ["vid", "name"], name: "vid_name", using: :btree
  add_index "d7_taxonomy_term_data", ["vid", "weight", "name"], name: "taxonomy_tree", using: :btree

  create_table "d7_taxonomy_term_hierarchy", id: false, force: :cascade do |t|
    t.integer "tid",    limit: 4, default: 0, null: false
    t.integer "parent", limit: 4, default: 0, null: false
  end

  add_index "d7_taxonomy_term_hierarchy", ["parent"], name: "parent", using: :btree

  create_table "d7_taxonomy_vocabulary", primary_key: "vid", force: :cascade do |t|
    t.string  "name",         limit: 255,        default: "", null: false
    t.string  "machine_name", limit: 255,        default: "", null: false
    t.text    "description",  limit: 4294967295
    t.integer "hierarchy",    limit: 1,          default: 0,  null: false
    t.string  "module",       limit: 255,        default: "", null: false
    t.integer "weight",       limit: 4,          default: 0,  null: false
  end

  add_index "d7_taxonomy_vocabulary", ["machine_name"], name: "machine_name", unique: true, using: :btree
  add_index "d7_taxonomy_vocabulary", ["weight", "name"], name: "list", using: :btree

  create_table "d7_themekey_properties", force: :cascade do |t|
    t.string  "property",  limit: 255,        default: "",  null: false
    t.string  "operator",  limit: 2,          default: "=", null: false
    t.string  "value",     limit: 255,        default: "",  null: false
    t.integer "weight",    limit: 4,          default: 0,   null: false
    t.string  "theme",     limit: 255,        default: "",  null: false
    t.integer "enabled",   limit: 4,          default: 0,   null: false
    t.text    "wildcards", limit: 4294967295,               null: false
    t.integer "parent",    limit: 4,          default: 0,   null: false
    t.string  "module",    limit: 255,        default: "",  null: false
  end

  add_index "d7_themekey_properties", ["enabled", "parent", "weight"], name: "enabled_parent_weight", using: :btree
  add_index "d7_themekey_properties", ["parent", "weight"], name: "parent_weight", using: :btree

  create_table "d7_url_alias", primary_key: "pid", force: :cascade do |t|
    t.string "source",   limit: 255, default: "", null: false
    t.string "alias",    limit: 255, default: "", null: false
    t.string "language", limit: 12,  default: "", null: false
  end

  add_index "d7_url_alias", ["alias", "language", "pid"], name: "alias_language_pid", using: :btree
  add_index "d7_url_alias", ["source", "language", "pid"], name: "source_language_pid", using: :btree

  create_table "d7_users", primary_key: "uid", force: :cascade do |t|
    t.string  "name",             limit: 60,         default: "", null: false
    t.string  "pass",             limit: 128,        default: "", null: false
    t.string  "mail",             limit: 254,        default: ""
    t.string  "theme",            limit: 255,        default: "", null: false
    t.string  "signature",        limit: 255,        default: "", null: false
    t.string  "signature_format", limit: 255
    t.integer "created",          limit: 4,          default: 0,  null: false
    t.integer "access",           limit: 4,          default: 0,  null: false
    t.integer "login",            limit: 4,          default: 0,  null: false
    t.integer "status",           limit: 1,          default: 0,  null: false
    t.string  "timezone",         limit: 32
    t.string  "language",         limit: 12,         default: "", null: false
    t.integer "picture",          limit: 4,          default: 0,  null: false
    t.string  "init",             limit: 254,        default: ""
    t.binary  "data",             limit: 4294967295
  end

  add_index "d7_users", ["access"], name: "access", using: :btree
  add_index "d7_users", ["created"], name: "created", using: :btree
  add_index "d7_users", ["mail"], name: "mail", using: :btree
  add_index "d7_users", ["name"], name: "name", unique: true, using: :btree
  add_index "d7_users", ["picture"], name: "picture", using: :btree

  create_table "d7_users_roles", id: false, force: :cascade do |t|
    t.integer "uid", limit: 4, default: 0, null: false
    t.integer "rid", limit: 4, default: 0, null: false
  end

  add_index "d7_users_roles", ["rid"], name: "rid", using: :btree

  create_table "d7_variable", primary_key: "name", force: :cascade do |t|
    t.binary "value", limit: 4294967295, null: false
  end

  create_table "d7_views_display", id: false, force: :cascade do |t|
    t.integer "vid",             limit: 4,          default: 0,  null: false
    t.string  "id",              limit: 64,         default: "", null: false
    t.string  "display_title",   limit: 64,         default: "", null: false
    t.string  "display_plugin",  limit: 64,         default: "", null: false
    t.integer "position",        limit: 4,          default: 0
    t.text    "display_options", limit: 4294967295
  end

  add_index "d7_views_display", ["vid", "position"], name: "vid", using: :btree

  create_table "d7_views_view", primary_key: "vid", force: :cascade do |t|
    t.string  "name",        limit: 128, default: "", null: false
    t.string  "description", limit: 255, default: ""
    t.string  "tag",         limit: 255, default: ""
    t.string  "base_table",  limit: 64,  default: "", null: false
    t.string  "human_name",  limit: 255, default: ""
    t.integer "core",        limit: 4,   default: 0
  end

  add_index "d7_views_view", ["name"], name: "name", unique: true, using: :btree

  create_table "d7_watchdog", primary_key: "wid", force: :cascade do |t|
    t.integer "uid",       limit: 4,          default: 0,  null: false
    t.string  "type",      limit: 64,         default: "", null: false
    t.text    "message",   limit: 4294967295,              null: false
    t.binary  "variables", limit: 4294967295,              null: false
    t.integer "severity",  limit: 1,          default: 0,  null: false
    t.string  "link",      limit: 255,        default: ""
    t.text    "location",  limit: 16777215,                null: false
    t.text    "referer",   limit: 16777215
    t.string  "hostname",  limit: 128,        default: "", null: false
    t.integer "timestamp", limit: 4,          default: 0,  null: false
  end

  add_index "d7_watchdog", ["severity"], name: "severity", using: :btree
  add_index "d7_watchdog", ["type"], name: "type", using: :btree
  add_index "d7_watchdog", ["uid"], name: "uid", using: :btree

  create_table "distinctions", force: :cascade do |t|
    t.date     "dist_date"
    t.integer  "certificates",              limit: 4
    t.integer  "honorletters",              limit: 4
    t.integer  "medals",                    limit: 4
    t.integer  "orchestra_id_old",          limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "gold_needles",              limit: 4
    t.integer  "silver_needles",            limit: 4
    t.integer  "national_needles",          limit: 4
    t.integer  "member_account_booking_id", limit: 4
    t.float    "porto",                     limit: 24
    t.integer  "orchestra_id",              limit: 4
    t.string   "invoice_id",                limit: 255
  end

  add_index "distinctions", ["member_account_booking_id"], name: "index_distinctions_on_member_account_booking_id", using: :btree
  add_index "distinctions", ["orchestra_id_old"], name: "index_distinctions_on_orchestra_id_old", using: :btree

  create_table "ensemble_concerts", force: :cascade do |t|
    t.datetime "datum",                                                                     null: false
    t.time     "zeit",                                      default: '2000-01-01 00:00:00', null: false
    t.datetime "reported",                                                                  null: false
    t.datetime "confirmed"
    t.string   "stadt",        limit: 255,                  default: "",                    null: false
    t.string   "ort",          limit: 255,                  default: "",                    null: false
    t.integer  "festival_id",  limit: 8,                    default: 0,                     null: false
    t.integer  "ensemble_id",  limit: 8,                    default: 0,                     null: false
    t.text     "titel",        limit: 65535,                                                null: false
    t.string   "comment",      limit: 255,                  default: "",                    null: false
    t.decimal  "eintritt",                   precision: 10,                                 null: false
    t.integer  "state_id",     limit: 8,                                                    null: false
    t.integer  "country_id",   limit: 8,                    default: 0,                     null: false
    t.string   "email",        limit: 255,                  default: "",                    null: false
    t.integer  "fk_owner",     limit: 8,                    default: 1,                     null: false
    t.integer  "visible",      limit: 2,                    default: 0,                     null: false
    t.text     "url",          limit: 65535,                                                null: false
    t.string   "country_code", limit: 2
  end

  add_index "ensemble_concerts", ["country_id"], name: "land", using: :btree
  add_index "ensemble_concerts", ["datum", "zeit", "ensemble_id"], name: "unique_event", unique: true, using: :btree
  add_index "ensemble_concerts", ["ensemble_id"], name: "ensemble_id", using: :btree
  add_index "ensemble_concerts", ["fk_owner"], name: "fk_owner", using: :btree
  add_index "ensemble_concerts", ["state_id"], name: "bundesland", using: :btree

  create_table "ensembles", force: :cascade do |t|
    t.string  "name",         limit: 255, default: "", null: false
    t.string  "homepage",     limit: 255, default: "", null: false
    t.string  "beschreibung", limit: 255, default: "", null: false
    t.string  "email",        limit: 255, default: "", null: false
    t.integer "owner",        limit: 8,                null: false
    t.integer "visible",      limit: 2,   default: 0,  null: false
    t.integer "mglnr",        limit: 4
  end

  add_index "ensembles", ["owner"], name: "owner", using: :btree

  create_table "event_cards", force: :cascade do |t|
    t.datetime "orderdate",                                     null: false
    t.string   "name",              limit: 100,                 null: false
    t.string   "email",             limit: 100,                 null: false
    t.integer  "nr_fest",           limit: 4,   default: 0,     null: false
    t.integer  "nr_fest_erm",       limit: 4,   default: 0,     null: false
    t.integer  "nr_fest_bdz",       limit: 4,   default: 0,     null: false
    t.integer  "nr_fest_bdz_erm",   limit: 4,   default: 0,     null: false
    t.integer  "nr_do",             limit: 4,   default: 0,     null: false
    t.integer  "nr_do_erm",         limit: 4,   default: 0,     null: false
    t.integer  "nr_fr",             limit: 4,   default: 0,     null: false
    t.integer  "nr_fr_erm",         limit: 4,   default: 0,     null: false
    t.integer  "nr_sa",             limit: 4,   default: 0,     null: false
    t.integer  "nr_sa_erm",         limit: 4,   default: 0,     null: false
    t.integer  "nr_concert_so",     limit: 4,   default: 0,     null: false
    t.integer  "nr_concert_so_erm", limit: 4,   default: 0,     null: false
    t.boolean  "invoiced",                      default: false
    t.boolean  "payment_received",              default: false
    t.string   "street",            limit: 255
    t.string   "city",              limit: 255
    t.string   "country_code",      limit: 255
    t.string   "company",           limit: 255
    t.string   "preferred_lang",    limit: 255
    t.string   "zip",               limit: 255
    t.boolean  "pickup",                        default: false
  end

  create_table "event_food", force: :cascade do |t|
    t.integer  "tln",            limit: 4,   null: false
    t.integer  "veg",            limit: 4,   null: false
    t.string   "name",           limit: 255, null: false
    t.string   "email",          limit: 255, null: false
    t.datetime "orderdate",                  null: false
    t.integer  "participant_id", limit: 4
    t.datetime "arrival_time"
  end

  create_table "feature_requests", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.integer  "priority",    limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "status",      limit: 255,   default: "N"
    t.integer  "user_id",     limit: 4
  end

  create_table "festival_application_attachments", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "attached_file_file_name",    limit: 255
    t.string   "attached_file_content_type", limit: 255
    t.integer  "attached_file_file_size",    limit: 4
    t.datetime "attached_file_updated_at"
    t.integer  "festival_application_id",    limit: 4
  end

  create_table "festival_applications", force: :cascade do |t|
    t.integer  "orchestra_id",          limit: 4
    t.text     "orch_name",             limit: 65535
    t.text     "conductor",             limit: 65535
    t.integer  "num_players",           limit: 4
    t.text     "equipment",             limit: 65535
    t.text     "special_cast",          limit: 65535
    t.integer  "contact_person_id_off", limit: 4
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "group_type",            limit: 255
    t.string   "uuid",                  limit: 255
    t.boolean  "permission"
    t.integer  "festival_concert_id",   limit: 4
    t.datetime "rehearsal_time"
    t.string   "visitor_type",          limit: 255
    t.string   "country_code",          limit: 2
    t.string   "payment_status",        limit: 1,     default: "N"
    t.integer  "tickets",               limit: 4
    t.integer  "tickets_red",           limit: 4
    t.integer  "bdz_tickets",           limit: 4
    t.integer  "bdz_tickets_red",       limit: 4
    t.float    "amount",                limit: 53
    t.integer  "soloist_tickets",       limit: 4
    t.time     "stage_time"
    t.string   "contact_phone",         limit: 255
    t.integer  "festival_year",         limit: 4
    t.string   "token",                 limit: 255
    t.string   "comment",               limit: 255
  end

  create_table "festival_concerts", force: :cascade do |t|
    t.string   "location",     limit: 255
    t.datetime "event_time"
    t.integer  "number",       limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title",        limit: 255
    t.boolean  "outdoor"
    t.string   "concert_type", limit: 1
  end

  create_table "festival_pieces", force: :cascade do |t|
    t.integer  "festival_application_id", limit: 4
    t.string   "composer",                limit: 255
    t.string   "title",                   limit: 255
    t.string   "duration",                limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "festivals", force: :cascade do |t|
    t.date    "startdate",                                  null: false
    t.date    "enddate",                                    null: false
    t.integer "bland",        limit: 8,                     null: false
    t.string  "name",         limit: 255,   default: "",    null: false
    t.text    "description",  limit: 65535,                 null: false
    t.text    "anmeldung",    limit: 65535,                 null: false
    t.text    "gebuehren",    limit: 65535,                 null: false
    t.string  "stadt",        limit: 255,   default: "",    null: false
    t.string  "homepage",     limit: 255,   default: "",    null: false
    t.string  "ort",          limit: 255,   default: "",    null: false
    t.text    "ortdetails",   limit: 65535,                 null: false
    t.boolean "visible",                    default: false, null: false
    t.string  "country_code", limit: 2
  end

  add_index "festivals", ["bland"], name: "bland", using: :btree

  create_table "functions", force: :cascade do |t|
    t.string  "label",                    limit: 10
    t.integer "regional_organization_id", limit: 8,                 null: false
    t.integer "board_contact_id",         limit: 8,                 null: false
    t.boolean "bund",                                               null: false
    t.boolean "jugend",                                             null: false
    t.integer "musik",                    limit: 4,     default: 0, null: false
    t.integer "nr",                       limit: 4,                 null: false
    t.string  "funktion",                 limit: 50,                null: false
    t.text    "fkt_subtitle",             limit: 65535,             null: false
  end

  add_index "functions", ["board_contact_id"], name: "fk_addr_id", using: :btree
  add_index "functions", ["regional_organization_id", "board_contact_id"], name: "fk_lv_id", using: :btree

  create_table "gallery2_AccessMap", id: false, force: :cascade do |t|
    t.integer "g_accessListId",  limit: 4, null: false
    t.integer "g_userOrGroupId", limit: 4, null: false
    t.integer "g_permission",    limit: 4, null: false
  end

  add_index "gallery2_AccessMap", ["g_accessListId"], name: "gallery2_AccessMap_83732", using: :btree
  add_index "gallery2_AccessMap", ["g_permission"], name: "gallery2_AccessMap_18058", using: :btree
  add_index "gallery2_AccessMap", ["g_userOrGroupId"], name: "gallery2_AccessMap_48775", using: :btree

  create_table "gallery2_AccessSubscriberMap", primary_key: "g_itemId", force: :cascade do |t|
    t.integer "g_accessListId", limit: 4, null: false
  end

  add_index "gallery2_AccessSubscriberMap", ["g_accessListId"], name: "gallery2_AccessSubscriberMap_83732", using: :btree

  create_table "gallery2_AlbumItem", primary_key: "g_id", force: :cascade do |t|
    t.string "g_theme",          limit: 32
    t.string "g_orderBy",        limit: 128
    t.string "g_orderDirection", limit: 32
  end

  create_table "gallery2_AnimationItem", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_width",  limit: 4
    t.integer "g_height", limit: 4
  end

  create_table "gallery2_CacheMap", id: false, force: :cascade do |t|
    t.string  "g_key",       limit: 32,         null: false
    t.text    "g_value",     limit: 4294967295
    t.integer "g_userId",    limit: 4,          null: false
    t.integer "g_itemId",    limit: 4,          null: false
    t.string  "g_type",      limit: 32,         null: false
    t.integer "g_timestamp", limit: 4,          null: false
    t.integer "g_isEmpty",   limit: 4
  end

  add_index "gallery2_CacheMap", ["g_itemId"], name: "gallery2_CacheMap_75985", using: :btree
  add_index "gallery2_CacheMap", ["g_userId", "g_timestamp", "g_isEmpty"], name: "gallery2_CacheMap_21979", using: :btree

  create_table "gallery2_ChildEntity", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_parentId", limit: 4, null: false
  end

  add_index "gallery2_ChildEntity", ["g_parentId"], name: "gallery2_ChildEntity_52718", using: :btree

  create_table "gallery2_Comment", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_commenterId",   limit: 4,                 null: false
    t.string  "g_host",          limit: 128,               null: false
    t.string  "g_subject",       limit: 128
    t.text    "g_comment",       limit: 65535
    t.integer "g_date",          limit: 4,                 null: false
    t.string  "g_author",        limit: 128
    t.integer "g_publishStatus", limit: 4,     default: 0, null: false
  end

  add_index "gallery2_Comment", ["g_date"], name: "gallery2_Comment_95610", using: :btree
  add_index "gallery2_Comment", ["g_publishStatus"], name: "gallery2_Comment_70722", using: :btree

  create_table "gallery2_DataItem", primary_key: "g_id", force: :cascade do |t|
    t.string  "g_mimeType", limit: 128
    t.integer "g_size",     limit: 4
  end

  create_table "gallery2_Derivative", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_derivativeSourceId",   limit: 4,   null: false
    t.string  "g_derivativeOperations", limit: 255
    t.integer "g_derivativeOrder",      limit: 4,   null: false
    t.integer "g_derivativeSize",       limit: 4
    t.integer "g_derivativeType",       limit: 4,   null: false
    t.string  "g_mimeType",             limit: 128, null: false
    t.string  "g_postFilterOperations", limit: 255
    t.integer "g_isBroken",             limit: 4
  end

  add_index "gallery2_Derivative", ["g_derivativeOrder"], name: "gallery2_Derivative_25243", using: :btree
  add_index "gallery2_Derivative", ["g_derivativeSourceId"], name: "gallery2_Derivative_85338", using: :btree
  add_index "gallery2_Derivative", ["g_derivativeType"], name: "gallery2_Derivative_97216", using: :btree

  create_table "gallery2_DerivativeImage", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_width",  limit: 4
    t.integer "g_height", limit: 4
  end

  create_table "gallery2_DerivativePrefsMap", id: false, force: :cascade do |t|
    t.integer "g_itemId",               limit: 4
    t.integer "g_order",                limit: 4
    t.integer "g_derivativeType",       limit: 4
    t.string  "g_derivativeOperations", limit: 255
  end

  add_index "gallery2_DerivativePrefsMap", ["g_itemId"], name: "gallery2_DerivativePrefsMap_75985", using: :btree

  create_table "gallery2_DescendentCountsMap", id: false, force: :cascade do |t|
    t.integer "g_userId",          limit: 4, null: false
    t.integer "g_itemId",          limit: 4, null: false
    t.integer "g_descendentCount", limit: 4, null: false
  end

  create_table "gallery2_Entity", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_creationTimestamp",     limit: 4,   null: false
    t.integer "g_isLinkable",            limit: 4,   null: false
    t.integer "g_linkId",                limit: 4
    t.integer "g_modificationTimestamp", limit: 4,   null: false
    t.integer "g_serialNumber",          limit: 4,   null: false
    t.string  "g_entityType",            limit: 32,  null: false
    t.string  "g_onLoadHandlers",        limit: 128
  end

  add_index "gallery2_Entity", ["g_creationTimestamp"], name: "gallery2_Entity_76255", using: :btree
  add_index "gallery2_Entity", ["g_isLinkable"], name: "gallery2_Entity_35978", using: :btree
  add_index "gallery2_Entity", ["g_linkId"], name: "gallery2_Entity_44738", using: :btree
  add_index "gallery2_Entity", ["g_modificationTimestamp"], name: "gallery2_Entity_63025", using: :btree
  add_index "gallery2_Entity", ["g_serialNumber"], name: "gallery2_Entity_60702", using: :btree

  create_table "gallery2_EventLogMap", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_userId",    limit: 4
    t.string  "g_type",      limit: 32
    t.string  "g_summary",   limit: 255
    t.text    "g_details",   limit: 65535
    t.string  "g_location",  limit: 255
    t.string  "g_client",    limit: 128
    t.integer "g_timestamp", limit: 4,     null: false
    t.string  "g_referer",   limit: 128
  end

  add_index "gallery2_EventLogMap", ["g_timestamp"], name: "gallery2_EventLogMap_24286", using: :btree

  create_table "gallery2_ExifPropertiesMap", id: false, force: :cascade do |t|
    t.string  "g_property", limit: 128
    t.integer "g_viewMode", limit: 4
    t.integer "g_sequence", limit: 4
  end

  add_index "gallery2_ExifPropertiesMap", ["g_property", "g_viewMode"], name: "g_property", unique: true, using: :btree

  create_table "gallery2_ExternalIdMap", id: false, force: :cascade do |t|
    t.string  "g_externalId", limit: 128, null: false
    t.string  "g_entityType", limit: 32,  null: false
    t.integer "g_entityId",   limit: 4,   null: false
  end

  create_table "gallery2_FactoryMap", id: false, force: :cascade do |t|
    t.string "g_classType",    limit: 128
    t.string "g_className",    limit: 128
    t.string "g_implId",       limit: 128
    t.string "g_implPath",     limit: 128
    t.string "g_implModuleId", limit: 128
    t.string "g_hints",        limit: 255
    t.string "g_orderWeight",  limit: 255
  end

  create_table "gallery2_FailedLoginsMap", primary_key: "g_userName", force: :cascade do |t|
    t.integer "g_count",       limit: 4, null: false
    t.integer "g_lastAttempt", limit: 4, null: false
  end

  create_table "gallery2_FileSystemEntity", primary_key: "g_id", force: :cascade do |t|
    t.string "g_pathComponent", limit: 128
  end

  add_index "gallery2_FileSystemEntity", ["g_pathComponent"], name: "gallery2_FileSystemEntity_3406", using: :btree

  create_table "gallery2_Group", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_groupType", limit: 4,   null: false
    t.string  "g_groupName", limit: 128
  end

  add_index "gallery2_Group", ["g_groupName"], name: "g_groupName", unique: true, using: :btree

  create_table "gallery2_Item", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_canContainChildren",   limit: 4,     null: false
    t.text    "g_description",          limit: 65535
    t.string  "g_keywords",             limit: 255
    t.integer "g_ownerId",              limit: 4,     null: false
    t.string  "g_renderer",             limit: 128
    t.string  "g_summary",              limit: 255
    t.string  "g_title",                limit: 128
    t.integer "g_viewedSinceTimestamp", limit: 4,     null: false
    t.integer "g_originationTimestamp", limit: 4,     null: false
  end

  add_index "gallery2_Item", ["g_keywords"], name: "gallery2_Item_99070", using: :btree
  add_index "gallery2_Item", ["g_ownerId"], name: "gallery2_Item_21573", using: :btree
  add_index "gallery2_Item", ["g_summary"], name: "gallery2_Item_54147", using: :btree
  add_index "gallery2_Item", ["g_title"], name: "gallery2_Item_90059", using: :btree

  create_table "gallery2_ItemAttributesMap", primary_key: "g_itemId", force: :cascade do |t|
    t.integer "g_viewCount",      limit: 4
    t.integer "g_orderWeight",    limit: 4
    t.string  "g_parentSequence", limit: 255, null: false
  end

  add_index "gallery2_ItemAttributesMap", ["g_parentSequence"], name: "gallery2_ItemAttributesMap_95270", using: :btree

  create_table "gallery2_Lock", id: false, force: :cascade do |t|
    t.integer "g_lockId",        limit: 4
    t.integer "g_readEntityId",  limit: 4
    t.integer "g_writeEntityId", limit: 4
    t.integer "g_freshUntil",    limit: 4
    t.integer "g_request",       limit: 4
  end

  add_index "gallery2_Lock", ["g_lockId"], name: "gallery2_Lock_11039", using: :btree

  create_table "gallery2_MaintenanceMap", primary_key: "g_runId", force: :cascade do |t|
    t.string  "g_taskId",    limit: 128,   null: false
    t.integer "g_timestamp", limit: 4
    t.integer "g_success",   limit: 4
    t.text    "g_details",   limit: 65535
  end

  add_index "gallery2_MaintenanceMap", ["g_taskId"], name: "gallery2_MaintenanceMap_21687", using: :btree

  create_table "gallery2_MimeTypeMap", primary_key: "g_extension", force: :cascade do |t|
    t.string  "g_mimeType", limit: 128, null: false
    t.integer "g_viewable", limit: 4
  end

  create_table "gallery2_MovieItem", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_width",    limit: 4
    t.integer "g_height",   limit: 4
    t.integer "g_duration", limit: 4
  end

  create_table "gallery2_OpenIdMap", id: false, force: :cascade do |t|
    t.string  "g_openId",    limit: 128
    t.integer "g_galleryId", limit: 4
  end

  create_table "gallery2_PendingUser", primary_key: "g_id", force: :cascade do |t|
    t.string "g_userName",        limit: 32,  null: false
    t.string "g_fullName",        limit: 128
    t.string "g_hashedPassword",  limit: 128
    t.string "g_email",           limit: 128
    t.string "g_language",        limit: 128
    t.string "g_registrationKey", limit: 32
  end

  add_index "gallery2_PendingUser", ["g_userName"], name: "g_userName", unique: true, using: :btree

  create_table "gallery2_PermissionSetMap", id: false, force: :cascade do |t|
    t.string  "g_module",      limit: 128, null: false
    t.string  "g_permission",  limit: 128, null: false
    t.string  "g_description", limit: 255
    t.integer "g_bits",        limit: 4,   null: false
    t.integer "g_flags",       limit: 4,   null: false
  end

  add_index "gallery2_PermissionSetMap", ["g_permission"], name: "g_permission", unique: true, using: :btree

  create_table "gallery2_PhotoItem", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_width",  limit: 4
    t.integer "g_height", limit: 4
  end

  create_table "gallery2_PluginMap", id: false, force: :cascade do |t|
    t.string  "g_pluginType", limit: 32, null: false
    t.string  "g_pluginId",   limit: 32, null: false
    t.integer "g_active",     limit: 4,  null: false
  end

  create_table "gallery2_PluginPackageMap", id: false, force: :cascade do |t|
    t.string  "g_pluginType",     limit: 32, null: false
    t.string  "g_pluginId",       limit: 32, null: false
    t.string  "g_packageName",    limit: 32, null: false
    t.string  "g_packageVersion", limit: 32, null: false
    t.string  "g_packageBuild",   limit: 32, null: false
    t.integer "g_locked",         limit: 4,  null: false
  end

  add_index "gallery2_PluginPackageMap", ["g_pluginType"], name: "gallery2_PluginPackageMap_80596", using: :btree

  create_table "gallery2_PluginParameterMap", id: false, force: :cascade do |t|
    t.string  "g_pluginType",     limit: 32,    null: false
    t.string  "g_pluginId",       limit: 32,    null: false
    t.integer "g_itemId",         limit: 4,     null: false
    t.string  "g_parameterName",  limit: 128,   null: false
    t.text    "g_parameterValue", limit: 65535, null: false
  end

  add_index "gallery2_PluginParameterMap", ["g_pluginType", "g_pluginId", "g_itemId", "g_parameterName"], name: "g_pluginType", unique: true, using: :btree
  add_index "gallery2_PluginParameterMap", ["g_pluginType", "g_pluginId", "g_itemId"], name: "gallery2_PluginParameterMap_12808", using: :btree
  add_index "gallery2_PluginParameterMap", ["g_pluginType"], name: "gallery2_PluginParameterMap_80596", using: :btree

  create_table "gallery2_RatingCacheMap", primary_key: "g_itemId", force: :cascade do |t|
    t.integer "g_averageRating", limit: 4, null: false
    t.integer "g_voteCount",     limit: 4, null: false
  end

  create_table "gallery2_RatingMap", primary_key: "g_ratingId", force: :cascade do |t|
    t.integer "g_itemId",           limit: 4,   null: false
    t.integer "g_userId",           limit: 4,   null: false
    t.integer "g_rating",           limit: 4,   null: false
    t.string  "g_sessionId",        limit: 128
    t.string  "g_remoteIdentifier", limit: 255
  end

  add_index "gallery2_RatingMap", ["g_itemId", "g_remoteIdentifier"], name: "gallery2_RatingMap_2369", using: :btree
  add_index "gallery2_RatingMap", ["g_itemId", "g_userId"], name: "gallery2_RatingMap_80383", using: :btree
  add_index "gallery2_RatingMap", ["g_itemId"], name: "gallery2_RatingMap_75985", using: :btree

  create_table "gallery2_RecoverPasswordMap", primary_key: "g_userName", force: :cascade do |t|
    t.string  "g_authString",     limit: 32, null: false
    t.integer "g_requestExpires", limit: 4,  null: false
  end

  create_table "gallery2_Schema", primary_key: "g_name", force: :cascade do |t|
    t.integer "g_major",     limit: 4,     null: false
    t.integer "g_minor",     limit: 4,     null: false
    t.text    "g_createSql", limit: 65535
    t.string  "g_pluginId",  limit: 32
    t.string  "g_type",      limit: 32
    t.text    "g_info",      limit: 65535
  end

  create_table "gallery2_SequenceEventLog", id: false, force: :cascade do |t|
    t.integer "id", limit: 4, null: false
  end

  create_table "gallery2_SequenceId", id: false, force: :cascade do |t|
    t.integer "id", limit: 4, null: false
  end

  create_table "gallery2_SequenceLock", id: false, force: :cascade do |t|
    t.integer "id", limit: 4, null: false
  end

  create_table "gallery2_SessionMap", primary_key: "g_id", force: :cascade do |t|
    t.integer "g_userId",                limit: 4,          null: false
    t.string  "g_remoteIdentifier",      limit: 128,        null: false
    t.integer "g_creationTimestamp",     limit: 4,          null: false
    t.integer "g_modificationTimestamp", limit: 4,          null: false
    t.text    "g_data",                  limit: 4294967295
  end

  add_index "gallery2_SessionMap", ["g_userId", "g_creationTimestamp", "g_modificationTimestamp"], name: "gallery2_SessionMap_53500", using: :btree

  create_table "gallery2_TkOperatnMap", primary_key: "g_name", force: :cascade do |t|
    t.string "g_parametersCrc",  limit: 32,  null: false
    t.string "g_outputMimeType", limit: 128
    t.string "g_description",    limit: 255
  end

  create_table "gallery2_TkOperatnMimeTypeMap", id: false, force: :cascade do |t|
    t.string  "g_operationName", limit: 128, null: false
    t.string  "g_toolkitId",     limit: 128, null: false
    t.string  "g_mimeType",      limit: 128, null: false
    t.integer "g_priority",      limit: 4,   null: false
  end

  add_index "gallery2_TkOperatnMimeTypeMap", ["g_mimeType"], name: "gallery2_TkOperatnMimeTypeMap_79463", using: :btree
  add_index "gallery2_TkOperatnMimeTypeMap", ["g_operationName"], name: "gallery2_TkOperatnMimeTypeMap_2014", using: :btree

  create_table "gallery2_TkOperatnParameterMap", id: false, force: :cascade do |t|
    t.string  "g_operationName", limit: 128, null: false
    t.integer "g_position",      limit: 4,   null: false
    t.string  "g_type",          limit: 128, null: false
    t.string  "g_description",   limit: 255
  end

  add_index "gallery2_TkOperatnParameterMap", ["g_operationName"], name: "gallery2_TkOperatnParameterMap_2014", using: :btree

  create_table "gallery2_TkPropertyMap", id: false, force: :cascade do |t|
    t.string "g_name",        limit: 128, null: false
    t.string "g_type",        limit: 128, null: false
    t.string "g_description", limit: 128, null: false
  end

  create_table "gallery2_TkPropertyMimeTypeMap", id: false, force: :cascade do |t|
    t.string "g_propertyName", limit: 128, null: false
    t.string "g_toolkitId",    limit: 128, null: false
    t.string "g_mimeType",     limit: 128, null: false
  end

  add_index "gallery2_TkPropertyMimeTypeMap", ["g_mimeType"], name: "gallery2_TkPropertyMimeTypeMap_79463", using: :btree
  add_index "gallery2_TkPropertyMimeTypeMap", ["g_propertyName"], name: "gallery2_TkPropertyMimeTypeMap_52881", using: :btree

  create_table "gallery2_UnknownItem", primary_key: "g_id", force: :cascade do |t|
  end

  create_table "gallery2_User", primary_key: "g_id", force: :cascade do |t|
    t.string  "g_userName",       limit: 32,              null: false
    t.string  "g_fullName",       limit: 128
    t.string  "g_hashedPassword", limit: 128
    t.string  "g_email",          limit: 255
    t.string  "g_language",       limit: 128
    t.integer "g_locked",         limit: 4,   default: 0
  end

  add_index "gallery2_User", ["g_userName"], name: "g_userName", unique: true, using: :btree

  create_table "gallery2_UserGroupMap", id: false, force: :cascade do |t|
    t.integer "g_userId",  limit: 4, null: false
    t.integer "g_groupId", limit: 4, null: false
  end

  add_index "gallery2_UserGroupMap", ["g_groupId"], name: "gallery2_UserGroupMap_89328", using: :btree
  add_index "gallery2_UserGroupMap", ["g_userId"], name: "gallery2_UserGroupMap_69068", using: :btree

  create_table "gema_events", force: :cascade do |t|
    t.integer "kdnr",              limit: 4
    t.string  "name",              limit: 255
    t.string  "zip",               limit: 255
    t.string  "city",              limit: 255
    t.date    "date"
    t.string  "title",             limit: 255
    t.string  "tariff",            limit: 255
    t.float   "amount",            limit: 24
    t.string  "location",          limit: 255
    t.string  "location_city",     limit: 255
    t.boolean "program_available"
    t.string  "source",            limit: 255
    t.string  "par_mgl",           limit: 255
    t.string  "nf_id",             limit: 255
  end

  create_table "geo_orte", id: false, force: :cascade do |t|
    t.integer "loc_id",    limit: 8,   null: false
    t.string  "ags",       limit: 10,  null: false
    t.string  "ascii",     limit: 50,  null: false
    t.string  "name",      limit: 50,  null: false
    t.float   "lat",       limit: 53,  null: false
    t.float   "lon",       limit: 53,  null: false
    t.string  "amt",       limit: 20,  null: false
    t.string  "plz",       limit: 255, null: false
    t.string  "vorwahl",   limit: 10,  null: false
    t.string  "einwohner", limit: 15,  null: false
    t.float   "flaeche",   limit: 53,  null: false
    t.string  "kz",        limit: 10,  null: false
    t.string  "typ",       limit: 10,  null: false
    t.string  "level",     limit: 10,  null: false
    t.integer "of",        limit: 8,   null: false
    t.string  "invalid",   limit: 10,  null: false
  end

  add_index "geo_orte", ["loc_id"], name: "loc_id", using: :btree
  add_index "geo_orte", ["name"], name: "name", using: :btree
  add_index "geo_orte", ["of"], name: "of", using: :btree
  add_index "geo_orte", ["plz"], name: "plz", using: :btree

  create_table "guestbook", force: :cascade do |t|
    t.string   "name",      limit: 50,    null: false
    t.string   "email",     limit: 50,    null: false
    t.datetime "date",                    null: false
    t.string   "ip",        limit: 255,   null: false
    t.text     "message",   limit: 65535, null: false
    t.string   "anmerkung", limit: 255,   null: false
    t.datetime "confirmed",               null: false
    t.boolean  "visible",                 null: false
  end

  create_table "homepages", force: :cascade do |t|
    t.string   "abbrev",     limit: 20,    null: false
    t.string   "mitglnr",    limit: 6,     null: false
    t.string   "name",       limit: 100,   null: false
    t.text     "kontakt",    limit: 65535, null: false
    t.text     "proben",     limit: 65535, null: false
    t.text     "descr",      limit: 65535, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "redir_url",  limit: 255
  end

  create_table "honor_members", force: :cascade do |t|
    t.integer "nr",        limit: 8
    t.string  "anrede",    limit: 100
    t.string  "vorname",   limit: 100
    t.string  "name",      limit: 100
    t.string  "ort",       limit: 100
    t.string  "honorType", limit: 100
    t.date    "honorDate"
    t.boolean "deceased"
  end

  create_table "jugend_artikel", force: :cascade do |t|
    t.string  "titel",   limit: 255, null: false
    t.string  "autor",   limit: 255, null: false
    t.string  "file",    limit: 255, null: false
    t.integer "jahr",    limit: 4,   null: false
    t.integer "ausgabe", limit: 1,   null: false
  end

  create_table "komponisten", force: :cascade do |t|
    t.string  "name",        limit: 100, null: false
    t.string  "vorname",     limit: 100, null: false
    t.string  "gebjahr",     limit: 11,  null: false
    t.string  "sterbejahr",  limit: 11,  null: false
    t.boolean "ca_geb",                  null: false
    t.boolean "ca_sterb",                null: false
    t.integer "fk_ref_komp", limit: 8
    t.string  "comment",     limit: 200, null: false
  end

  create_table "konzert2ensemble", id: false, force: :cascade do |t|
    t.integer "fk_konz_id", limit: 8, null: false
    t.integer "fk_ens_id",  limit: 8, null: false
  end

  create_table "magazine_adverts", force: :cascade do |t|
    t.integer  "advertiser_id",     limit: 4
    t.integer  "magazine_issue_id", limit: 4
    t.string   "advert_type",       limit: 1, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "magazine_adverts", ["advertiser_id"], name: "advertiser_id", using: :btree
  add_index "magazine_adverts", ["magazine_issue_id"], name: "magazine_issue_id", using: :btree

  create_table "magazine_issues", force: :cascade do |t|
    t.integer  "year",       limit: 4
    t.integer  "number",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "magazine_samplings", force: :cascade do |t|
    t.integer  "count",          limit: 4
    t.integer  "contact_id_off", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "member_account_bookings", force: :cascade do |t|
    t.integer  "member_id",      limit: 8,   null: false
    t.string   "booking_type",   limit: 1,   null: false
    t.integer  "booking_year",   limit: 4,   null: false
    t.string   "booking_mode",   limit: 1,   null: false
    t.datetime "booking_date",               null: false
    t.string   "booking_txt",    limit: 255, null: false
    t.string   "filename",       limit: 100
    t.float    "amount",         limit: 53,  null: false
    t.integer  "ref_booking_id", limit: 4
    t.string   "invoice_id",     limit: 255
  end

  add_index "member_account_bookings", ["member_id"], name: "member_id", using: :btree
  add_index "member_account_bookings", ["ref_booking_id"], name: "index_member_account_bookings_on_ref_booking_id", using: :btree

  create_table "member_events", force: :cascade do |t|
    t.string   "event_type", limit: 255
    t.datetime "event_date"
    t.string   "event_id",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "member_id",  limit: 8
    t.string   "comment",    limit: 255
    t.string   "filename",   limit: 255
  end

  add_index "member_events", ["member_id"], name: "member_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.string   "subtype",                  limit: 50
    t.integer  "regional_organization_id", limit: 8,                   null: false
    t.integer  "mglnr",                    limit: 8,                   null: false
    t.string   "anrede",                   limit: 20,                  null: false
    t.string   "vorname",                  limit: 100,                 null: false
    t.string   "name",                     limit: 100,                 null: false
    t.string   "strasse",                  limit: 50,                  null: false
    t.string   "plz",                      limit: 20,                  null: false
    t.string   "ort",                      limit: 50,                  null: false
    t.string   "email",                    limit: 100
    t.date     "eintritt",                                             null: false
    t.date     "austritt_zum"
    t.string   "za",                       limit: 1,                   null: false
    t.integer  "konto",                    limit: 8
    t.string   "blz",                      limit: 8
    t.string   "zahler",                   limit: 100
    t.datetime "created_at",                                           null: false
    t.datetime "update_at"
    t.string   "telefon",                  limit: 255
    t.string   "fax",                      limit: 255
    t.string   "bic",                      limit: 255
    t.string   "iban",                     limit: 255
    t.string   "country_code",             limit: 2
    t.string   "title",                    limit: 255
    t.string   "member_entity_type",       limit: 255
    t.integer  "member_entity_id",         limit: 4
    t.boolean  "deleted",                              default: false
    t.datetime "deleted_at"
    t.boolean  "dsgvo"
    t.datetime "dsgvo_date"
  end

  add_index "members", ["deleted_at"], name: "index_members_on_deleted_at", using: :btree
  add_index "members", ["mglnr"], name: "mglnr", unique: true, using: :btree

  create_table "members_v", id: false, force: :cascade do |t|
    t.integer "id",                       limit: 1, null: false
    t.integer "subtype",                  limit: 1, null: false
    t.integer "regional_organization_id", limit: 1, null: false
    t.integer "mglnr",                    limit: 1, null: false
    t.integer "anrede",                   limit: 1, null: false
    t.integer "vorname",                  limit: 1, null: false
    t.integer "name",                     limit: 1, null: false
    t.integer "strasse",                  limit: 1, null: false
    t.integer "plz",                      limit: 1, null: false
    t.integer "ort",                      limit: 1, null: false
    t.integer "email",                    limit: 1, null: false
    t.integer "eintritt",                 limit: 1, null: false
    t.integer "austritt_zum",             limit: 1, null: false
    t.integer "za",                       limit: 1, null: false
    t.integer "konto",                    limit: 1, null: false
    t.integer "blz",                      limit: 1, null: false
    t.integer "zahler",                   limit: 1, null: false
    t.integer "created_at",               limit: 1, null: false
    t.integer "update_at",                limit: 1, null: false
    t.integer "telefon",                  limit: 1, null: false
    t.integer "fax",                      limit: 1, null: false
    t.integer "bic",                      limit: 1, null: false
    t.integer "iban",                     limit: 1, null: false
    t.integer "country_code",             limit: 1, null: false
    t.integer "title",                    limit: 1, null: false
  end

  create_table "orchestra_contacts", force: :cascade do |t|
    t.integer  "orchestra_id_old", limit: 8
    t.string   "salutation",       limit: 255
    t.string   "first_name",       limit: 255
    t.string   "last_name",        limit: 255
    t.string   "street",           limit: 255
    t.string   "zip",              limit: 255
    t.string   "city",             limit: 255
    t.string   "role",             limit: 255
    t.string   "email",            limit: 255
    t.string   "phone",            limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "country_code",     limit: 255
    t.integer  "orchestra_id",     limit: 4
  end

  add_index "orchestra_contacts", ["orchestra_id_old"], name: "index_orchestra_contacts_on_orchestra_id_old", using: :btree

  create_table "orchestra_members", force: :cascade do |t|
    t.integer  "orchestra_id_old", limit: 4
    t.string   "first_name",       limit: 255
    t.string   "last_name",        limit: 255
    t.date     "date_of_birth"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "instrument",       limit: 255
    t.integer  "mglnr",            limit: 4
    t.integer  "orchestra_id",     limit: 4
  end

  add_index "orchestra_members", ["orchestra_id_old", "first_name", "last_name", "date_of_birth"], name: "orchestra_id", unique: true, using: :btree
  add_index "orchestra_members", ["orchestra_id_old"], name: "index_orchestra_members_on_orchestra_id_old", using: :btree

  create_table "orchestras", force: :cascade do |t|
    t.integer  "member_id_off",     limit: 8
    t.string   "orchName",          limit: 200
    t.string   "land",              limit: 510
    t.date     "gruendung"
    t.string   "orch_type",         limit: 1,   default: "O",   null: false
    t.string   "bemerkung",         limit: 510
    t.string   "url",               limit: 100
    t.boolean  "kuendigungErfasst"
    t.string   "zweitanschrift",    limit: 100
    t.string   "name2",             limit: 100
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.datetime "deleted_at"
    t.integer  "gema_kdnr",         limit: 4
    t.boolean  "publish_url",                   default: true
    t.boolean  "publish_address",               default: false
  end

  add_index "orchestras", ["deleted_at"], name: "index_orchestras_on_deleted_at", using: :btree

  create_table "orte", primary_key: "ID", force: :cascade do |t|
    t.string  "PLZ",         limit: 11, default: "-", null: false
    t.string  "Ort",         limit: 50, default: "-", null: false
    t.string  "Land",        limit: 3,  default: "-", null: false
    t.integer "fk_bland_id", limit: 8,                null: false
    t.string  "Vorwahl",     limit: 12, default: "-", null: false
    t.string  "Staat",       limit: 5,  default: "-", null: false
  end

  add_index "orte", ["Ort"], name: "Ort", using: :btree
  add_index "orte", ["PLZ"], name: "PLZ", using: :btree
  add_index "orte", ["Staat"], name: "Staat", using: :btree
  add_index "orte", ["Vorwahl"], name: "Vorwahl", using: :btree
  add_index "orte", ["fk_bland_id"], name: "fk_bland_id", using: :btree

  create_table "pages_language_overlay", primary_key: "uid", force: :cascade do |t|
    t.integer "pid",               limit: 4,        default: 0,  null: false
    t.integer "t3ver_oid",         limit: 4,        default: 0,  null: false
    t.integer "t3ver_id",          limit: 4,        default: 0,  null: false
    t.integer "t3ver_wsid",        limit: 4,        default: 0,  null: false
    t.string  "t3ver_label",       limit: 255,      default: ""
    t.integer "t3ver_state",       limit: 1,        default: 0,  null: false
    t.integer "t3ver_stage",       limit: 1,        default: 0,  null: false
    t.integer "t3ver_count",       limit: 4,        default: 0,  null: false
    t.integer "t3ver_tstamp",      limit: 4,        default: 0,  null: false
    t.integer "t3_origuid",        limit: 4,        default: 0,  null: false
    t.integer "tstamp",            limit: 4,        default: 0,  null: false
    t.integer "crdate",            limit: 4,        default: 0,  null: false
    t.integer "cruser_id",         limit: 4,        default: 0,  null: false
    t.integer "sys_language_uid",  limit: 4,        default: 0,  null: false
    t.string  "title",             limit: 255,      default: "", null: false
    t.integer "hidden",            limit: 1,        default: 0,  null: false
    t.integer "starttime",         limit: 4,        default: 0,  null: false
    t.integer "endtime",           limit: 4,        default: 0,  null: false
    t.integer "deleted",           limit: 1,        default: 0,  null: false
    t.string  "subtitle",          limit: 255,      default: "", null: false
    t.string  "nav_title",         limit: 255,      default: "", null: false
    t.text    "media",             limit: 255
    t.text    "keywords",          limit: 65535
    t.text    "description",       limit: 65535
    t.text    "abstract",          limit: 65535
    t.string  "author",            limit: 255,      default: "", null: false
    t.string  "author_email",      limit: 80,       default: "", null: false
    t.integer "tx_impexp_origuid", limit: 4,        default: 0,  null: false
    t.binary  "l18n_diffsource",   limit: 16777215
    t.integer "doktype",           limit: 1,        default: 0,  null: false
    t.string  "url",               limit: 255,      default: "", null: false
    t.integer "urltype",           limit: 1,        default: 0,  null: false
    t.integer "shortcut",          limit: 4,        default: 0,  null: false
    t.integer "shortcut_mode",     limit: 4,        default: 0,  null: false
  end

  add_index "pages_language_overlay", ["pid", "sys_language_uid"], name: "parent", using: :btree
  add_index "pages_language_overlay", ["t3ver_oid", "t3ver_wsid"], name: "t3ver_oid", using: :btree

  create_table "person_members", force: :cascade do |t|
    t.integer  "member_id_off",      limit: 8
    t.date     "geburtstag"
    t.string   "telefonDienstl",     limit: 60
    t.integer  "lv",                 limit: 8
    t.integer  "tariff_id",          limit: 8
    t.string   "bemerkung",          limit: 510
    t.integer  "zeitungen",          limit: 2
    t.date     "kuendigungVom"
    t.float    "beitrag",            limit: 53
    t.integer  "zusatzzeitung",      limit: 8,   default: 0, null: false
    t.boolean  "lastschriftErfasst"
    t.boolean  "rechnungsDruck"
    t.datetime "created_at",                                 null: false
    t.datetime "deleted_at"
  end

  add_index "person_members", ["deleted_at"], name: "index_person_members_on_deleted_at", using: :btree

  create_table "phpbb3_acl_groups", id: false, force: :cascade do |t|
    t.integer "group_id",       limit: 3, default: 0, null: false
    t.integer "forum_id",       limit: 3, default: 0, null: false
    t.integer "auth_option_id", limit: 3, default: 0, null: false
    t.integer "auth_role_id",   limit: 3, default: 0, null: false
    t.integer "auth_setting",   limit: 1, default: 0, null: false
  end

  add_index "phpbb3_acl_groups", ["auth_option_id"], name: "auth_opt_id", using: :btree
  add_index "phpbb3_acl_groups", ["auth_role_id"], name: "auth_role_id", using: :btree
  add_index "phpbb3_acl_groups", ["group_id"], name: "group_id", using: :btree

  create_table "phpbb3_acl_options", primary_key: "auth_option_id", force: :cascade do |t|
    t.string  "auth_option",  limit: 50, default: "",    null: false
    t.boolean "is_global",               default: false, null: false
    t.boolean "is_local",                default: false, null: false
    t.boolean "founder_only",            default: false, null: false
  end

  add_index "phpbb3_acl_options", ["auth_option"], name: "auth_option", unique: true, using: :btree

  create_table "phpbb3_acl_roles", primary_key: "role_id", force: :cascade do |t|
    t.string  "role_name",        limit: 255,   default: "", null: false
    t.text    "role_description", limit: 65535,              null: false
    t.string  "role_type",        limit: 10,    default: "", null: false
    t.integer "role_order",       limit: 2,     default: 0,  null: false
  end

  add_index "phpbb3_acl_roles", ["role_order"], name: "role_order", using: :btree
  add_index "phpbb3_acl_roles", ["role_type"], name: "role_type", using: :btree

  create_table "phpbb3_acl_roles_data", id: false, force: :cascade do |t|
    t.integer "role_id",        limit: 3, default: 0, null: false
    t.integer "auth_option_id", limit: 3, default: 0, null: false
    t.integer "auth_setting",   limit: 1, default: 0, null: false
  end

  add_index "phpbb3_acl_roles_data", ["auth_option_id"], name: "ath_op_id", using: :btree

  create_table "phpbb3_acl_users", id: false, force: :cascade do |t|
    t.integer "user_id",        limit: 3, default: 0, null: false
    t.integer "forum_id",       limit: 3, default: 0, null: false
    t.integer "auth_option_id", limit: 3, default: 0, null: false
    t.integer "auth_role_id",   limit: 3, default: 0, null: false
    t.integer "auth_setting",   limit: 1, default: 0, null: false
  end

  add_index "phpbb3_acl_users", ["auth_option_id"], name: "auth_option_id", using: :btree
  add_index "phpbb3_acl_users", ["auth_role_id"], name: "auth_role_id", using: :btree
  add_index "phpbb3_acl_users", ["user_id"], name: "user_id", using: :btree

  create_table "phpbb3_attachments", primary_key: "attach_id", force: :cascade do |t|
    t.integer "post_msg_id",       limit: 3,     default: 0,     null: false
    t.integer "topic_id",          limit: 3,     default: 0,     null: false
    t.boolean "in_message",                      default: false, null: false
    t.integer "poster_id",         limit: 3,     default: 0,     null: false
    t.boolean "is_orphan",                       default: true,  null: false
    t.string  "physical_filename", limit: 255,   default: "",    null: false
    t.string  "real_filename",     limit: 255,   default: "",    null: false
    t.integer "download_count",    limit: 3,     default: 0,     null: false
    t.text    "attach_comment",    limit: 65535,                 null: false
    t.string  "extension",         limit: 100,   default: "",    null: false
    t.string  "mimetype",          limit: 100,   default: "",    null: false
    t.integer "filesize",          limit: 4,     default: 0,     null: false
    t.integer "filetime",          limit: 4,     default: 0,     null: false
    t.boolean "thumbnail",                       default: false, null: false
  end

  add_index "phpbb3_attachments", ["filetime"], name: "filetime", using: :btree
  add_index "phpbb3_attachments", ["is_orphan"], name: "is_orphan", using: :btree
  add_index "phpbb3_attachments", ["post_msg_id"], name: "post_msg_id", using: :btree
  add_index "phpbb3_attachments", ["poster_id"], name: "poster_id", using: :btree
  add_index "phpbb3_attachments", ["topic_id"], name: "topic_id", using: :btree

  create_table "phpbb3_banlist", primary_key: "ban_id", force: :cascade do |t|
    t.integer "ban_userid",      limit: 3,   default: 0,     null: false
    t.string  "ban_ip",          limit: 40,  default: "",    null: false
    t.string  "ban_email",       limit: 100, default: "",    null: false
    t.integer "ban_start",       limit: 4,   default: 0,     null: false
    t.integer "ban_end",         limit: 4,   default: 0,     null: false
    t.boolean "ban_exclude",                 default: false, null: false
    t.string  "ban_reason",      limit: 255, default: "",    null: false
    t.string  "ban_give_reason", limit: 255, default: "",    null: false
  end

  add_index "phpbb3_banlist", ["ban_email", "ban_exclude"], name: "ban_email", using: :btree
  add_index "phpbb3_banlist", ["ban_end"], name: "ban_end", using: :btree
  add_index "phpbb3_banlist", ["ban_ip", "ban_exclude"], name: "ban_ip", using: :btree
  add_index "phpbb3_banlist", ["ban_userid", "ban_exclude"], name: "ban_user", using: :btree

  create_table "phpbb3_bbcodes", primary_key: "bbcode_id", force: :cascade do |t|
    t.string  "bbcode_tag",          limit: 16,       default: "",    null: false
    t.string  "bbcode_helpline",     limit: 255,      default: "",    null: false
    t.boolean "display_on_posting",                   default: false, null: false
    t.text    "bbcode_match",        limit: 65535,                    null: false
    t.text    "bbcode_tpl",          limit: 16777215,                 null: false
    t.text    "first_pass_match",    limit: 16777215,                 null: false
    t.text    "first_pass_replace",  limit: 16777215,                 null: false
    t.text    "second_pass_match",   limit: 16777215,                 null: false
    t.text    "second_pass_replace", limit: 16777215,                 null: false
  end

  add_index "phpbb3_bbcodes", ["display_on_posting"], name: "display_on_post", using: :btree

  create_table "phpbb3_bookmarks", id: false, force: :cascade do |t|
    t.integer "topic_id", limit: 3, default: 0, null: false
    t.integer "user_id",  limit: 3, default: 0, null: false
  end

  create_table "phpbb3_bots", primary_key: "bot_id", force: :cascade do |t|
    t.boolean "bot_active",             default: true, null: false
    t.string  "bot_name",   limit: 255, default: "",   null: false
    t.integer "user_id",    limit: 3,   default: 0,    null: false
    t.string  "bot_agent",  limit: 255, default: "",   null: false
    t.string  "bot_ip",     limit: 255, default: "",   null: false
  end

  add_index "phpbb3_bots", ["bot_active"], name: "bot_active", using: :btree

  create_table "phpbb3_captcha_answers", id: false, force: :cascade do |t|
    t.integer "question_id", limit: 3,   default: 0,  null: false
    t.string  "answer_text", limit: 255, default: "", null: false
  end

  add_index "phpbb3_captcha_answers", ["question_id"], name: "qid", using: :btree

  create_table "phpbb3_captcha_questions", primary_key: "question_id", force: :cascade do |t|
    t.boolean "strict",                      default: false, null: false
    t.integer "lang_id",       limit: 3,     default: 0,     null: false
    t.string  "lang_iso",      limit: 30,    default: "",    null: false
    t.text    "question_text", limit: 65535,                 null: false
  end

  add_index "phpbb3_captcha_questions", ["lang_iso"], name: "lang", using: :btree

  create_table "phpbb3_config", primary_key: "config_name", force: :cascade do |t|
    t.string  "config_value", limit: 255, default: "",    null: false
    t.boolean "is_dynamic",               default: false, null: false
  end

  add_index "phpbb3_config", ["is_dynamic"], name: "is_dynamic", using: :btree

  create_table "phpbb3_confirm", id: false, force: :cascade do |t|
    t.string  "confirm_id",   limit: 32, default: "", null: false
    t.string  "session_id",   limit: 32, default: "", null: false
    t.integer "confirm_type", limit: 1,  default: 0,  null: false
    t.string  "code",         limit: 8,  default: "", null: false
    t.integer "seed",         limit: 4,  default: 0,  null: false
    t.integer "attempts",     limit: 3,  default: 0,  null: false
  end

  add_index "phpbb3_confirm", ["confirm_type"], name: "confirm_type", using: :btree

  create_table "phpbb3_disallow", primary_key: "disallow_id", force: :cascade do |t|
    t.string "disallow_username", limit: 255, default: "", null: false
  end

  create_table "phpbb3_drafts", primary_key: "draft_id", force: :cascade do |t|
    t.integer "user_id",       limit: 3,        default: 0,  null: false
    t.integer "topic_id",      limit: 3,        default: 0,  null: false
    t.integer "forum_id",      limit: 3,        default: 0,  null: false
    t.integer "save_time",     limit: 4,        default: 0,  null: false
    t.string  "draft_subject", limit: 255,      default: "", null: false
    t.text    "draft_message", limit: 16777215,              null: false
  end

  add_index "phpbb3_drafts", ["save_time"], name: "save_time", using: :btree

  create_table "phpbb3_extension_groups", primary_key: "group_id", force: :cascade do |t|
    t.string  "group_name",     limit: 255,   default: "",    null: false
    t.integer "cat_id",         limit: 1,     default: 0,     null: false
    t.boolean "allow_group",                  default: false, null: false
    t.boolean "download_mode",                default: true,  null: false
    t.string  "upload_icon",    limit: 255,   default: "",    null: false
    t.integer "max_filesize",   limit: 4,     default: 0,     null: false
    t.text    "allowed_forums", limit: 65535,                 null: false
    t.boolean "allow_in_pm",                  default: false, null: false
  end

  create_table "phpbb3_extensions", primary_key: "extension_id", force: :cascade do |t|
    t.integer "group_id",  limit: 3,   default: 0,  null: false
    t.string  "extension", limit: 100, default: "", null: false
  end

  create_table "phpbb3_forums", primary_key: "forum_id", force: :cascade do |t|
    t.integer "parent_id",                limit: 3,        default: 0,     null: false
    t.integer "left_id",                  limit: 3,        default: 0,     null: false
    t.integer "right_id",                 limit: 3,        default: 0,     null: false
    t.text    "forum_parents",            limit: 16777215,                 null: false
    t.string  "forum_name",               limit: 255,      default: "",    null: false
    t.text    "forum_desc",               limit: 65535,                    null: false
    t.string  "forum_desc_bitfield",      limit: 255,      default: "",    null: false
    t.integer "forum_desc_options",       limit: 4,        default: 7,     null: false
    t.string  "forum_desc_uid",           limit: 8,        default: "",    null: false
    t.string  "forum_link",               limit: 255,      default: "",    null: false
    t.string  "forum_password",           limit: 40,       default: "",    null: false
    t.integer "forum_style",              limit: 3,        default: 0,     null: false
    t.string  "forum_image",              limit: 255,      default: "",    null: false
    t.text    "forum_rules",              limit: 65535,                    null: false
    t.string  "forum_rules_link",         limit: 255,      default: "",    null: false
    t.string  "forum_rules_bitfield",     limit: 255,      default: "",    null: false
    t.integer "forum_rules_options",      limit: 4,        default: 7,     null: false
    t.string  "forum_rules_uid",          limit: 8,        default: "",    null: false
    t.integer "forum_topics_per_page",    limit: 1,        default: 0,     null: false
    t.integer "forum_type",               limit: 1,        default: 0,     null: false
    t.integer "forum_status",             limit: 1,        default: 0,     null: false
    t.integer "forum_posts",              limit: 3,        default: 0,     null: false
    t.integer "forum_topics",             limit: 3,        default: 0,     null: false
    t.integer "forum_topics_real",        limit: 3,        default: 0,     null: false
    t.integer "forum_last_post_id",       limit: 3,        default: 0,     null: false
    t.integer "forum_last_poster_id",     limit: 3,        default: 0,     null: false
    t.string  "forum_last_post_subject",  limit: 255,      default: "",    null: false
    t.integer "forum_last_post_time",     limit: 4,        default: 0,     null: false
    t.string  "forum_last_poster_name",   limit: 255,      default: "",    null: false
    t.string  "forum_last_poster_colour", limit: 6,        default: "",    null: false
    t.integer "forum_flags",              limit: 1,        default: 32,    null: false
    t.boolean "display_on_index",                          default: true,  null: false
    t.boolean "enable_indexing",                           default: true,  null: false
    t.boolean "enable_icons",                              default: true,  null: false
    t.boolean "enable_prune",                              default: false, null: false
    t.integer "prune_next",               limit: 4,        default: 0,     null: false
    t.integer "prune_days",               limit: 3,        default: 0,     null: false
    t.integer "prune_viewed",             limit: 3,        default: 0,     null: false
    t.integer "prune_freq",               limit: 3,        default: 0,     null: false
    t.boolean "display_subforum_list",                     default: true,  null: false
    t.integer "forum_options",            limit: 4,        default: 0,     null: false
  end

  add_index "phpbb3_forums", ["forum_last_post_id"], name: "forum_lastpost_id", using: :btree
  add_index "phpbb3_forums", ["left_id", "right_id"], name: "left_right_id", using: :btree

  create_table "phpbb3_forums_access", id: false, force: :cascade do |t|
    t.integer "forum_id",   limit: 3,  default: 0,  null: false
    t.integer "user_id",    limit: 3,  default: 0,  null: false
    t.string  "session_id", limit: 32, default: "", null: false
  end

  create_table "phpbb3_forums_track", id: false, force: :cascade do |t|
    t.integer "user_id",   limit: 3, default: 0, null: false
    t.integer "forum_id",  limit: 3, default: 0, null: false
    t.integer "mark_time", limit: 4, default: 0, null: false
  end

  create_table "phpbb3_forums_watch", id: false, force: :cascade do |t|
    t.integer "forum_id",      limit: 3, default: 0,     null: false
    t.integer "user_id",       limit: 3, default: 0,     null: false
    t.boolean "notify_status",           default: false, null: false
  end

  add_index "phpbb3_forums_watch", ["forum_id"], name: "forum_id", using: :btree
  add_index "phpbb3_forums_watch", ["notify_status"], name: "notify_stat", using: :btree
  add_index "phpbb3_forums_watch", ["user_id"], name: "user_id", using: :btree

  create_table "phpbb3_groups", primary_key: "group_id", force: :cascade do |t|
    t.integer "group_type",           limit: 1,     default: 1,     null: false
    t.boolean "group_founder_manage",               default: false, null: false
    t.string  "group_name",           limit: 255,   default: "",    null: false
    t.text    "group_desc",           limit: 65535,                 null: false
    t.string  "group_desc_bitfield",  limit: 255,   default: "",    null: false
    t.integer "group_desc_options",   limit: 4,     default: 7,     null: false
    t.string  "group_desc_uid",       limit: 8,     default: "",    null: false
    t.boolean "group_display",                      default: false, null: false
    t.string  "group_avatar",         limit: 255,   default: "",    null: false
    t.integer "group_avatar_type",    limit: 1,     default: 0,     null: false
    t.integer "group_avatar_width",   limit: 2,     default: 0,     null: false
    t.integer "group_avatar_height",  limit: 2,     default: 0,     null: false
    t.integer "group_rank",           limit: 3,     default: 0,     null: false
    t.string  "group_colour",         limit: 6,     default: "",    null: false
    t.integer "group_sig_chars",      limit: 3,     default: 0,     null: false
    t.boolean "group_receive_pm",                   default: false, null: false
    t.integer "group_message_limit",  limit: 3,     default: 0,     null: false
    t.boolean "group_legend",                       default: true,  null: false
    t.integer "group_max_recipients", limit: 3,     default: 0,     null: false
    t.boolean "group_skip_auth",                    default: false, null: false
    t.boolean "group_prune_exclude",                default: false, null: false
  end

  add_index "phpbb3_groups", ["group_legend", "group_name"], name: "group_legend_name", using: :btree

  create_table "phpbb3_icons", primary_key: "icons_id", force: :cascade do |t|
    t.string  "icons_url",          limit: 255, default: "",   null: false
    t.integer "icons_width",        limit: 1,   default: 0,    null: false
    t.integer "icons_height",       limit: 1,   default: 0,    null: false
    t.integer "icons_order",        limit: 3,   default: 0,    null: false
    t.boolean "display_on_posting",             default: true, null: false
  end

  add_index "phpbb3_icons", ["display_on_posting"], name: "display_on_posting", using: :btree

  create_table "phpbb3_lang", primary_key: "lang_id", force: :cascade do |t|
    t.string "lang_iso",          limit: 30,  default: "", null: false
    t.string "lang_dir",          limit: 30,  default: "", null: false
    t.string "lang_english_name", limit: 100, default: "", null: false
    t.string "lang_local_name",   limit: 255, default: "", null: false
    t.string "lang_author",       limit: 255, default: "", null: false
  end

  add_index "phpbb3_lang", ["lang_iso"], name: "lang_iso", using: :btree

  create_table "phpbb3_log", primary_key: "log_id", force: :cascade do |t|
    t.integer "log_type",      limit: 1,        default: 0,  null: false
    t.integer "user_id",       limit: 3,        default: 0,  null: false
    t.integer "forum_id",      limit: 3,        default: 0,  null: false
    t.integer "topic_id",      limit: 3,        default: 0,  null: false
    t.integer "reportee_id",   limit: 3,        default: 0,  null: false
    t.string  "log_ip",        limit: 40,       default: "", null: false
    t.integer "log_time",      limit: 4,        default: 0,  null: false
    t.text    "log_operation", limit: 65535,                 null: false
    t.text    "log_data",      limit: 16777215,              null: false
  end

  add_index "phpbb3_log", ["forum_id"], name: "forum_id", using: :btree
  add_index "phpbb3_log", ["log_type"], name: "log_type", using: :btree
  add_index "phpbb3_log", ["reportee_id"], name: "reportee_id", using: :btree
  add_index "phpbb3_log", ["topic_id"], name: "topic_id", using: :btree
  add_index "phpbb3_log", ["user_id"], name: "user_id", using: :btree

  create_table "phpbb3_login_attempts", id: false, force: :cascade do |t|
    t.string  "attempt_ip",            limit: 40,  default: "",  null: false
    t.string  "attempt_browser",       limit: 150, default: "",  null: false
    t.string  "attempt_forwarded_for", limit: 255, default: "",  null: false
    t.integer "attempt_time",          limit: 4,   default: 0,   null: false
    t.integer "user_id",               limit: 3,   default: 0,   null: false
    t.string  "username",              limit: 255, default: "0", null: false
    t.string  "username_clean",        limit: 255, default: "0", null: false
  end

  add_index "phpbb3_login_attempts", ["attempt_forwarded_for", "attempt_time"], name: "att_for", using: :btree
  add_index "phpbb3_login_attempts", ["attempt_ip", "attempt_time"], name: "att_ip", using: :btree
  add_index "phpbb3_login_attempts", ["attempt_time"], name: "att_time", using: :btree
  add_index "phpbb3_login_attempts", ["user_id"], name: "user_id", using: :btree

  create_table "phpbb3_moderator_cache", id: false, force: :cascade do |t|
    t.integer "forum_id",         limit: 3,   default: 0,    null: false
    t.integer "user_id",          limit: 3,   default: 0,    null: false
    t.string  "username",         limit: 255, default: "",   null: false
    t.integer "group_id",         limit: 3,   default: 0,    null: false
    t.string  "group_name",       limit: 255, default: "",   null: false
    t.boolean "display_on_index",             default: true, null: false
  end

  add_index "phpbb3_moderator_cache", ["display_on_index"], name: "disp_idx", using: :btree
  add_index "phpbb3_moderator_cache", ["forum_id"], name: "forum_id", using: :btree

  create_table "phpbb3_mods", primary_key: "mod_id", force: :cascade do |t|
    t.boolean "mod_active",                        default: false, null: false
    t.integer "mod_time",         limit: 4,        default: 0,     null: false
    t.text    "mod_dependencies", limit: 16777215,                 null: false
    t.text    "mod_name",         limit: 65535,                    null: false
    t.text    "mod_description",  limit: 65535,                    null: false
    t.string  "mod_version",      limit: 25,       default: "",    null: false
    t.text    "mod_author_notes", limit: 65535,                    null: false
    t.string  "mod_author_name",  limit: 100,      default: "",    null: false
    t.string  "mod_author_email", limit: 100,      default: "",    null: false
    t.string  "mod_author_url",   limit: 100,      default: "",    null: false
    t.text    "mod_actions",      limit: 16777215,                 null: false
    t.string  "mod_languages",    limit: 255,      default: "",    null: false
    t.string  "mod_template",     limit: 255,      default: "",    null: false
    t.string  "mod_path",         limit: 255,      default: "",    null: false
    t.string  "mod_contribs",     limit: 255,      default: "",    null: false
  end

  create_table "phpbb3_modules", primary_key: "module_id", force: :cascade do |t|
    t.boolean "module_enabled",              default: true, null: false
    t.boolean "module_display",              default: true, null: false
    t.string  "module_basename", limit: 255, default: "",   null: false
    t.string  "module_class",    limit: 10,  default: "",   null: false
    t.integer "parent_id",       limit: 3,   default: 0,    null: false
    t.integer "left_id",         limit: 3,   default: 0,    null: false
    t.integer "right_id",        limit: 3,   default: 0,    null: false
    t.string  "module_langname", limit: 255, default: "",   null: false
    t.string  "module_mode",     limit: 255, default: "",   null: false
    t.string  "module_auth",     limit: 255, default: "",   null: false
  end

  add_index "phpbb3_modules", ["left_id", "right_id"], name: "left_right_id", using: :btree
  add_index "phpbb3_modules", ["module_class", "left_id"], name: "class_left_id", using: :btree
  add_index "phpbb3_modules", ["module_enabled"], name: "module_enabled", using: :btree

  create_table "phpbb3_poll_options", id: false, force: :cascade do |t|
    t.integer "poll_option_id",    limit: 1,     default: 0, null: false
    t.integer "topic_id",          limit: 3,     default: 0, null: false
    t.text    "poll_option_text",  limit: 65535,             null: false
    t.integer "poll_option_total", limit: 3,     default: 0, null: false
  end

  add_index "phpbb3_poll_options", ["poll_option_id"], name: "poll_opt_id", using: :btree
  add_index "phpbb3_poll_options", ["topic_id"], name: "topic_id", using: :btree

  create_table "phpbb3_poll_votes", id: false, force: :cascade do |t|
    t.integer "topic_id",       limit: 3,  default: 0,  null: false
    t.integer "poll_option_id", limit: 1,  default: 0,  null: false
    t.integer "vote_user_id",   limit: 3,  default: 0,  null: false
    t.string  "vote_user_ip",   limit: 40, default: "", null: false
  end

  add_index "phpbb3_poll_votes", ["topic_id"], name: "topic_id", using: :btree
  add_index "phpbb3_poll_votes", ["vote_user_id"], name: "vote_user_id", using: :btree
  add_index "phpbb3_poll_votes", ["vote_user_ip"], name: "vote_user_ip", using: :btree

  create_table "phpbb3_posts", primary_key: "post_id", force: :cascade do |t|
    t.integer "topic_id",         limit: 3,        default: 0,     null: false
    t.integer "forum_id",         limit: 3,        default: 0,     null: false
    t.integer "poster_id",        limit: 3,        default: 0,     null: false
    t.integer "icon_id",          limit: 3,        default: 0,     null: false
    t.string  "poster_ip",        limit: 40,       default: "",    null: false
    t.integer "post_time",        limit: 4,        default: 0,     null: false
    t.boolean "post_approved",                     default: true,  null: false
    t.boolean "post_reported",                     default: false, null: false
    t.boolean "enable_bbcode",                     default: true,  null: false
    t.boolean "enable_smilies",                    default: true,  null: false
    t.boolean "enable_magic_url",                  default: true,  null: false
    t.boolean "enable_sig",                        default: true,  null: false
    t.string  "post_username",    limit: 255,      default: "",    null: false
    t.string  "post_subject",     limit: 255,      default: "",    null: false
    t.text    "post_text",        limit: 16777215,                 null: false
    t.string  "post_checksum",    limit: 32,       default: "",    null: false
    t.boolean "post_attachment",                   default: false, null: false
    t.string  "bbcode_bitfield",  limit: 255,      default: "",    null: false
    t.string  "bbcode_uid",       limit: 8,        default: "",    null: false
    t.boolean "post_postcount",                    default: true,  null: false
    t.integer "post_edit_time",   limit: 4,        default: 0,     null: false
    t.string  "post_edit_reason", limit: 255,      default: "",    null: false
    t.integer "post_edit_user",   limit: 3,        default: 0,     null: false
    t.integer "post_edit_count",  limit: 2,        default: 0,     null: false
    t.boolean "post_edit_locked",                  default: false, null: false
  end

  add_index "phpbb3_posts", ["forum_id"], name: "forum_id", using: :btree
  add_index "phpbb3_posts", ["post_approved"], name: "post_approved", using: :btree
  add_index "phpbb3_posts", ["post_subject", "post_text"], name: "post_content", type: :fulltext
  add_index "phpbb3_posts", ["post_subject"], name: "post_subject", type: :fulltext
  add_index "phpbb3_posts", ["post_text"], name: "post_text", type: :fulltext
  add_index "phpbb3_posts", ["post_username"], name: "post_username", using: :btree
  add_index "phpbb3_posts", ["poster_id"], name: "poster_id", using: :btree
  add_index "phpbb3_posts", ["poster_ip"], name: "poster_ip", using: :btree
  add_index "phpbb3_posts", ["topic_id", "post_time"], name: "tid_post_time", using: :btree
  add_index "phpbb3_posts", ["topic_id"], name: "topic_id", using: :btree

  create_table "phpbb3_privmsgs", primary_key: "msg_id", force: :cascade do |t|
    t.integer "root_level",          limit: 3,        default: 0,     null: false
    t.integer "author_id",           limit: 3,        default: 0,     null: false
    t.integer "icon_id",             limit: 3,        default: 0,     null: false
    t.string  "author_ip",           limit: 40,       default: "",    null: false
    t.integer "message_time",        limit: 4,        default: 0,     null: false
    t.boolean "enable_bbcode",                        default: true,  null: false
    t.boolean "enable_smilies",                       default: true,  null: false
    t.boolean "enable_magic_url",                     default: true,  null: false
    t.boolean "enable_sig",                           default: true,  null: false
    t.string  "message_subject",     limit: 255,      default: "",    null: false
    t.text    "message_text",        limit: 16777215,                 null: false
    t.string  "message_edit_reason", limit: 255,      default: "",    null: false
    t.integer "message_edit_user",   limit: 3,        default: 0,     null: false
    t.boolean "message_attachment",                   default: false, null: false
    t.string  "bbcode_bitfield",     limit: 255,      default: "",    null: false
    t.string  "bbcode_uid",          limit: 8,        default: "",    null: false
    t.integer "message_edit_time",   limit: 4,        default: 0,     null: false
    t.integer "message_edit_count",  limit: 2,        default: 0,     null: false
    t.text    "to_address",          limit: 65535,                    null: false
    t.text    "bcc_address",         limit: 65535,                    null: false
    t.boolean "message_reported",                     default: false, null: false
  end

  add_index "phpbb3_privmsgs", ["author_id"], name: "author_id", using: :btree
  add_index "phpbb3_privmsgs", ["author_ip"], name: "author_ip", using: :btree
  add_index "phpbb3_privmsgs", ["message_time"], name: "message_time", using: :btree
  add_index "phpbb3_privmsgs", ["root_level"], name: "root_level", using: :btree

  create_table "phpbb3_privmsgs_folder", primary_key: "folder_id", force: :cascade do |t|
    t.integer "user_id",     limit: 3,   default: 0,  null: false
    t.string  "folder_name", limit: 255, default: "", null: false
    t.integer "pm_count",    limit: 3,   default: 0,  null: false
  end

  add_index "phpbb3_privmsgs_folder", ["user_id"], name: "user_id", using: :btree

  create_table "phpbb3_privmsgs_rules", primary_key: "rule_id", force: :cascade do |t|
    t.integer "user_id",         limit: 3,   default: 0,  null: false
    t.integer "rule_check",      limit: 3,   default: 0,  null: false
    t.integer "rule_connection", limit: 3,   default: 0,  null: false
    t.string  "rule_string",     limit: 255, default: "", null: false
    t.integer "rule_user_id",    limit: 3,   default: 0,  null: false
    t.integer "rule_group_id",   limit: 3,   default: 0,  null: false
    t.integer "rule_action",     limit: 3,   default: 0,  null: false
    t.integer "rule_folder_id",  limit: 4,   default: 0,  null: false
  end

  add_index "phpbb3_privmsgs_rules", ["user_id"], name: "user_id", using: :btree

  create_table "phpbb3_privmsgs_to", id: false, force: :cascade do |t|
    t.integer "msg_id",       limit: 3, default: 0,     null: false
    t.integer "user_id",      limit: 3, default: 0,     null: false
    t.integer "author_id",    limit: 3, default: 0,     null: false
    t.boolean "pm_deleted",             default: false, null: false
    t.boolean "pm_new",                 default: true,  null: false
    t.boolean "pm_unread",              default: true,  null: false
    t.boolean "pm_replied",             default: false, null: false
    t.boolean "pm_marked",              default: false, null: false
    t.boolean "pm_forwarded",           default: false, null: false
    t.integer "folder_id",    limit: 4, default: 0,     null: false
  end

  add_index "phpbb3_privmsgs_to", ["author_id"], name: "author_id", using: :btree
  add_index "phpbb3_privmsgs_to", ["msg_id"], name: "msg_id", using: :btree
  add_index "phpbb3_privmsgs_to", ["user_id", "folder_id"], name: "usr_flder_id", using: :btree

  create_table "phpbb3_profile_fields", primary_key: "field_id", force: :cascade do |t|
    t.string  "field_name",          limit: 255, default: "",    null: false
    t.integer "field_type",          limit: 1,   default: 0,     null: false
    t.string  "field_ident",         limit: 20,  default: "",    null: false
    t.string  "field_length",        limit: 20,  default: "",    null: false
    t.string  "field_minlen",        limit: 255, default: "",    null: false
    t.string  "field_maxlen",        limit: 255, default: "",    null: false
    t.string  "field_novalue",       limit: 255, default: "",    null: false
    t.string  "field_default_value", limit: 255, default: "",    null: false
    t.string  "field_validation",    limit: 20,  default: "",    null: false
    t.boolean "field_required",                  default: false, null: false
    t.boolean "field_show_on_reg",               default: false, null: false
    t.boolean "field_hide",                      default: false, null: false
    t.boolean "field_no_view",                   default: false, null: false
    t.boolean "field_active",                    default: false, null: false
    t.integer "field_order",         limit: 3,   default: 0,     null: false
    t.boolean "field_show_profile",              default: false, null: false
    t.boolean "field_show_on_vt",                default: false, null: false
    t.boolean "field_show_novalue",              default: false, null: false
  end

  add_index "phpbb3_profile_fields", ["field_order"], name: "fld_ordr", using: :btree
  add_index "phpbb3_profile_fields", ["field_type"], name: "fld_type", using: :btree

  create_table "phpbb3_profile_fields_data", primary_key: "user_id", force: :cascade do |t|
  end

  create_table "phpbb3_profile_fields_lang", id: false, force: :cascade do |t|
    t.integer "field_id",   limit: 3,   default: 0,  null: false
    t.integer "lang_id",    limit: 3,   default: 0,  null: false
    t.integer "option_id",  limit: 3,   default: 0,  null: false
    t.integer "field_type", limit: 1,   default: 0,  null: false
    t.string  "lang_value", limit: 255, default: "", null: false
  end

  create_table "phpbb3_profile_lang", id: false, force: :cascade do |t|
    t.integer "field_id",           limit: 3,     default: 0,  null: false
    t.integer "lang_id",            limit: 3,     default: 0,  null: false
    t.string  "lang_name",          limit: 255,   default: "", null: false
    t.text    "lang_explain",       limit: 65535,              null: false
    t.string  "lang_default_value", limit: 255,   default: "", null: false
  end

  create_table "phpbb3_qa_confirm", primary_key: "confirm_id", force: :cascade do |t|
    t.string  "session_id",   limit: 32, default: "", null: false
    t.string  "lang_iso",     limit: 30, default: "", null: false
    t.integer "question_id",  limit: 3,  default: 0,  null: false
    t.integer "attempts",     limit: 3,  default: 0,  null: false
    t.integer "confirm_type", limit: 2,  default: 0,  null: false
  end

  add_index "phpbb3_qa_confirm", ["confirm_id", "session_id", "lang_iso"], name: "lookup", using: :btree
  add_index "phpbb3_qa_confirm", ["session_id"], name: "session_id", using: :btree

  create_table "phpbb3_ranks", primary_key: "rank_id", force: :cascade do |t|
    t.string  "rank_title",   limit: 255, default: "",    null: false
    t.integer "rank_min",     limit: 3,   default: 0,     null: false
    t.boolean "rank_special",             default: false, null: false
    t.string  "rank_image",   limit: 255, default: "",    null: false
  end

  create_table "phpbb3_reports", primary_key: "report_id", force: :cascade do |t|
    t.integer "reason_id",     limit: 2,        default: 0,     null: false
    t.integer "post_id",       limit: 3,        default: 0,     null: false
    t.integer "user_id",       limit: 3,        default: 0,     null: false
    t.boolean "user_notify",                    default: false, null: false
    t.boolean "report_closed",                  default: false, null: false
    t.integer "report_time",   limit: 4,        default: 0,     null: false
    t.text    "report_text",   limit: 16777215,                 null: false
    t.integer "pm_id",         limit: 3,        default: 0,     null: false
  end

  add_index "phpbb3_reports", ["pm_id"], name: "pm_id", using: :btree
  add_index "phpbb3_reports", ["post_id"], name: "post_id", using: :btree

  create_table "phpbb3_reports_reasons", primary_key: "reason_id", force: :cascade do |t|
    t.string  "reason_title",       limit: 255,      default: "", null: false
    t.text    "reason_description", limit: 16777215,              null: false
    t.integer "reason_order",       limit: 2,        default: 0,  null: false
  end

  create_table "phpbb3_search_results", primary_key: "search_key", force: :cascade do |t|
    t.integer "search_time",     limit: 4,        default: 0, null: false
    t.text    "search_keywords", limit: 16777215,             null: false
    t.text    "search_authors",  limit: 16777215,             null: false
  end

  create_table "phpbb3_search_wordlist", primary_key: "word_id", force: :cascade do |t|
    t.string  "word_text",   limit: 255, default: "",    null: false
    t.boolean "word_common",             default: false, null: false
    t.integer "word_count",  limit: 3,   default: 0,     null: false
  end

  add_index "phpbb3_search_wordlist", ["word_count"], name: "wrd_cnt", using: :btree
  add_index "phpbb3_search_wordlist", ["word_text"], name: "wrd_txt", unique: true, using: :btree

  create_table "phpbb3_search_wordmatch", id: false, force: :cascade do |t|
    t.integer "post_id",     limit: 3, default: 0,     null: false
    t.integer "word_id",     limit: 3, default: 0,     null: false
    t.boolean "title_match",           default: false, null: false
  end

  add_index "phpbb3_search_wordmatch", ["post_id"], name: "post_id", using: :btree
  add_index "phpbb3_search_wordmatch", ["word_id", "post_id", "title_match"], name: "unq_mtch", unique: true, using: :btree
  add_index "phpbb3_search_wordmatch", ["word_id"], name: "word_id", using: :btree

  create_table "phpbb3_sessions", primary_key: "session_id", force: :cascade do |t|
    t.integer "session_user_id",       limit: 3,   default: 0,     null: false
    t.integer "session_last_visit",    limit: 4,   default: 0,     null: false
    t.integer "session_start",         limit: 4,   default: 0,     null: false
    t.integer "session_time",          limit: 4,   default: 0,     null: false
    t.string  "session_ip",            limit: 40,  default: "",    null: false
    t.string  "session_browser",       limit: 150, default: "",    null: false
    t.string  "session_forwarded_for", limit: 255, default: "",    null: false
    t.string  "session_page",          limit: 255, default: "",    null: false
    t.boolean "session_viewonline",                default: true,  null: false
    t.boolean "session_autologin",                 default: false, null: false
    t.boolean "session_admin",                     default: false, null: false
    t.integer "session_forum_id",      limit: 3,   default: 0,     null: false
  end

  add_index "phpbb3_sessions", ["session_forum_id"], name: "session_fid", using: :btree
  add_index "phpbb3_sessions", ["session_time"], name: "session_time", using: :btree
  add_index "phpbb3_sessions", ["session_user_id"], name: "session_user_id", using: :btree

  create_table "phpbb3_sessions_keys", id: false, force: :cascade do |t|
    t.string  "key_id",     limit: 32, default: "", null: false
    t.integer "user_id",    limit: 3,  default: 0,  null: false
    t.string  "last_ip",    limit: 40, default: "", null: false
    t.integer "last_login", limit: 4,  default: 0,  null: false
  end

  add_index "phpbb3_sessions_keys", ["last_login"], name: "last_login", using: :btree

  create_table "phpbb3_sitelist", primary_key: "site_id", force: :cascade do |t|
    t.string  "site_ip",       limit: 40,  default: "",    null: false
    t.string  "site_hostname", limit: 255, default: "",    null: false
    t.boolean "ip_exclude",                default: false, null: false
  end

  create_table "phpbb3_smilies", primary_key: "smiley_id", force: :cascade do |t|
    t.string  "code",               limit: 50, default: "",   null: false
    t.string  "emotion",            limit: 50, default: "",   null: false
    t.string  "smiley_url",         limit: 50, default: "",   null: false
    t.integer "smiley_width",       limit: 2,  default: 0,    null: false
    t.integer "smiley_height",      limit: 2,  default: 0,    null: false
    t.integer "smiley_order",       limit: 3,  default: 0,    null: false
    t.boolean "display_on_posting",            default: true, null: false
  end

  add_index "phpbb3_smilies", ["display_on_posting"], name: "display_on_post", using: :btree

  create_table "phpbb3_styles", primary_key: "style_id", force: :cascade do |t|
    t.string  "style_name",      limit: 255, default: "",   null: false
    t.string  "style_copyright", limit: 255, default: "",   null: false
    t.boolean "style_active",                default: true, null: false
    t.integer "template_id",     limit: 3,   default: 0,    null: false
    t.integer "theme_id",        limit: 3,   default: 0,    null: false
    t.integer "imageset_id",     limit: 3,   default: 0,    null: false
  end

  add_index "phpbb3_styles", ["imageset_id"], name: "imageset_id", using: :btree
  add_index "phpbb3_styles", ["style_name"], name: "style_name", unique: true, using: :btree
  add_index "phpbb3_styles", ["template_id"], name: "template_id", using: :btree
  add_index "phpbb3_styles", ["theme_id"], name: "theme_id", using: :btree

  create_table "phpbb3_styles_imageset", primary_key: "imageset_id", force: :cascade do |t|
    t.string "imageset_name",      limit: 255, default: "", null: false
    t.string "imageset_copyright", limit: 255, default: "", null: false
    t.string "imageset_path",      limit: 100, default: "", null: false
  end

  add_index "phpbb3_styles_imageset", ["imageset_name"], name: "imgset_nm", unique: true, using: :btree

  create_table "phpbb3_styles_imageset_data", primary_key: "image_id", force: :cascade do |t|
    t.string  "image_name",     limit: 200, default: "", null: false
    t.string  "image_filename", limit: 200, default: "", null: false
    t.string  "image_lang",     limit: 30,  default: "", null: false
    t.integer "image_height",   limit: 2,   default: 0,  null: false
    t.integer "image_width",    limit: 2,   default: 0,  null: false
    t.integer "imageset_id",    limit: 3,   default: 0,  null: false
  end

  add_index "phpbb3_styles_imageset_data", ["imageset_id"], name: "i_d", using: :btree

  create_table "phpbb3_styles_template", primary_key: "template_id", force: :cascade do |t|
    t.string  "template_name",         limit: 255, default: "",     null: false
    t.string  "template_copyright",    limit: 255, default: "",     null: false
    t.string  "template_path",         limit: 100, default: "",     null: false
    t.string  "bbcode_bitfield",       limit: 255, default: "kNg=", null: false
    t.boolean "template_storedb",                  default: false,  null: false
    t.integer "template_inherits_id",  limit: 4,   default: 0,      null: false
    t.string  "template_inherit_path", limit: 255, default: "",     null: false
  end

  add_index "phpbb3_styles_template", ["template_name"], name: "tmplte_nm", unique: true, using: :btree

  create_table "phpbb3_styles_template_data", id: false, force: :cascade do |t|
    t.integer "template_id",       limit: 3,        default: 0,  null: false
    t.string  "template_filename", limit: 100,      default: "", null: false
    t.text    "template_included", limit: 65535,                 null: false
    t.integer "template_mtime",    limit: 4,        default: 0,  null: false
    t.text    "template_data",     limit: 16777215,              null: false
  end

  add_index "phpbb3_styles_template_data", ["template_filename"], name: "tfn", using: :btree
  add_index "phpbb3_styles_template_data", ["template_id"], name: "tid", using: :btree

  create_table "phpbb3_styles_theme", primary_key: "theme_id", force: :cascade do |t|
    t.string  "theme_name",      limit: 255,      default: "",    null: false
    t.string  "theme_copyright", limit: 255,      default: "",    null: false
    t.string  "theme_path",      limit: 100,      default: "",    null: false
    t.boolean "theme_storedb",                    default: false, null: false
    t.integer "theme_mtime",     limit: 4,        default: 0,     null: false
    t.text    "theme_data",      limit: 16777215,                 null: false
  end

  add_index "phpbb3_styles_theme", ["theme_name"], name: "theme_name", unique: true, using: :btree

  create_table "phpbb3_topics", primary_key: "topic_id", force: :cascade do |t|
    t.integer "forum_id",                  limit: 3,   default: 0,     null: false
    t.integer "icon_id",                   limit: 3,   default: 0,     null: false
    t.boolean "topic_attachment",                      default: false, null: false
    t.boolean "topic_approved",                        default: true,  null: false
    t.boolean "topic_reported",                        default: false, null: false
    t.string  "topic_title",               limit: 255, default: "",    null: false
    t.integer "topic_poster",              limit: 3,   default: 0,     null: false
    t.integer "topic_time",                limit: 4,   default: 0,     null: false
    t.integer "topic_time_limit",          limit: 4,   default: 0,     null: false
    t.integer "topic_views",               limit: 3,   default: 0,     null: false
    t.integer "topic_replies",             limit: 3,   default: 0,     null: false
    t.integer "topic_replies_real",        limit: 3,   default: 0,     null: false
    t.integer "topic_status",              limit: 1,   default: 0,     null: false
    t.integer "topic_type",                limit: 1,   default: 0,     null: false
    t.integer "topic_first_post_id",       limit: 3,   default: 0,     null: false
    t.string  "topic_first_poster_name",   limit: 255, default: "",    null: false
    t.string  "topic_first_poster_colour", limit: 6,   default: "",    null: false
    t.integer "topic_last_post_id",        limit: 3,   default: 0,     null: false
    t.integer "topic_last_poster_id",      limit: 3,   default: 0,     null: false
    t.string  "topic_last_poster_name",    limit: 255, default: "",    null: false
    t.string  "topic_last_poster_colour",  limit: 6,   default: "",    null: false
    t.string  "topic_last_post_subject",   limit: 255, default: "",    null: false
    t.integer "topic_last_post_time",      limit: 4,   default: 0,     null: false
    t.integer "topic_last_view_time",      limit: 4,   default: 0,     null: false
    t.integer "topic_moved_id",            limit: 3,   default: 0,     null: false
    t.boolean "topic_bumped",                          default: false, null: false
    t.integer "topic_bumper",              limit: 3,   default: 0,     null: false
    t.string  "poll_title",                limit: 255, default: "",    null: false
    t.integer "poll_start",                limit: 4,   default: 0,     null: false
    t.integer "poll_length",               limit: 4,   default: 0,     null: false
    t.integer "poll_max_options",          limit: 1,   default: 1,     null: false
    t.integer "poll_last_vote",            limit: 4,   default: 0,     null: false
    t.boolean "poll_vote_change",                      default: false, null: false
  end

  add_index "phpbb3_topics", ["forum_id", "topic_approved", "topic_last_post_id"], name: "forum_appr_last", using: :btree
  add_index "phpbb3_topics", ["forum_id", "topic_last_post_time", "topic_moved_id"], name: "fid_time_moved", using: :btree
  add_index "phpbb3_topics", ["forum_id", "topic_type"], name: "forum_id_type", using: :btree
  add_index "phpbb3_topics", ["forum_id"], name: "forum_id", using: :btree
  add_index "phpbb3_topics", ["topic_approved"], name: "topic_approved", using: :btree
  add_index "phpbb3_topics", ["topic_last_post_time"], name: "last_post_time", using: :btree

  create_table "phpbb3_topics_posted", id: false, force: :cascade do |t|
    t.integer "user_id",      limit: 3, default: 0,     null: false
    t.integer "topic_id",     limit: 3, default: 0,     null: false
    t.boolean "topic_posted",           default: false, null: false
  end

  create_table "phpbb3_topics_track", id: false, force: :cascade do |t|
    t.integer "user_id",   limit: 3, default: 0, null: false
    t.integer "topic_id",  limit: 3, default: 0, null: false
    t.integer "forum_id",  limit: 3, default: 0, null: false
    t.integer "mark_time", limit: 4, default: 0, null: false
  end

  add_index "phpbb3_topics_track", ["forum_id"], name: "forum_id", using: :btree
  add_index "phpbb3_topics_track", ["topic_id"], name: "topic_id", using: :btree

  create_table "phpbb3_topics_watch", id: false, force: :cascade do |t|
    t.integer "topic_id",      limit: 3, default: 0,     null: false
    t.integer "user_id",       limit: 3, default: 0,     null: false
    t.boolean "notify_status",           default: false, null: false
  end

  add_index "phpbb3_topics_watch", ["notify_status"], name: "notify_stat", using: :btree
  add_index "phpbb3_topics_watch", ["topic_id"], name: "topic_id", using: :btree
  add_index "phpbb3_topics_watch", ["user_id"], name: "user_id", using: :btree

  create_table "phpbb3_user_group", id: false, force: :cascade do |t|
    t.integer "group_id",     limit: 3, default: 0,     null: false
    t.integer "user_id",      limit: 3, default: 0,     null: false
    t.boolean "group_leader",           default: false, null: false
    t.boolean "user_pending",           default: true,  null: false
  end

  add_index "phpbb3_user_group", ["group_id"], name: "group_id", using: :btree
  add_index "phpbb3_user_group", ["group_leader"], name: "group_leader", using: :btree
  add_index "phpbb3_user_group", ["user_id"], name: "user_id", using: :btree

  create_table "phpbb3_users", primary_key: "user_id", force: :cascade do |t|
    t.integer "user_type",                limit: 1,                                default: 0,           null: false
    t.integer "group_id",                 limit: 3,                                default: 3,           null: false
    t.text    "user_permissions",         limit: 16777215,                                               null: false
    t.integer "user_perm_from",           limit: 3,                                default: 0,           null: false
    t.string  "user_ip",                  limit: 40,                               default: "",          null: false
    t.integer "user_regdate",             limit: 4,                                default: 0,           null: false
    t.string  "username",                 limit: 255,                              default: "",          null: false
    t.string  "username_clean",           limit: 255,                              default: "",          null: false
    t.string  "user_password",            limit: 40,                               default: "",          null: false
    t.integer "user_passchg",             limit: 4,                                default: 0,           null: false
    t.boolean "user_pass_convert",                                                 default: false,       null: false
    t.string  "user_email",               limit: 100,                              default: "",          null: false
    t.integer "user_email_hash",          limit: 8,                                default: 0,           null: false
    t.string  "user_birthday",            limit: 10,                               default: "",          null: false
    t.integer "user_lastvisit",           limit: 4,                                default: 0,           null: false
    t.integer "user_lastmark",            limit: 4,                                default: 0,           null: false
    t.integer "user_lastpost_time",       limit: 4,                                default: 0,           null: false
    t.string  "user_lastpage",            limit: 200,                              default: "",          null: false
    t.string  "user_last_confirm_key",    limit: 10,                               default: "",          null: false
    t.integer "user_last_search",         limit: 4,                                default: 0,           null: false
    t.integer "user_warnings",            limit: 1,                                default: 0,           null: false
    t.integer "user_last_warning",        limit: 4,                                default: 0,           null: false
    t.integer "user_login_attempts",      limit: 1,                                default: 0,           null: false
    t.integer "user_inactive_reason",     limit: 1,                                default: 0,           null: false
    t.integer "user_inactive_time",       limit: 4,                                default: 0,           null: false
    t.integer "user_posts",               limit: 3,                                default: 0,           null: false
    t.string  "user_lang",                limit: 30,                               default: "",          null: false
    t.decimal "user_timezone",                             precision: 5, scale: 2, default: 0.0,         null: false
    t.boolean "user_dst",                                                          default: false,       null: false
    t.string  "user_dateformat",          limit: 30,                               default: "d M Y H:i", null: false
    t.integer "user_style",               limit: 3,                                default: 0,           null: false
    t.integer "user_rank",                limit: 3,                                default: 0,           null: false
    t.string  "user_colour",              limit: 6,                                default: "",          null: false
    t.integer "user_new_privmsg",         limit: 4,                                default: 0,           null: false
    t.integer "user_unread_privmsg",      limit: 4,                                default: 0,           null: false
    t.integer "user_last_privmsg",        limit: 4,                                default: 0,           null: false
    t.boolean "user_message_rules",                                                default: false,       null: false
    t.integer "user_full_folder",         limit: 4,                                default: -3,          null: false
    t.integer "user_emailtime",           limit: 4,                                default: 0,           null: false
    t.integer "user_topic_show_days",     limit: 2,                                default: 0,           null: false
    t.string  "user_topic_sortby_type",   limit: 1,                                default: "t",         null: false
    t.string  "user_topic_sortby_dir",    limit: 1,                                default: "d",         null: false
    t.integer "user_post_show_days",      limit: 2,                                default: 0,           null: false
    t.string  "user_post_sortby_type",    limit: 1,                                default: "t",         null: false
    t.string  "user_post_sortby_dir",     limit: 1,                                default: "a",         null: false
    t.boolean "user_notify",                                                       default: false,       null: false
    t.boolean "user_notify_pm",                                                    default: true,        null: false
    t.integer "user_notify_type",         limit: 1,                                default: 0,           null: false
    t.boolean "user_allow_pm",                                                     default: true,        null: false
    t.boolean "user_allow_viewonline",                                             default: true,        null: false
    t.boolean "user_allow_viewemail",                                              default: true,        null: false
    t.boolean "user_allow_massemail",                                              default: true,        null: false
    t.integer "user_options",             limit: 4,                                default: 230271,      null: false
    t.string  "user_avatar",              limit: 255,                              default: "",          null: false
    t.integer "user_avatar_type",         limit: 1,                                default: 0,           null: false
    t.integer "user_avatar_width",        limit: 2,                                default: 0,           null: false
    t.integer "user_avatar_height",       limit: 2,                                default: 0,           null: false
    t.text    "user_sig",                 limit: 16777215,                                               null: false
    t.string  "user_sig_bbcode_uid",      limit: 8,                                default: "",          null: false
    t.string  "user_sig_bbcode_bitfield", limit: 255,                              default: "",          null: false
    t.string  "user_from",                limit: 100,                              default: "",          null: false
    t.string  "user_icq",                 limit: 15,                               default: "",          null: false
    t.string  "user_aim",                 limit: 255,                              default: "",          null: false
    t.string  "user_yim",                 limit: 255,                              default: "",          null: false
    t.string  "user_msnm",                limit: 255,                              default: "",          null: false
    t.string  "user_jabber",              limit: 255,                              default: "",          null: false
    t.string  "user_website",             limit: 200,                              default: "",          null: false
    t.text    "user_occ",                 limit: 65535,                                                  null: false
    t.text    "user_interests",           limit: 65535,                                                  null: false
    t.string  "user_actkey",              limit: 32,                               default: "",          null: false
    t.string  "user_newpasswd",           limit: 40,                               default: "",          null: false
    t.string  "user_form_salt",           limit: 32,                               default: "",          null: false
    t.boolean "user_new",                                                          default: true,        null: false
    t.integer "user_reminded",            limit: 1,                                default: 0,           null: false
    t.integer "user_reminded_time",       limit: 4,                                default: 0,           null: false
    t.boolean "user_email_verified",                                               default: false,       null: false
    t.boolean "user_prune_exclude",                                                default: false,       null: false
  end

  add_index "phpbb3_users", ["user_birthday"], name: "user_birthday", using: :btree
  add_index "phpbb3_users", ["user_email_hash"], name: "user_email_hash", using: :btree
  add_index "phpbb3_users", ["user_type"], name: "user_type", using: :btree
  add_index "phpbb3_users", ["username_clean"], name: "username_clean", unique: true, using: :btree

  create_table "phpbb3_warnings", primary_key: "warning_id", force: :cascade do |t|
    t.integer "user_id",      limit: 3, default: 0, null: false
    t.integer "post_id",      limit: 3, default: 0, null: false
    t.integer "log_id",       limit: 3, default: 0, null: false
    t.integer "warning_time", limit: 4, default: 0, null: false
  end

  create_table "phpbb3_words", primary_key: "word_id", force: :cascade do |t|
    t.string "word",        limit: 255, default: "", null: false
    t.string "replacement", limit: 255, default: "", null: false
  end

  create_table "phpbb3_zebra", id: false, force: :cascade do |t|
    t.integer "user_id",  limit: 3, default: 0,     null: false
    t.integer "zebra_id", limit: 3, default: 0,     null: false
    t.boolean "friend",             default: false, null: false
    t.boolean "foe",                default: false, null: false
  end

  create_table "phpbb_auth_access", id: false, force: :cascade do |t|
    t.integer "group_id",         limit: 3, default: 0,     null: false
    t.integer "forum_id",         limit: 2, default: 0,     null: false
    t.boolean "auth_view",                  default: false, null: false
    t.boolean "auth_read",                  default: false, null: false
    t.boolean "auth_post",                  default: false, null: false
    t.boolean "auth_reply",                 default: false, null: false
    t.boolean "auth_edit",                  default: false, null: false
    t.boolean "auth_delete",                default: false, null: false
    t.boolean "auth_sticky",                default: false, null: false
    t.boolean "auth_announce",              default: false, null: false
    t.boolean "auth_vote",                  default: false, null: false
    t.boolean "auth_pollcreate",            default: false, null: false
    t.boolean "auth_attachments",           default: false, null: false
    t.boolean "auth_mod",                   default: false, null: false
  end

  add_index "phpbb_auth_access", ["forum_id"], name: "forum_id", using: :btree
  add_index "phpbb_auth_access", ["group_id"], name: "group_id", using: :btree

  create_table "plz2bl", primary_key: "loc_id", force: :cascade do |t|
    t.string  "plz",   limit: 5,   null: false
    t.string  "name",  limit: 255, null: false
    t.string  "bl",    limit: 30,  null: false
    t.integer "bl_id", limit: 8,   null: false
  end

  add_index "plz2bl", ["bl_id"], name: "bl_id", using: :btree

  create_table "plz_geodb", primary_key: "loc_id", force: :cascade do |t|
    t.string "plz", limit: 50,  null: false
    t.float  "lat", limit: 53,  null: false
    t.float  "lon", limit: 53,  null: false
    t.string "ort", limit: 255, null: false
  end

  add_index "plz_geodb", ["loc_id"], name: "loc_id_2", unique: true, using: :btree
  add_index "plz_geodb", ["ort"], name: "ort", using: :btree
  add_index "plz_geodb", ["plz"], name: "plz", unique: true, using: :btree

  create_table "regional_organization_bookings", force: :cascade do |t|
    t.integer  "regional_organization_id", limit: 4
    t.string   "booking_type",             limit: 255
    t.integer  "booking_year",             limit: 4
    t.string   "booking_mode",             limit: 255
    t.datetime "booking_date"
    t.string   "booking_txt",              limit: 255
    t.string   "filename",                 limit: 255
    t.float    "amount",                   limit: 24
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "regional_organization_bookings", ["regional_organization_id"], name: "index_regional_organization_bookings_on_regional_organization_id", using: :btree

  create_table "regional_organizations", force: :cascade do |t|
    t.integer  "nummer",     limit: 4,   null: false
    t.string   "name",       limit: 40,  null: false
    t.string   "subname",    limit: 50,  null: false
    t.string   "homepage",   limit: 50,  null: false
    t.string   "jugend_url", limit: 50,  null: false
    t.integer  "konto",      limit: 8,   null: false
    t.integer  "blz",        limit: 8,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at"
    t.string   "iban",       limit: 255
    t.string   "bic",        limit: 255
  end

  create_table "report_sheet_inputs", force: :cascade do |t|
    t.integer  "report_sheet_id",  limit: 4
    t.integer  "orchestra_id_old", limit: 4
    t.string   "token",            limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "admin_flag"
    t.integer  "orchestra_id",     limit: 4
  end

  add_index "report_sheet_inputs", ["orchestra_id_old"], name: "index_report_sheet_inputs_on_orchestra_id_old", using: :btree
  add_index "report_sheet_inputs", ["report_sheet_id"], name: "index_report_sheet_inputs_on_report_sheet_id", using: :btree

  create_table "report_sheets", force: :cascade do |t|
    t.integer  "year",             limit: 4,                   null: false
    t.integer  "orchestra_id_old", limit: 8
    t.integer  "children",         limit: 4,                   null: false
    t.integer  "teens",            limit: 4,                   null: false
    t.integer  "youth",            limit: 4,                   null: false
    t.integer  "adult",            limit: 4,                   null: false
    t.integer  "senior",           limit: 4,                   null: false
    t.boolean  "uv",                           default: false, null: false
    t.integer  "zusatz_uv",        limit: 4,   default: 0,     null: false
    t.integer  "korr_ztg",         limit: 4,   default: 0,     null: false
    t.integer  "zusatz_ztg",       limit: 4,   default: 0,     null: false
    t.integer  "gema",             limit: 4
    t.integer  "azubi",            limit: 4,                   null: false
    t.integer  "passive",          limit: 4,   default: 0,     null: false
    t.integer  "child_ens",        limit: 4
    t.integer  "youth_ens",        limit: 4
    t.integer  "adult_ens",        limit: 4
    t.integer  "senior_ens",       limit: 4
    t.integer  "chamber_ens",      limit: 4
    t.integer  "other_ens",        limit: 4
    t.string   "token",            limit: 255
    t.integer  "azubi_child",      limit: 4
    t.integer  "azubi_teens",      limit: 4
    t.integer  "azubi_youth",      limit: 4
    t.integer  "azubi_adult",      limit: 4
    t.integer  "azubi_senior",     limit: 4
    t.integer  "supporters",       limit: 4
    t.boolean  "zo"
    t.boolean  "zi_o"
    t.boolean  "go"
    t.boolean  "oz"
    t.date     "report_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "invoiced"
    t.string   "comment",          limit: 255
    t.boolean  "generated"
    t.integer  "orchestra_id",     limit: 4
  end

  add_index "report_sheets", ["year", "orchestra_id_old"], name: "oneperyear", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "static_tsconfig_help", primary_key: "uid", force: :cascade do |t|
    t.integer "guide",       limit: 4,     default: 0,  null: false
    t.string  "md5hash",     limit: 32,    default: "", null: false
    t.text    "description", limit: 65535
    t.string  "obj_string",  limit: 255,   default: "", null: false
    t.binary  "appdata",     limit: 65535
    t.string  "title",       limit: 255,   default: "", null: false
  end

  add_index "static_tsconfig_help", ["guide", "md5hash"], name: "guide", using: :btree

  create_table "subscribers", force: :cascade do |t|
    t.string   "account",    limit: 255
    t.string   "bic",        limit: 255
    t.integer  "contact_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "table_meta_data", force: :cascade do |t|
    t.string  "table_name",    limit: 50,  null: false
    t.string  "field_name",    limit: 50,  null: false
    t.integer "type",          limit: 4,   null: false
    t.string  "label",         limit: 100, null: false
    t.string  "mapping_table", limit: 50,  null: false
    t.string  "ref_table",     limit: 50,  null: false
    t.integer "field_order",   limit: 1,   null: false
  end

  create_table "tariffs", force: :cascade do |t|
    t.integer "tariff_type", limit: 4,                 null: false
    t.string  "description", limit: 50,                null: false
    t.decimal "amount",                 precision: 10, null: false
  end

  create_table "universities", force: :cascade do |t|
    t.string "name",         limit: 255, null: false
    t.string "institut",     limit: 255, null: false
    t.string "strasse",      limit: 50,  null: false
    t.string "plz",          limit: 10,  null: false
    t.string "ort",          limit: 50,  null: false
    t.string "telefon",      limit: 50,  null: false
    t.string "studiengang",  limit: 255, null: false
    t.string "dozent",       limit: 50,  null: false
    t.string "email",        limit: 50,  null: false
    t.string "homepage",     limit: 255, null: false
    t.string "country_code", limit: 2
    t.string "state",        limit: 255
    t.string "instrument",   limit: 255
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string   "filename",              limit: 255
    t.integer  "report_sheet_input_id", limit: 4
    t.integer  "correct_ds",            limit: 4
    t.integer  "faulty_ds",             limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.string   "upload_file_name",    limit: 255
    t.string   "upload_content_type", limit: 255
    t.integer  "upload_file_size",    limit: 4
    t.datetime "upload_updated_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "url2cat", id: false, force: :cascade do |t|
    t.integer "url_id", limit: 8, null: false
    t.integer "cat_id", limit: 8, null: false
  end

  add_index "url2cat", ["url_id", "cat_id"], name: "url_id", unique: true, using: :btree

  create_table "url_categories", force: :cascade do |t|
    t.integer "parent",      limit: 8,   default: 0,     null: false
    t.boolean "leaf",                    default: false, null: false
    t.boolean "hascountry",              default: false, null: false
    t.string  "description", limit: 255, default: "",    null: false
  end

  create_table "urls", force: :cascade do |t|
    t.integer  "category",     limit: 8,   default: 0,  null: false
    t.string   "url",          limit: 255, default: "", null: false
    t.string   "titel",        limit: 255,              null: false
    t.string   "descr",        limit: 255, default: "", null: false
    t.string   "sprache",      limit: 255, default: "", null: false
    t.integer  "country_id",   limit: 8,   default: 0,  null: false
    t.integer  "bland",        limit: 8,   default: 0,  null: false
    t.string   "email",        limit: 255, default: "", null: false
    t.integer  "fk_user",      limit: 8,   default: 1,  null: false
    t.datetime "lastchange"
    t.datetime "confirmed",                             null: false
    t.string   "ip",           limit: 100,              null: false
    t.integer  "visible",      limit: 4,   default: 0,  null: false
    t.string   "country_code", limit: 2
  end

  add_index "urls", ["bland"], name: "bland", using: :btree
  add_index "urls", ["category"], name: "category", using: :btree
  add_index "urls", ["country_id"], name: "country", using: :btree
  add_index "urls", ["fk_user"], name: "fk_user", using: :btree

  create_table "user", force: :cascade do |t|
    t.string "username", limit: 255, null: false
    t.string "passwd",   limit: 255, null: false
    t.string "email",    limit: 255, null: false
  end

  add_index "user", ["email"], name: "email", unique: true, using: :btree
  add_index "user", ["username"], name: "username", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "name",                   limit: 100,              null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "authentication_token",   limit: 255
    t.string   "username",               limit: 255
    t.string   "entity_class",           limit: 255
    t.integer  "entity_id",              limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "concertino_inhalt", "concertino_category", column: "category", name: "concertino_inhalt_ibfk_1", on_update: :cascade
  add_foreign_key "concerts", "bundeslaender", column: "bland", name: "concerts_ibfk_6"
  add_foreign_key "courses", "bundeslaender", column: "bland", name: "courses_ibfk_1"
  add_foreign_key "courses", "festivals", column: "fk_festival", name: "courses_ibfk_2"
  add_foreign_key "festivals", "bundeslaender", column: "bland", name: "festivals_ibfk_3", on_update: :cascade
  add_foreign_key "magazine_adverts", "magazine_issues", name: "magazine_adverts_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "member_account_bookings", "members", name: "member_account_bookings_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "member_events", "members", name: "member_events_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "orchestra_contacts", "members", column: "orchestra_id_old", name: "orchestra_contacts_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "orte", "bundeslaender", column: "fk_bland_id", name: "orte_ibfk_1"
  add_foreign_key "plz2bl", "bundeslaender", column: "bl_id", name: "plz2bl_ibfk_2"
  add_foreign_key "plz2bl", "geo_orte", column: "loc_id", primary_key: "loc_id", name: "plz2bl_ibfk_1"
  add_foreign_key "urls", "bundeslaender", column: "bland", name: "urls_ibfk_5", on_update: :cascade
  add_foreign_key "urls", "country", name: "urls_ibfk_7"
  add_foreign_key "urls", "user", column: "fk_user", name: "urls_ibfk_6"
end
