# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_04_10_171348) do
  create_table "Inserenten", id: false, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "Firmenname", limit: 35
    t.string "Titel", limit: 5
    t.string "Vorname", limit: 12
    t.string "Name", limit: 8
    t.string "Adresszeile 1", limit: 17
    t.string "Postleitzahl", limit: 7
    t.string "Stadt", limit: 14
    t.integer "Stückzahl"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "advertisers", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "contact_id_off"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "konto"
    t.string "iban"
    t.string "bic"
    t.string "customer_number"
    t.string "account_owner"
    t.boolean "direct_debit"
    t.boolean "active"
    t.integer "magazines"
    t.index ["contact_id_off"], name: "contact_id"
  end

  create_table "blacklist", charset: "utf8mb3", collation: "utf8mb3_general_ci", comment: "IP Blacklist ", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "ip", limit: 16, null: false
    t.datetime "blacklisted", precision: nil, null: false
    t.index ["ip"], name: "ip", unique: true
  end

  create_table "board_contacts", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "contact_id_off"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "bundeslaender", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name", null: false
    t.date "created_on", null: false
    t.datetime "created_at", precision: nil, null: false
    t.date "updated_on", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "country_code", limit: 2
  end

  create_table "classifieds", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "adv_type", default: 0, null: false
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "url", default: "", null: false
    t.string "object", default: "", null: false
    t.text "description", size: :medium, null: false
    t.date "validuntil", null: false
    t.datetime "entrydate", precision: nil, null: false
    t.datetime "confirmed", precision: nil
    t.string "ip", limit: 45, null: false
    t.boolean "visible", default: false, null: false
  end

  create_table "competition_entries", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.date "date_of_birth"
    t.integer "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "city"
    t.string "zip"
    t.string "country_code"
    t.string "email"
    t.string "like"
    t.string "missing"
    t.string "improve"
    t.boolean "correct"
    t.string "response1"
    t.string "response2"
    t.string "response3"
    t.string "response4"
    t.boolean "winner", default: false
  end

  create_table "composers", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.string "vorname"
    t.string "gebjahr"
    t.string "sterbejahr"
    t.boolean "ca_geb"
    t.boolean "ca_sterb"
    t.integer "fk_ref_komp_id"
    t.string "comment"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "link"
    t.index ["fk_ref_komp_id"], name: "index_composers_on_fk_ref_komp_id"
  end

  create_table "concertino_category", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "title", null: false
  end

  create_table "concertino_inhalt", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "volume", null: false
    t.bigint "category", null: false
    t.string "title", null: false
    t.string "subtitle", null: false
    t.string "author", null: false
    t.string "page", limit: 10, null: false
    t.index ["category"], name: "category"
  end

  create_table "concerts", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.date "datum"
    t.time "zeit", default: "2000-01-01 00:00:00"
    t.decimal "eintritt", precision: 10, null: false
    t.datetime "reported", precision: nil, null: false
    t.datetime "confirmed", precision: nil
    t.string "token", null: false
    t.string "stadt", null: false
    t.text "titel", null: false
    t.string "ort"
    t.bigint "festival_id", default: 0, null: false
    t.string "interpret", null: false
    t.string "url", null: false
    t.string "comment", null: false
    t.string "bundesland", default: "", null: false
    t.bigint "bland", default: 0
    t.string "email", default: "", null: false
    t.bigint "owner", default: 1, null: false
    t.integer "visible", limit: 2, default: 1, null: false
    t.integer "orchestra_id"
    t.string "uid"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "country_code", limit: 2
    t.datetime "concert_date", precision: nil
    t.integer "mglnr"
    t.index ["bland"], name: "bland"
    t.index ["datum", "zeit", "interpret"], name: "unique_event", unique: true, length: { interpret: 30 }
    t.index ["festival_id"], name: "festival"
    t.index ["owner"], name: "fk_owner"
    t.index ["uid"], name: "index_concerts_on_uid", unique: true
  end

  create_table "contact_events", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "event_type"
    t.datetime "event_date", precision: nil
    t.string "event_id"
    t.integer "contact_person_id"
    t.string "comment"
    t.string "filename"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "contact_people", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "salutation"
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "zip"
    t.string "city"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "country_code", limit: 2
    t.integer "festival_application_id"
    t.index ["festival_application_id"], name: "index_contact_people_on_festival_application_id"
  end

  create_table "contacts", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "subtype", limit: 50
    t.string "company", limit: 100
    t.string "department", limit: 100
    t.string "salutation", limit: 10, null: false
    t.string "title", limit: 50
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.string "street", limit: 50, null: false
    t.string "zip", limit: 10, null: false
    t.string "city", limit: 50, null: false
    t.string "phone", limit: 50
    t.string "office_phone", limit: 100
    t.string "mobile", limit: 50
    t.string "fax", limit: 50
    t.string "email", limit: 50
    t.string "bic"
    t.string "iban"
    t.string "country_code", limit: 2
    t.integer "contact_entity_id"
    t.string "contact_entity_type"
  end

  create_table "contests", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.date "startdate", null: false
    t.date "enddate", null: false
    t.text "titel", size: :medium, null: false
    t.text "beschreibung", size: :medium, null: false
    t.text "gebuehr", size: :medium, null: false
    t.text "preis", size: :medium, null: false
    t.text "anmeldung", size: :medium, null: false
    t.date "deadline", null: false
    t.string "email", limit: 50, null: false
    t.datetime "reported", precision: nil, null: false
    t.datetime "confirmed", precision: nil
    t.boolean "visible", default: true, null: false
  end

  create_table "country", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "ccode", limit: 5, default: "", null: false
    t.date "created_on", null: false
    t.datetime "created_at", precision: nil, null: false
    t.date "updated_on", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "name", unique: true
  end

  create_table "courses", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "startdate", precision: nil, null: false
    t.datetime "enddate", precision: nil, null: false
    t.datetime "reported", precision: nil, null: false
    t.datetime "confirmed", precision: nil
    t.bigint "bland", null: false
    t.bigint "fk_festival", default: 0
    t.text "more_dates", null: false
    t.text "titel", null: false
    t.string "ort", null: false
    t.text "beschreibung", null: false
    t.text "inhalt", null: false
    t.text "gebuehr", null: false
    t.text "zielgruppe", null: false
    t.text "dozenten", null: false
    t.text "anmeldung", null: false
    t.date "deadline", null: false
    t.string "email", null: false
    t.string "token", limit: 40
    t.integer "visible", default: 0, null: false
    t.string "country_code", limit: 2
    t.index ["bland"], name: "bland"
    t.index ["fk_festival"], name: "fk_festival"
  end

  create_table "distinctions", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.date "dist_date"
    t.integer "certificates"
    t.integer "honorletters"
    t.integer "medals"
    t.integer "orchestra_id_old"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "gold_needles"
    t.integer "silver_needles"
    t.integer "national_needles"
    t.integer "member_account_booking_id"
    t.float "porto"
    t.integer "orchestra_id"
    t.string "invoice_id"
    t.index ["member_account_booking_id"], name: "index_distinctions_on_member_account_booking_id"
    t.index ["orchestra_id_old"], name: "index_distinctions_on_orchestra_id_old"
  end

  create_table "ensemble_concerts", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "datum", precision: nil, null: false
    t.time "zeit", default: "2000-01-01 00:00:00", null: false
    t.datetime "reported", precision: nil, null: false
    t.datetime "confirmed", precision: nil
    t.string "stadt", default: "", null: false
    t.string "ort", default: "", null: false
    t.bigint "festival_id", default: 0, null: false
    t.bigint "ensemble_id", default: 0, null: false
    t.text "titel", size: :medium, null: false
    t.string "comment", default: "", null: false
    t.decimal "eintritt", precision: 10, null: false
    t.bigint "state_id", null: false
    t.bigint "country_id", default: 0, null: false
    t.string "email", default: "", null: false
    t.bigint "fk_owner", default: 1, null: false
    t.integer "visible", limit: 2, default: 0, null: false
    t.text "url", size: :medium, null: false
    t.string "country_code", limit: 2
    t.index ["country_id"], name: "land"
    t.index ["datum", "zeit", "ensemble_id"], name: "unique_event", unique: true
    t.index ["ensemble_id"], name: "ensemble_id"
    t.index ["fk_owner"], name: "fk_owner"
    t.index ["state_id"], name: "bundesland"
  end

  create_table "ensembles", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "homepage", default: "", null: false
    t.string "beschreibung", default: "", null: false
    t.string "email", default: "", null: false
    t.bigint "owner", null: false
    t.integer "visible", limit: 2, default: 0, null: false
    t.integer "mglnr"
    t.index ["owner"], name: "owner"
  end

  create_table "event_cards", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "orderdate", precision: nil, null: false
    t.string "name", limit: 100, null: false
    t.string "email", limit: 100, null: false
    t.integer "nr_fest", default: 0, null: false
    t.integer "nr_fest_erm", default: 0, null: false
    t.integer "nr_fest_bdz", default: 0, null: false
    t.integer "nr_fest_bdz_erm", default: 0, null: false
    t.integer "nr_do", default: 0, null: false
    t.integer "nr_do_erm", default: 0, null: false
    t.integer "nr_fr", default: 0, null: false
    t.integer "nr_fr_erm", default: 0, null: false
    t.integer "nr_sa", default: 0, null: false
    t.integer "nr_sa_erm", default: 0, null: false
    t.integer "nr_concert_so", default: 0, null: false
    t.integer "nr_concert_so_erm", default: 0, null: false
    t.boolean "invoiced", default: false
    t.boolean "payment_received", default: false
    t.string "street"
    t.string "city"
    t.string "country_code"
    t.string "company"
    t.string "preferred_lang"
    t.string "zip"
    t.boolean "pickup", default: false
  end

  create_table "event_food", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "tln", null: false
    t.integer "veg", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "orderdate", precision: nil, null: false
    t.integer "participant_id"
    t.datetime "arrival_time", precision: nil
  end

  create_table "feature_requests", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "title"
    t.text "description", size: :medium
    t.integer "priority"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "status", default: "N"
    t.integer "user_id"
  end

  create_table "festival_application_attachments", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "attached_file_file_name"
    t.string "attached_file_content_type"
    t.integer "attached_file_file_size"
    t.datetime "attached_file_updated_at", precision: nil
    t.integer "festival_application_id"
  end

  create_table "festival_applications", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "orchestra_id"
    t.text "orch_name", size: :medium
    t.text "conductor", size: :medium
    t.integer "num_players"
    t.text "equipment", size: :medium
    t.text "special_cast", size: :medium
    t.integer "contact_person_id_off"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "group_type"
    t.string "uuid"
    t.boolean "permission"
    t.integer "festival_concert_id"
    t.datetime "rehearsal_time", precision: nil
    t.string "visitor_type"
    t.string "country_code", limit: 2
    t.column "payment_status", "enum('N','P','F','S')", default: "N"
    t.integer "tickets"
    t.integer "tickets_red"
    t.integer "bdz_tickets"
    t.integer "bdz_tickets_red"
    t.float "amount", limit: 53
    t.integer "soloist_tickets"
    t.time "stage_time"
    t.string "contact_phone"
    t.integer "festival_year"
    t.string "token"
    t.string "comment"
    t.text "workshop_request"
    t.integer "year"
    t.boolean "confirmed"
  end

  create_table "festival_concerts", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "location"
    t.datetime "event_time", precision: nil
    t.integer "number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "title"
    t.boolean "outdoor"
    t.column "concert_type", "enum('B','O','W','K','S')"
  end

  create_table "festival_pieces", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "festival_application_id"
    t.string "composer"
    t.string "title"
    t.string "duration"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "festivals", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.date "startdate", null: false
    t.date "enddate", null: false
    t.bigint "bland", null: false
    t.string "name", default: "", null: false
    t.text "description", size: :medium, null: false
    t.text "anmeldung", size: :medium, null: false
    t.text "gebuehren", size: :medium, null: false
    t.string "stadt", default: "", null: false
    t.string "homepage", default: "", null: false
    t.string "ort", default: "", null: false
    t.text "ortdetails", size: :medium, null: false
    t.boolean "visible", default: false, null: false
    t.string "country_code", limit: 2
    t.index ["bland"], name: "bland"
  end

  create_table "functions", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "label", limit: 10
    t.bigint "regional_organization_id", null: false
    t.bigint "board_contact_id", null: false
    t.boolean "bund", null: false
    t.boolean "jugend", null: false
    t.integer "musik", default: 0, null: false
    t.integer "nr", null: false
    t.string "funktion", limit: 50, null: false
    t.text "fkt_subtitle", size: :medium, null: false
    t.index ["board_contact_id"], name: "fk_addr_id"
    t.index ["regional_organization_id", "board_contact_id"], name: "fk_lv_id"
  end

  create_table "gema_events", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "kdnr"
    t.string "name"
    t.string "zip"
    t.string "city"
    t.date "date"
    t.string "title"
    t.string "tariff"
    t.float "amount"
    t.string "location"
    t.string "location_city"
    t.boolean "program_available"
    t.string "source"
    t.string "par_mgl"
    t.string "nf_id"
    t.integer "sap_nr"
    t.bigint "orchestra_id", null: false
    t.integer "license_nr"
    t.date "event_date"
    t.float "ticket_total"
    t.float "admission_price"
    t.float "music_effort"
    t.integer "visitors"
    t.integer "room_size"
    t.string "setlist"
    t.float "gema_amount"
    t.float "gstv_reduction"
    t.float "cultural_reduction"
    t.float "e_reduction"
    t.float "netto"
    t.index ["orchestra_id"], name: "index_gema_events_on_orchestra_id"
  end

  create_table "geo_orte", id: false, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "loc_id", null: false
    t.string "ags", limit: 10, null: false
    t.string "ascii", limit: 50, null: false
    t.string "name", limit: 50, null: false
    t.float "lat", limit: 53, null: false
    t.float "lon", limit: 53, null: false
    t.string "amt", limit: 20, null: false
    t.string "plz", null: false
    t.string "vorwahl", limit: 10, null: false
    t.string "einwohner", limit: 15, null: false
    t.float "flaeche", limit: 53, null: false
    t.string "kz", limit: 10, null: false
    t.string "typ", limit: 10, null: false
    t.string "level", limit: 10, null: false
    t.bigint "of", null: false
    t.string "invalid", limit: 10, null: false
    t.index ["loc_id"], name: "loc_id"
    t.index ["name"], name: "name"
    t.index ["of"], name: "of"
    t.index ["plz"], name: "plz"
  end

  create_table "guestbook", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "email", limit: 50, null: false
    t.datetime "date", precision: nil, null: false
    t.string "ip", null: false
    t.text "message", size: :medium, null: false
    t.string "anmerkung", null: false
    t.datetime "confirmed", precision: nil, null: false
    t.boolean "visible", null: false
  end

  create_table "homepages", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "abbrev", limit: 20, null: false
    t.string "mitglnr", limit: 6, null: false
    t.string "name", limit: 100, null: false
    t.text "kontakt", null: false
    t.text "proben", null: false
    t.text "descr", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "redir_url"
  end

  create_table "honor_members", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "nr"
    t.string "anrede", limit: 100
    t.string "vorname", limit: 100
    t.string "name", limit: 100
    t.string "ort", limit: 100
    t.string "honorType", limit: 100
    t.date "honorDate"
    t.boolean "deceased"
  end

  create_table "jugend_artikel", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "titel", null: false
    t.string "autor", null: false
    t.string "file", null: false
    t.integer "jahr", null: false
    t.integer "ausgabe", limit: 1, null: false
  end

  create_table "komponisten", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "vorname", limit: 100, null: false
    t.string "gebjahr", limit: 11, null: false
    t.string "sterbejahr", limit: 11, null: false
    t.boolean "ca_geb", null: false
    t.boolean "ca_sterb", null: false
    t.bigint "fk_ref_komp"
    t.string "comment", limit: 200, null: false
  end

  create_table "konzert2ensemble", primary_key: ["fk_konz_id", "fk_ens_id"], charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "fk_konz_id", null: false
    t.bigint "fk_ens_id", null: false
  end

  create_table "magazine_adverts", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "advertiser_id"
    t.integer "magazine_issue_id"
    t.string "advert_type", limit: 1, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["advertiser_id"], name: "advertiser_id"
    t.index ["magazine_issue_id"], name: "magazine_issue_id"
  end

  create_table "magazine_issues", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "year"
    t.integer "number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "magazine_samplings", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "count"
    t.integer "contact_id_off"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "inactive", default: false
  end

  create_table "member_account_bookings", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.column "booking_type", "enum('B','L','G','R','S','Z','E','A','X')", null: false
    t.integer "booking_year", null: false
    t.column "booking_mode", "enum('A','M')", null: false
    t.datetime "booking_date", precision: nil, null: false
    t.string "booking_txt", null: false
    t.string "filename", limit: 100
    t.float "amount", limit: 53, null: false
    t.integer "ref_booking_id"
    t.string "invoice_id"
    t.index ["member_id"], name: "member_id"
    t.index ["ref_booking_id"], name: "index_member_account_bookings_on_ref_booking_id"
  end

  create_table "member_events", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "event_type"
    t.datetime "event_date", precision: nil
    t.string "event_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "member_id"
    t.string "comment"
    t.string "filename"
    t.index ["member_id"], name: "member_id"
  end

  create_table "members", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "subtype", limit: 50
    t.bigint "regional_organization_id", null: false
    t.bigint "mglnr", null: false
    t.string "anrede", limit: 20, null: false
    t.string "vorname", limit: 100, null: false
    t.string "name", limit: 100, null: false
    t.string "strasse", limit: 50, null: false
    t.string "plz", limit: 20, null: false
    t.string "ort", limit: 50, null: false
    t.string "email", limit: 100
    t.date "eintritt", null: false
    t.date "austritt_zum"
    t.column "za", "enum('R','L')", null: false
    t.bigint "konto", unsigned: true
    t.string "blz", limit: 8
    t.string "zahler", limit: 100
    t.datetime "created_at", precision: nil, null: false
    t.datetime "update_at", precision: nil
    t.string "telefon"
    t.string "fax"
    t.string "bic"
    t.string "iban"
    t.string "country_code", limit: 2
    t.string "title"
    t.string "member_entity_type"
    t.integer "member_entity_id"
    t.boolean "deleted", default: false
    t.datetime "deleted_at", precision: nil
    t.boolean "dsgvo"
    t.datetime "dsgvo_date", precision: nil
    t.date "sepa_date"
    t.string "sepa_mandate_nr"
    t.integer "magazines", default: -1, null: false
    t.index ["deleted_at"], name: "index_members_on_deleted_at"
    t.index ["mglnr"], name: "mglnr", unique: true
  end

  create_table "members_v", id: false, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "id", limit: 1, null: false
    t.integer "subtype", limit: 1, null: false
    t.integer "regional_organization_id", limit: 1, null: false
    t.integer "mglnr", limit: 1, null: false
    t.integer "anrede", limit: 1, null: false
    t.integer "vorname", limit: 1, null: false
    t.integer "name", limit: 1, null: false
    t.integer "strasse", limit: 1, null: false
    t.integer "plz", limit: 1, null: false
    t.integer "ort", limit: 1, null: false
    t.integer "email", limit: 1, null: false
    t.integer "eintritt", limit: 1, null: false
    t.integer "austritt_zum", limit: 1, null: false
    t.integer "za", limit: 1, null: false
    t.integer "konto", limit: 1, null: false
    t.integer "blz", limit: 1, null: false
    t.integer "zahler", limit: 1, null: false
    t.integer "created_at", limit: 1, null: false
    t.integer "update_at", limit: 1, null: false
    t.integer "telefon", limit: 1, null: false
    t.integer "fax", limit: 1, null: false
    t.integer "bic", limit: 1, null: false
    t.integer "iban", limit: 1, null: false
    t.integer "country_code", limit: 1, null: false
    t.integer "title", limit: 1, null: false
  end

  create_table "orchestra_contacts", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "orchestra_id_old"
    t.string "salutation"
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "zip"
    t.string "city"
    t.string "role"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "country_code"
    t.integer "orchestra_id"
    t.index ["orchestra_id_old"], name: "index_orchestra_contacts_on_orchestra_id_old"
  end

  create_table "orchestra_members", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "orchestra_id_old"
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "instrument"
    t.integer "mglnr"
    t.integer "orchestra_id"
    t.index ["orchestra_id_old", "first_name", "last_name", "date_of_birth"], name: "orchestra_id", unique: true
    t.index ["orchestra_id_old"], name: "index_orchestra_members_on_orchestra_id_old"
  end

  create_table "orchestras", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "member_id_off"
    t.string "orchName", limit: 200
    t.string "land", limit: 510
    t.date "gruendung"
    t.column "orch_type", "enum('O','K','L','A','X')", default: "O", null: false
    t.string "bemerkung", limit: 510
    t.string "url", limit: 100
    t.boolean "kuendigungErfasst"
    t.string "zweitanschrift", limit: 100
    t.string "name2", limit: 100
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.string "gema_kdnr"
    t.boolean "publish_url", default: true
    t.boolean "publish_address", default: false
    t.string "gema_kdnr_new"
    t.date "promusica"
    t.integer "ztg_override", default: 0, null: false
    t.index ["deleted_at"], name: "index_orchestras_on_deleted_at"
  end

  create_table "orte", primary_key: "ID", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "PLZ", limit: 11, default: "-", null: false
    t.string "Ort", limit: 50, default: "-", null: false
    t.string "Land", limit: 3, default: "-", null: false
    t.bigint "fk_bland_id", null: false
    t.string "Vorwahl", limit: 12, default: "-", null: false
    t.string "Staat", limit: 5, default: "-", null: false
    t.index ["Ort"], name: "Ort"
    t.index ["PLZ"], name: "PLZ"
    t.index ["Staat"], name: "Staat"
    t.index ["Vorwahl"], name: "Vorwahl"
    t.index ["fk_bland_id"], name: "fk_bland_id"
  end

  create_table "pages_language_overlay", primary_key: "uid", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "pid", default: 0, null: false
    t.integer "t3ver_oid", default: 0, null: false
    t.integer "t3ver_id", default: 0, null: false
    t.integer "t3ver_wsid", default: 0, null: false
    t.string "t3ver_label", default: ""
    t.integer "t3ver_state", limit: 1, default: 0, null: false
    t.integer "t3ver_stage", limit: 1, default: 0, null: false
    t.integer "t3ver_count", default: 0, null: false
    t.integer "t3ver_tstamp", default: 0, null: false
    t.integer "t3_origuid", default: 0, null: false
    t.integer "tstamp", default: 0, null: false, unsigned: true
    t.integer "crdate", default: 0, null: false, unsigned: true
    t.integer "cruser_id", default: 0, null: false, unsigned: true
    t.integer "sys_language_uid", default: 0, null: false, unsigned: true
    t.string "title", default: "", null: false
    t.integer "hidden", limit: 1, default: 0, null: false, unsigned: true
    t.integer "starttime", default: 0, null: false, unsigned: true
    t.integer "endtime", default: 0, null: false, unsigned: true
    t.integer "deleted", limit: 1, default: 0, null: false, unsigned: true
    t.string "subtitle", default: "", null: false
    t.string "nav_title", default: "", null: false
    t.text "media"
    t.text "keywords", size: :medium
    t.text "description", size: :medium
    t.text "abstract", size: :medium
    t.string "author", default: "", null: false
    t.string "author_email", limit: 80, default: "", null: false
    t.integer "tx_impexp_origuid", default: 0, null: false
    t.binary "l18n_diffsource", size: :medium
    t.integer "doktype", limit: 1, default: 0, null: false, unsigned: true
    t.string "url", default: "", null: false
    t.integer "urltype", limit: 1, default: 0, null: false, unsigned: true
    t.integer "shortcut", default: 0, null: false, unsigned: true
    t.integer "shortcut_mode", default: 0, null: false, unsigned: true
    t.index ["pid", "sys_language_uid"], name: "parent"
    t.index ["t3ver_oid", "t3ver_wsid"], name: "t3ver_oid"
  end

  create_table "person_members", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "member_id_off"
    t.date "geburtstag"
    t.string "telefonDienstl", limit: 60
    t.bigint "lv"
    t.bigint "tariff_id"
    t.string "bemerkung", limit: 510
    t.date "kuendigungVom"
    t.float "beitrag", limit: 53
    t.boolean "lastschriftErfasst"
    t.boolean "rechnungsDruck"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.index ["deleted_at"], name: "index_person_members_on_deleted_at"
  end

  create_table "phpbb_auth_access", id: false, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "group_id", limit: 3, default: 0, null: false
    t.integer "forum_id", limit: 2, default: 0, null: false, unsigned: true
    t.boolean "auth_view", default: false, null: false
    t.boolean "auth_read", default: false, null: false
    t.boolean "auth_post", default: false, null: false
    t.boolean "auth_reply", default: false, null: false
    t.boolean "auth_edit", default: false, null: false
    t.boolean "auth_delete", default: false, null: false
    t.boolean "auth_sticky", default: false, null: false
    t.boolean "auth_announce", default: false, null: false
    t.boolean "auth_vote", default: false, null: false
    t.boolean "auth_pollcreate", default: false, null: false
    t.boolean "auth_attachments", default: false, null: false
    t.boolean "auth_mod", default: false, null: false
    t.index ["forum_id"], name: "forum_id"
    t.index ["group_id"], name: "group_id"
  end

  create_table "plz2bl", primary_key: "loc_id", id: :bigint, default: nil, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "plz", limit: 5, null: false
    t.string "name", null: false
    t.string "bl", limit: 30, null: false
    t.bigint "bl_id", null: false
    t.index ["bl_id"], name: "bl_id"
  end

  create_table "plz_geodb", primary_key: "loc_id", id: :bigint, default: nil, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "plz", limit: 50, null: false
    t.float "lat", limit: 53, null: false
    t.float "lon", limit: 53, null: false
    t.string "ort", null: false
    t.index ["loc_id"], name: "loc_id_2", unique: true
    t.index ["ort"], name: "ort"
    t.index ["plz"], name: "plz", unique: true
  end

  create_table "regional_organization_bookings", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "regional_organization_id"
    t.string "booking_type"
    t.integer "booking_year"
    t.string "booking_mode"
    t.datetime "booking_date", precision: nil
    t.string "booking_txt"
    t.string "filename"
    t.float "amount"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["regional_organization_id"], name: "index_regional_organization_bookings_on_regional_organization_id"
  end

  create_table "regional_organizations", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "nummer", null: false
    t.string "name", limit: 40, null: false
    t.string "subname", limit: 50, null: false
    t.string "homepage", limit: 50, null: false
    t.string "jugend_url", limit: 50, null: false
    t.bigint "konto", null: false
    t.bigint "blz", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil
    t.string "iban"
    t.string "bic"
    t.string "gema_kdnr"
    t.string "gema_kdnr_new"
  end

  create_table "report_sheet_inputs", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "report_sheet_id"
    t.integer "orchestra_id_old"
    t.string "token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "admin_flag"
    t.integer "orchestra_id"
    t.boolean "locked"
    t.index ["orchestra_id_old"], name: "index_report_sheet_inputs_on_orchestra_id_old"
    t.index ["report_sheet_id"], name: "index_report_sheet_inputs_on_report_sheet_id"
  end

  create_table "report_sheets", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "year", null: false
    t.bigint "orchestra_id_old"
    t.integer "children", null: false
    t.integer "teens", null: false
    t.integer "youth", null: false
    t.integer "adult", null: false
    t.integer "senior", null: false
    t.boolean "uv", default: false, null: false
    t.integer "zusatz_uv", default: 0, null: false
    t.integer "korr_ztg", default: 0, null: false
    t.integer "zusatz_ztg", default: 0, null: false
    t.integer "gema"
    t.integer "azubi", null: false
    t.integer "passive", default: 0, null: false
    t.integer "child_ens"
    t.integer "youth_ens"
    t.integer "adult_ens"
    t.integer "senior_ens"
    t.integer "chamber_ens"
    t.integer "other_ens"
    t.string "token"
    t.integer "azubi_child"
    t.integer "azubi_teens"
    t.integer "azubi_youth"
    t.integer "azubi_adult"
    t.integer "azubi_senior"
    t.integer "supporters"
    t.integer "zo"
    t.integer "zi_o"
    t.integer "go"
    t.integer "oz"
    t.date "report_date"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "invoiced"
    t.string "comment"
    t.boolean "generated"
    t.integer "orchestra_id"
    t.integer "ms_total"
    t.index ["year", "orchestra_id_old"], name: "oneperyear", unique: true
  end

  create_table "roles", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "static_tsconfig_help", primary_key: "uid", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "guide", default: 0, null: false
    t.string "md5hash", limit: 32, default: "", null: false
    t.text "description", size: :medium
    t.string "obj_string", default: "", null: false
    t.binary "appdata"
    t.string "title", default: "", null: false
    t.index ["guide", "md5hash"], name: "guide"
  end

  create_table "subscribers", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "account"
    t.string "bic"
    t.integer "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "table_meta_data", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "table_name", limit: 50, null: false
    t.string "field_name", limit: 50, null: false
    t.integer "type", null: false
    t.string "label", limit: 100, null: false
    t.string "mapping_table", limit: 50, null: false
    t.string "ref_table", limit: 50, null: false
    t.integer "field_order", limit: 1, null: false
  end

  create_table "tariffs", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "tariff_type", null: false
    t.string "description", limit: 50, null: false
    t.decimal "amount", precision: 10, null: false
  end

  create_table "universities", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name", null: false
    t.string "institut", null: false
    t.string "strasse", limit: 50, null: false
    t.string "plz", limit: 10, null: false
    t.string "ort", limit: 50, null: false
    t.string "telefon", limit: 50, null: false
    t.string "studiengang", null: false
    t.string "dozent", limit: 50, null: false
    t.string "email", limit: 50, null: false
    t.string "homepage", null: false
    t.string "country_code", limit: 2
    t.string "state"
    t.string "instrument"
  end

  create_table "uploaded_files", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "filename"
    t.integer "report_sheet_input_id"
    t.integer "correct_ds"
    t.integer "faulty_ds"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "uploads", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "upload_file_name"
    t.string "upload_content_type"
    t.integer "upload_file_size"
    t.datetime "upload_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "url2cat", id: false, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "url_id", null: false
    t.bigint "cat_id", null: false
    t.index ["url_id", "cat_id"], name: "url_id", unique: true
  end

  create_table "url_categories", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "parent", default: 0, null: false
    t.boolean "leaf", default: false, null: false
    t.boolean "hascountry", default: false, null: false
    t.string "description", default: "", null: false
  end

  create_table "urls", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "category", default: 0, null: false
    t.string "url", default: "", null: false
    t.string "titel", null: false
    t.string "descr", default: "", null: false
    t.string "sprache", default: "", null: false
    t.bigint "country_id", default: 0, null: false
    t.bigint "bland", default: 0, null: false
    t.string "email", default: "", null: false
    t.bigint "fk_user", default: 1, null: false
    t.timestamp "lastchange", default: -> { "current_timestamp() ON UPDATE current_timestamp()" }
    t.datetime "confirmed", precision: nil, null: false
    t.string "ip", limit: 100, null: false
    t.integer "visible", default: 0, null: false
    t.string "country_code", limit: 2
    t.index ["bland"], name: "bland"
    t.index ["category"], name: "category"
    t.index ["country_id"], name: "country"
    t.index ["fk_user"], name: "fk_user"
  end

  create_table "user", charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "username", null: false
    t.string "passwd", null: false
    t.string "email", null: false
    t.index ["email"], name: "email", unique: true
    t.index ["username"], name: "username", unique: true
  end

  create_table "users", id: :integer, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "email", default: "", null: false
    t.string "name", limit: 100, null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "authentication_token"
    t.string "username"
    t.string "entity_class"
    t.integer "entity_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, charset: "utf8mb3", collation: "utf8mb3_general_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "concertino_inhalt", "concertino_category", column: "category", name: "concertino_inhalt_ibfk_1", on_update: :cascade
  add_foreign_key "concerts", "bundeslaender", column: "bland", name: "concerts_ibfk_6"
  add_foreign_key "courses", "bundeslaender", column: "bland", name: "courses_ibfk_1"
  add_foreign_key "courses", "festivals", column: "fk_festival", name: "courses_ibfk_2"
  add_foreign_key "festivals", "bundeslaender", column: "bland", name: "festivals_ibfk_3", on_update: :cascade
  add_foreign_key "gema_events", "orchestras"
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
