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

ActiveRecord::Schema[7.2].define(version: 2026_10_02_160000) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
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

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "titel"
    t.string "anrede"
    t.string "name"
    t.string "strasse"
    t.string "plz"
    t.string "telefon"
    t.string "ort"
    t.string "mobil"
    t.string "fax"
    t.string "email"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "advertisers", force: :cascade do |t|
    t.integer "advert_type"
    t.integer "contact_id_off"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "konto"
    t.string "iban"
    t.string "bic"
    t.string "customer_number"
    t.string "account_owner"
    t.boolean "direct_debit"
    t.boolean "active"
    t.integer "magazines"
  end

  create_table "board_contacts", force: :cascade do |t|
    t.integer "contact_id_off"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "bundeslaender", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "country_code", limit: 2
  end

  create_table "classifieds", force: :cascade do |t|
    t.integer "adv_type", default: 0, null: false
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "url", default: "", null: false
    t.string "object", default: "", null: false
    t.text "description", null: false
    t.date "validuntil", null: false
    t.datetime "entrydate", precision: nil, null: false
    t.datetime "confirmed", precision: nil
    t.string "ip", limit: 45, null: false
    t.boolean "visible", default: false, null: false
  end

  create_table "competition_entries", force: :cascade do |t|
    t.date "date_of_birth"
    t.integer "contact_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
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

  create_table "composers", force: :cascade do |t|
    t.string "name"
    t.string "vorname"
    t.string "gebjahr"
    t.string "sterbejahr"
    t.boolean "ca_geb"
    t.boolean "ca_sterb"
    t.integer "fk_ref_komp_id"
    t.string "comment"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "link"
    t.index ["fk_ref_komp_id"], name: "index_composers_on_fk_ref_komp_id"
  end

  create_table "concerts", force: :cascade do |t|
    t.date "datum"
    t.time "zeit"
    t.datetime "reported", precision: nil
    t.datetime "confirmed", precision: nil
    t.string "token"
    t.string "stadt"
    t.string "titel"
    t.string "ort"
    t.integer "festival_id"
    t.string "interpret"
    t.string "homepage"
    t.string "comment"
    t.integer "bland_id"
    t.integer "land_id"
    t.string "email"
    t.string "url"
    t.float "eintritt"
    t.integer "owner_id"
    t.boolean "visible"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "orchestra_id"
    t.string "uid"
    t.string "country_code", limit: 2
    t.datetime "concert_date", precision: nil
    t.integer "mglnr"
    t.index ["uid"], name: "index_concerts_on_uid", unique: true
  end

  create_table "contact_events", force: :cascade do |t|
    t.string "event_type"
    t.datetime "event_date", precision: nil
    t.string "event_id"
    t.integer "contact_id"
    t.string "comment"
    t.string "filename"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "contact_people", force: :cascade do |t|
    t.string "salutation"
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "zip"
    t.string "city"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "country_code", limit: 2
    t.integer "festival_application_id"
    t.index ["festival_application_id"], name: "index_contact_people_on_festival_application_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "subtype", limit: 50, null: false
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

  create_table "contests", force: :cascade do |t|
    t.date "startdate"
    t.date "enddate"
    t.string "titel"
    t.string "beschreibung"
    t.string "gebuehr"
    t.string "preis"
    t.string "anmeldung"
    t.string "email"
    t.datetime "deadline", precision: nil
    t.datetime "confirmed", precision: nil
    t.datetime "reported", precision: nil
    t.boolean "visible"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "ccode"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "startdate", precision: nil, null: false
    t.datetime "enddate", precision: nil, null: false
    t.datetime "reported", precision: nil, null: false
    t.datetime "confirmed", precision: nil
    t.integer "bland", limit: 8, null: false
    t.integer "fk_festival", limit: 8, default: 0
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
  end

  create_table "distinctions", force: :cascade do |t|
    t.date "dist_date"
    t.integer "certificates"
    t.integer "honorletters"
    t.integer "medals"
    t.integer "orchestra_id_old"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
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

  create_table "ensemble_concerts", force: :cascade do |t|
    t.datetime "datum", precision: nil, null: false
    t.time "zeit", default: "2000-01-01 00:00:00", null: false
    t.datetime "reported", precision: nil, null: false
    t.datetime "confirmed", precision: nil
    t.string "stadt", default: "", null: false
    t.string "ort", default: "", null: false
    t.integer "festival_id", limit: 8, default: 0, null: false
    t.integer "ensemble_id", limit: 8, default: 0, null: false
    t.text "titel", null: false
    t.string "comment", default: "", null: false
    t.decimal "eintritt", precision: 10, null: false
    t.integer "state_id", limit: 8, null: false
    t.integer "country_id", limit: 8, default: 0, null: false
    t.string "email", default: "", null: false
    t.integer "fk_owner", limit: 8, default: 1, null: false
    t.integer "visible", limit: 2, default: 0, null: false
    t.text "url", null: false
    t.string "country_code", limit: 2
    t.index ["country_id"], name: "land"
    t.index ["datum", "zeit", "ensemble_id"], name: "unique_event", unique: true
    t.index ["ensemble_id"], name: "ensemble_id"
    t.index ["fk_owner"], name: "fk_owner"
    t.index ["state_id"], name: "bundesland"
  end

  create_table "ensembles", force: :cascade do |t|
    t.string "name"
    t.string "homepage"
    t.string "beschreibung"
    t.string "email"
    t.integer "owner_id"
    t.boolean "visible"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "mglnr"
  end

  create_table "event_cards", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
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
    t.integer "festival_year"
    t.string "checkout_reference"
    t.string "checkout_id"
    t.string "payment_method"
    t.string "iban"
    t.string "bic"
    t.string "account_owner"
    t.string "bank_name"
    t.string "invoice_id"
    t.string "transaction_code"
    t.integer "order_state"
    t.string "storno_invoice_id"
  end

  create_table "event_meals", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "participant_id"
    t.datetime "arrival_time", precision: nil
    t.integer "festival_year"
    t.integer "lunch1"
    t.integer "dinner1"
    t.integer "lunch2"
    t.integer "dinner2"
    t.integer "lunch3"
    t.integer "dinner3"
  end

  create_table "feature_requests", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "priority"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
    t.integer "user_id"
  end

  create_table "festival_applications", force: :cascade do |t|
    t.integer "orchestra_id"
    t.text "orch_name"
    t.text "conductor"
    t.integer "num_players"
    t.text "equipment"
    t.text "special_cast"
    t.integer "contact_person_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "group_type"
    t.string "uuid"
    t.boolean "permission"
    t.integer "festival_concert_id"
    t.datetime "rehearsal_time"
    t.string "visitor_type"
    t.string "country_code", limit: 2
    t.string "payment_status", limit: 1, default: "N"
    t.integer "tickets"
    t.integer "tickets_red"
    t.integer "bdz_tickets"
    t.integer "bdz_tickets_red"
    t.float "amount"
    t.integer "soloist_tickets"
    t.datetime "stage_time"
    t.string "contact_phone"
    t.integer "festival_year"
    t.string "token"
    t.string "comment"
    t.text "workshop_request"
    t.integer "year"
    t.boolean "confirmed"
    t.string "fee_invoice_id"
    t.string "ticket_invoice_id"
    t.integer "outdoor_concert_id"
    t.integer "program_item"
    t.integer "stage_timeslot"
    t.string "storno_invoice_id"
    t.index ["outdoor_concert_id"], name: "index_festival_applications_on_outdoor_concert_id"
  end

  create_table "festival_concerts", force: :cascade do |t|
    t.string "location"
    t.datetime "event_time", precision: nil
    t.integer "number"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "title"
    t.boolean "outdoor"
    t.string "concert_type"
    t.string "concert_id"
    t.string "subtitle"
  end

  create_table "festival_exhibitors", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "special_tariff", default: 0
    t.float "special_amount", default: 0.0
    t.integer "tariff"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "item_text"
    t.integer "advert_type"
    t.integer "rollups"
    t.integer "extra_tables"
    t.string "invoice_id"
    t.string "storno_invoice_id"
  end

  create_table "festival_pieces", force: :cascade do |t|
    t.integer "festival_application_id"
    t.string "composer"
    t.string "title"
    t.string "duration_txt"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "arranger"
    t.text "publisher"
    t.text "soloist"
    t.boolean "premiere"
    t.time "duration"
    t.boolean "outdoor"
  end

  create_table "festivals", force: :cascade do |t|
    t.date "startdate"
    t.date "enddate"
    t.integer "land_id"
    t.integer "bland_id"
    t.string "name"
    t.string "description"
    t.string "anmeldung"
    t.string "gebuehren"
    t.string "stadt"
    t.string "homepage"
    t.string "ort"
    t.string "ortdetails"
    t.integer "owner_id"
    t.boolean "visible"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "country_code", limit: 2
  end

  create_table "functions", force: :cascade do |t|
    t.string "label"
    t.integer "regional_organization_id"
    t.integer "address_id"
    t.boolean "bund"
    t.boolean "jugend"
    t.integer "nr"
    t.string "funktion"
    t.string "fktSubtitle"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "gema_events", force: :cascade do |t|
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
    t.integer "orchestra_id", null: false
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

  create_table "homepages", force: :cascade do |t|
    t.string "abbrev", limit: 20
    t.string "mitglnr", limit: 6
    t.string "name", limit: 100
    t.string "kontakt"
    t.string "proben"
    t.string "descr"
    t.datetime "created", precision: nil
    t.date "lastchange"
    t.string "redir_url"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "honor_members", force: :cascade do |t|
    t.integer "nr"
    t.string "vorname"
    t.string "name"
    t.string "ort"
    t.string "honorType"
    t.date "honorDate"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "deceased"
    t.string "title"
  end

  create_table "magazine_adverts", force: :cascade do |t|
    t.integer "advertiser_id"
    t.integer "magazine_issue_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "magazine_issues", force: :cascade do |t|
    t.integer "year"
    t.integer "number"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "magazine_samplings", force: :cascade do |t|
    t.integer "count"
    t.integer "contact_id_off"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "inactive", default: false
  end

  create_table "member_account_bookings", force: :cascade do |t|
    t.integer "member_id", null: false
    t.string "booking_type", null: false
    t.integer "booking_year", null: false
    t.string "booking_mode", limit: 1, null: false
    t.datetime "booking_date", precision: nil, null: false
    t.string "booking_txt", null: false
    t.string "filename", limit: 100
    t.float "amount", null: false
    t.integer "ref_booking_id"
    t.string "invoice_id"
    t.index ["member_id"], name: "index_member_account_bookings_on_member_id"
    t.index ["ref_booking_id"], name: "index_member_account_bookings_on_ref_booking_id"
  end

  create_table "member_events", force: :cascade do |t|
    t.string "event_type"
    t.datetime "event_date", precision: nil
    t.string "event_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "member_id"
    t.string "comment"
    t.string "filename"
  end

  create_table "members", force: :cascade do |t|
    t.string "subtype", limit: 50, null: false
    t.integer "regional_organization_id", limit: 8, null: false
    t.integer "mglnr", limit: 8, null: false
    t.string "anrede", limit: 20, null: false
    t.string "vorname", limit: 100, null: false
    t.string "name", limit: 100, null: false
    t.string "strasse", limit: 50, null: false
    t.string "plz", limit: 20, null: false
    t.string "ort", limit: 50, null: false
    t.string "email", limit: 100
    t.date "eintritt", null: false
    t.date "austritt_zum"
    t.string "za", limit: 1, null: false
    t.integer "konto", limit: 8
    t.string "blz", limit: 8
    t.string "zahler", limit: 100
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "telefon"
    t.string "fax"
    t.string "bic"
    t.string "iban"
    t.string "country_code", limit: 2
    t.string "title"
    t.string "member_entity_type"
    t.integer "member_entity_id"
    t.datetime "deleted_at", precision: nil
    t.boolean "deleted"
    t.boolean "dsgvo"
    t.datetime "dsgvo_date", precision: nil
    t.date "sepa_date"
    t.string "sepa_mandate_nr"
    t.integer "magazines", default: -1, null: false
    t.index ["deleted_at"], name: "index_members_on_deleted_at"
    t.index ["mglnr"], name: "mglnr", unique: true
  end

  create_table "orchestra_contacts", force: :cascade do |t|
    t.integer "orchestra_id_old"
    t.string "salutation"
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "zip"
    t.string "city"
    t.string "role"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "country_code"
    t.integer "orchestra_id"
    t.index ["orchestra_id_old"], name: "index_orchestra_contacts_on_orchestra_id_old"
  end

  create_table "orchestra_members", force: :cascade do |t|
    t.integer "orchestra_id_old"
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "instrument"
    t.integer "mglnr"
    t.integer "orchestra_id"
    t.index ["orchestra_id_old"], name: "index_orchestra_members_on_orchestra_id_old"
  end

  create_table "orchestras", force: :cascade do |t|
    t.string "orchName"
    t.string "land"
    t.date "gruendung"
    t.string "bemerkung"
    t.string "url"
    t.boolean "kuendigungErfasst"
    t.string "zweitanschrift"
    t.string "name2"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "member_id_off"
    t.string "orch_type"
    t.datetime "deleted_at", precision: nil
    t.string "gema_kdnr"
    t.boolean "publish_url", default: true
    t.boolean "publish_address", default: false
    t.string "gema_kdnr_new"
    t.date "promusica"
    t.integer "ztg_override", default: 0, null: false
    t.index ["deleted_at"], name: "index_orchestras_on_deleted_at"
  end

  create_table "passkeys", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "label", null: false
    t.string "external_id", null: false
    t.text "public_key", null: false
    t.integer "sign_count", default: 0, null: false
    t.datetime "last_used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_passkeys_on_external_id", unique: true
    t.index ["user_id", "label"], name: "index_passkeys_on_user_id_and_label", unique: true
    t.index ["user_id"], name: "index_passkeys_on_user_id"
  end

  create_table "person_members", force: :cascade do |t|
    t.date "geburtstag"
    t.string "telefonDienstl"
    t.integer "lv"
    t.integer "tariff_id"
    t.string "bemerkung"
    t.date "kuendigungVom"
    t.decimal "beitrag"
    t.boolean "lastschriftErfasst"
    t.boolean "rechnungsDruck"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "member_id_off"
    t.datetime "deleted_at", precision: nil
    t.index ["deleted_at"], name: "index_person_members_on_deleted_at"
  end

  create_table "regional_organization_bookings", force: :cascade do |t|
    t.integer "regional_organization_id"
    t.string "booking_type"
    t.integer "booking_year"
    t.string "booking_mode"
    t.datetime "booking_date", precision: nil
    t.string "booking_txt"
    t.string "filename"
    t.float "amount"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["regional_organization_id"], name: "index_regional_organization_bookings_on_regional_organization_id"
  end

  create_table "regional_organizations", force: :cascade do |t|
    t.integer "nummer"
    t.string "name"
    t.string "subname"
    t.string "homepage"
    t.string "jugend_url"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "iban"
    t.string "bic"
    t.string "gema_kdnr"
    t.string "gema_kdnr_new"
  end

  create_table "report_sheet_inputs", force: :cascade do |t|
    t.integer "report_sheet_id"
    t.integer "orchestra_id_old"
    t.string "token"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "admin_flag"
    t.integer "orchestra_id"
    t.boolean "locked"
    t.index ["orchestra_id_old"], name: "index_report_sheet_inputs_on_orchestra_id_old"
    t.index ["report_sheet_id"], name: "index_report_sheet_inputs_on_report_sheet_id"
  end

  create_table "report_sheets", force: :cascade do |t|
    t.integer "year"
    t.integer "orchestra_id_old"
    t.integer "children"
    t.integer "teens"
    t.integer "youth"
    t.integer "adult"
    t.boolean "uv"
    t.integer "gema"
    t.integer "azubi"
    t.integer "passive"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "child_ens", default: 0, null: false
    t.integer "youth_ens", default: 0, null: false
    t.integer "adult_ens", default: 0, null: false
    t.integer "senior_ens", default: 0, null: false
    t.integer "chamber_ens", default: 0, null: false
    t.integer "other_ens", default: 0, null: false
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
    t.boolean "invoiced"
    t.string "comment"
    t.boolean "generated"
    t.integer "korr_ztg"
    t.integer "senior"
    t.integer "zusatz_uv"
    t.integer "zusatz_ztg"
    t.integer "orchestra_id"
    t.integer "ms_total"
    t.integer "reminder_level", default: 0
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "runtime_options", force: :cascade do |t|
    t.string "key", null: false
    t.boolean "bool_value"
    t.datetime "datetime_value"
    t.string "string_value"
    t.string "value_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "integer_value"
    t.index ["key"], name: "index_runtime_options_on_key", unique: true
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.integer "country_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["country_id"], name: "index_states_on_country_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "account"
    t.string "bic"
    t.integer "contact_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "tariffs", force: :cascade do |t|
    t.integer "tariff_type"
    t.string "description"
    t.float "amount"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "tag"
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.string "institut"
    t.string "strasse"
    t.string "plz"
    t.string "ort"
    t.integer "land_id"
    t.string "telefon"
    t.string "studiengang"
    t.string "dozent"
    t.string "email"
    t.string "homepage"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "country_code", limit: 2
    t.string "state"
    t.string "instrument"
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string "filename"
    t.integer "report_sheet_input_id"
    t.integer "correct_ds"
    t.integer "faulty_ds"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "uploads", force: :cascade do |t|
    t.string "upload_file_name"
    t.string "upload_content_type"
    t.integer "upload_file_size"
    t.datetime "upload_updated_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "url_categories", force: :cascade do |t|
    t.integer "parent_id"
    t.boolean "leaf"
    t.boolean "hascountry"
    t.string "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "urls", force: :cascade do |t|
    t.integer "category_id"
    t.string "url"
    t.string "titel"
    t.string "descr"
    t.string "sprache"
    t.integer "land_id"
    t.string "state"
    t.string "user"
    t.string "email"
    t.datetime "lastchange", precision: nil
    t.datetime "confirmed", precision: nil
    t.boolean "visible"
    t.string "ip"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "country_code", limit: 2
    t.index ["state"], name: "index_urls_on_state"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "authentication_token"
    t.string "entity_class"
    t.integer "entity_id"
    t.string "name"
    t.string "webauthn_id"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["entity_class", "entity_id"], name: "index_users_on_entity_class_and_entity_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["webauthn_id"], name: "index_users_on_webauthn_id", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "festival_applications", "festival_concerts", column: "outdoor_concert_id"
  add_foreign_key "gema_events", "orchestras"
  add_foreign_key "passkeys", "users"
end
