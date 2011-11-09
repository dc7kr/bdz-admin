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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "addresses", :force => true do |t|
    t.string "anrede",  :limit => 10, :null => false
    t.string "titel",   :limit => 10, :null => false
    t.string "vorname", :limit => 50, :null => false
    t.string "name",    :limit => 50, :null => false
    t.string "strasse", :limit => 50, :null => false
    t.string "plz",     :limit => 10, :null => false
    t.string "ort",     :limit => 50, :null => false
    t.string "telefon", :limit => 50, :null => false
    t.string "mobil",   :limit => 50, :null => false
    t.string "fax",     :limit => 50, :null => false
    t.string "email",   :limit => 50, :null => false
  end

  add_index "addresses", ["vorname", "name"], :name => "fullname", :unique => true

  create_table "be_groups", :primary_key => "uid", :force => true do |t|
    t.integer "pid",                              :default => 0,     :null => false
    t.integer "tstamp",                           :default => 0,     :null => false
    t.string  "title",              :limit => 50, :default => "",    :null => false
    t.text    "non_exclude_fields"
    t.text    "explicit_allowdeny"
    t.string  "allowed_languages",                :default => "",    :null => false
    t.text    "custom_options"
    t.string  "db_mountpoints",                   :default => "",    :null => false
    t.string  "pagetypes_select",                 :default => "",    :null => false
    t.text    "tables_select"
    t.text    "tables_modify"
    t.integer "crdate",                           :default => 0,     :null => false
    t.integer "cruser_id",                        :default => 0,     :null => false
    t.text    "groupMods"
    t.string  "file_mountpoints",                 :default => "",    :null => false
    t.boolean "hidden",                           :default => false, :null => false
    t.integer "inc_access_lists",   :limit => 1,  :default => 0,     :null => false
    t.text    "description"
    t.string  "lockToDomain",       :limit => 50, :default => "",    :null => false
    t.boolean "deleted",                          :default => false, :null => false
    t.text    "TSconfig"
    t.string  "subgroup",                         :default => "",    :null => false
    t.integer "hide_in_lists",      :limit => 1,  :default => 0,     :null => false
    t.integer "workspace_perms",    :limit => 1,  :default => 1,     :null => false
    t.integer "fileoper_perms",     :limit => 1,  :default => 0,     :null => false
  end

  add_index "be_groups", ["pid"], :name => "parent"

  create_table "be_sessions", :id => false, :force => true do |t|
    t.string  "ses_id",         :limit => 32,         :default => "", :null => false
    t.string  "ses_name",       :limit => 32,         :default => "", :null => false
    t.string  "ses_iplock",     :limit => 39,         :default => "", :null => false
    t.integer "ses_hashlock",                         :default => 0,  :null => false
    t.integer "ses_userid",                           :default => 0,  :null => false
    t.integer "ses_tstamp",                           :default => 0,  :null => false
    t.text    "ses_data",       :limit => 2147483647
    t.integer "ses_backuserid",                       :default => 0,  :null => false
  end

  create_table "be_users", :primary_key => "uid", :force => true do |t|
    t.integer "pid",                                 :default => 0,     :null => false
    t.integer "tstamp",                              :default => 0,     :null => false
    t.string  "username",              :limit => 50, :default => "",    :null => false
    t.string  "password",              :limit => 40, :default => "",    :null => false
    t.integer "admin",                 :limit => 1,  :default => 0,     :null => false
    t.string  "usergroup",                           :default => "",    :null => false
    t.boolean "disable",                             :default => false, :null => false
    t.integer "starttime",                           :default => 0,     :null => false
    t.integer "endtime",                             :default => 0,     :null => false
    t.string  "lang",                  :limit => 2,  :default => "",    :null => false
    t.string  "email",                 :limit => 80, :default => "",    :null => false
    t.string  "db_mountpoints",                      :default => "",    :null => false
    t.integer "options",               :limit => 1,  :default => 0,     :null => false
    t.integer "crdate",                              :default => 0,     :null => false
    t.integer "cruser_id",                           :default => 0,     :null => false
    t.string  "realName",              :limit => 80, :default => "",    :null => false
    t.string  "userMods",                            :default => "",    :null => false
    t.string  "allowed_languages",                   :default => "",    :null => false
    t.text    "uc"
    t.string  "file_mountpoints",                    :default => "",    :null => false
    t.integer "fileoper_perms",        :limit => 1,  :default => 0,     :null => false
    t.integer "workspace_perms",       :limit => 1,  :default => 1,     :null => false
    t.string  "lockToDomain",          :limit => 50, :default => "",    :null => false
    t.boolean "disableIPlock",                       :default => false, :null => false
    t.boolean "deleted",                             :default => false, :null => false
    t.text    "TSconfig"
    t.integer "lastlogin",                           :default => 0,     :null => false
    t.integer "createdByAction",                     :default => 0,     :null => false
    t.string  "usergroup_cached_list",               :default => "",    :null => false
    t.integer "workspace_id",                        :default => 0,     :null => false
    t.integer "workspace_preview",     :limit => 1,  :default => 1,     :null => false
  end

  add_index "be_users", ["pid"], :name => "parent"
  add_index "be_users", ["username"], :name => "username"

  create_table "blacklist", :force => true do |t|
    t.string   "ip",          :limit => 16, :null => false
    t.datetime "blacklisted",               :null => false
  end

  add_index "blacklist", ["ip"], :name => "ip", :unique => true

  create_table "bundeslaender", :force => true do |t|
    t.integer "land", :limit => 8, :default => 0, :null => false
    t.string  "name",                             :null => false
  end

  add_index "bundeslaender", ["land"], :name => "land"

  create_table "cachingframework_cache_hash", :force => true do |t|
    t.string  "identifier", :limit => 128,      :default => "", :null => false
    t.integer "crdate",                         :default => 0,  :null => false
    t.text    "content",    :limit => 16777215
    t.integer "lifetime",                       :default => 0,  :null => false
  end

  add_index "cachingframework_cache_hash", ["identifier"], :name => "cache_id"

  create_table "cachingframework_cache_hash_tags", :force => true do |t|
    t.string "identifier", :limit => 128, :default => "", :null => false
    t.string "tag",        :limit => 128, :default => "", :null => false
  end

  add_index "cachingframework_cache_hash_tags", ["identifier"], :name => "cache_id"
  add_index "cachingframework_cache_hash_tags", ["tag"], :name => "cache_tag"

  create_table "cachingframework_cache_pages", :force => true do |t|
    t.string  "identifier", :limit => 128,      :default => "", :null => false
    t.integer "crdate",                         :default => 0,  :null => false
    t.text    "content",    :limit => 16777215
    t.integer "lifetime",                       :default => 0,  :null => false
  end

  add_index "cachingframework_cache_pages", ["identifier"], :name => "cache_id"

  create_table "cachingframework_cache_pages_tags", :force => true do |t|
    t.string "identifier", :limit => 128, :default => "", :null => false
    t.string "tag",        :limit => 128, :default => "", :null => false
  end

  add_index "cachingframework_cache_pages_tags", ["identifier"], :name => "cache_id"
  add_index "cachingframework_cache_pages_tags", ["tag"], :name => "cache_tag"

  create_table "cachingframework_cache_pagesection", :force => true do |t|
    t.string  "identifier", :limit => 128,      :default => "", :null => false
    t.integer "crdate",                         :default => 0,  :null => false
    t.text    "content",    :limit => 16777215
    t.integer "lifetime",                       :default => 0,  :null => false
  end

  add_index "cachingframework_cache_pagesection", ["identifier"], :name => "cache_id"

  create_table "cachingframework_cache_pagesection_tags", :force => true do |t|
    t.string "identifier", :limit => 128, :default => "", :null => false
    t.string "tag",        :limit => 128, :default => "", :null => false
  end

  add_index "cachingframework_cache_pagesection_tags", ["identifier"], :name => "cache_id"
  add_index "cachingframework_cache_pagesection_tags", ["tag"], :name => "cache_tag"

  create_table "concertino_category", :force => true do |t|
    t.string "title", :null => false
  end

  create_table "concertino_inhalt", :force => true do |t|
    t.integer "year",                   :null => false
    t.integer "volume",                 :null => false
    t.integer "category", :limit => 8,  :null => false
    t.string  "title",                  :null => false
    t.string  "subtitle",               :null => false
    t.string  "author",                 :null => false
    t.string  "page",     :limit => 10, :null => false
  end

  add_index "concertino_inhalt", ["category"], :name => "category"

  create_table "country", :force => true do |t|
    t.string "name",               :default => "", :null => false
    t.string "ccode", :limit => 5, :default => "", :null => false
  end

  add_index "country", ["name"], :name => "name", :unique => true

  create_table "dboerse_addr", :force => true do |t|
    t.integer "fk_bland_id", :limit => 8,   :null => false
    t.string  "vorname",     :limit => 100, :null => false
    t.string  "name",        :limit => 100, :null => false
    t.string  "gebjahr",     :limit => 100, :null => false
    t.text    "bereich",                    :null => false
    t.string  "homepage",    :limit => 100, :null => false
    t.string  "email",       :limit => 100, :null => false
    t.string  "telefon",     :limit => 100, :null => false
    t.string  "fax",         :limit => 100, :null => false
    t.text    "tmp_quali",                  :null => false
    t.text    "tmp_bland",                  :null => false
  end

  create_table "dboerse_addr2cat", :force => true do |t|
    t.integer "fk_addr_id",    :limit => 8, :null => false
    t.integer "fk_bereich_id", :limit => 8, :null => false
  end

  create_table "dboerse_addr2instr", :force => true do |t|
    t.integer "fk_addr_id",  :limit => 8, :null => false
    t.integer "fk_instr_id", :limit => 8, :null => false
  end

  add_index "dboerse_addr2instr", ["fk_addr_id"], :name => "fk_addr_id"
  add_index "dboerse_addr2instr", ["fk_instr_id"], :name => "fk_instr_id"

  create_table "dboerse_addr2quali", :force => true do |t|
    t.integer "fk_addr_id",  :limit => 8, :null => false
    t.integer "fk_quali_id", :limit => 8, :null => false
  end

  create_table "dboerse_cat", :force => true do |t|
    t.string "category", :limit => 100, :null => false
  end

  create_table "dboerse_instr", :force => true do |t|
    t.string "instrument", :limit => 100, :null => false
  end

  create_table "dboerse_quali", :force => true do |t|
    t.string "qualification", :limit => 100, :null => false
  end

  create_table "ensembles", :force => true do |t|
    t.string  "name",                      :default => "", :null => false
    t.string  "homepage",                  :default => "", :null => false
    t.string  "beschreibung",              :default => "", :null => false
    t.string  "email",                     :default => "", :null => false
    t.integer "owner",        :limit => 8,                 :null => false
    t.integer "visible",      :limit => 2, :default => 0,  :null => false
  end

  add_index "ensembles", ["owner"], :name => "owner"

  create_table "evt_cards", :force => true do |t|
    t.datetime "orderdate",                                     :null => false
    t.string   "name",            :limit => 100,                :null => false
    t.string   "email",           :limit => 100,                :null => false
    t.string   "carddata",                                      :null => false
    t.integer  "nr_fest",                        :default => 0, :null => false
    t.integer  "nr_fest_erm",                    :default => 0, :null => false
    t.integer  "nr_fest_bdz",                    :default => 0, :null => false
    t.integer  "nr_fest_bdz_erm",                :default => 0, :null => false
    t.integer  "nr_do",                          :default => 0, :null => false
    t.integer  "nr_do_erm",                      :default => 0, :null => false
    t.integer  "nr_fr",                          :default => 0, :null => false
    t.integer  "nr_fr_erm",                      :default => 0, :null => false
    t.integer  "nr_sa",                          :default => 0, :null => false
    t.integer  "nr_sa_erm",                      :default => 0, :null => false
  end

  create_table "evt_food", :force => true do |t|
    t.integer  "tln",       :null => false
    t.integer  "veg",       :null => false
    t.string   "name",      :null => false
    t.string   "email",     :null => false
    t.datetime "orderdate", :null => false
  end

  create_table "festivals", :force => true do |t|
    t.date    "startdate",                                   :null => false
    t.date    "enddate",                                     :null => false
    t.integer "bland",       :limit => 8,                    :null => false
    t.integer "land",        :limit => 8,                    :null => false
    t.string  "name",                     :default => "",    :null => false
    t.text    "description",                                 :null => false
    t.text    "anmeldung",                                   :null => false
    t.text    "gebuehren",                                   :null => false
    t.string  "stadt",                    :default => "",    :null => false
    t.string  "homepage",                 :default => "",    :null => false
    t.string  "ort",                      :default => "",    :null => false
    t.text    "ortdetails",                                  :null => false
    t.boolean "visible",                  :default => false, :null => false
  end

  add_index "festivals", ["bland"], :name => "bland"
  add_index "festivals", ["land"], :name => "land"

  create_table "functions", :force => true do |t|
    t.string  "label",        :limit => 10
    t.integer "fk_lv_id",     :limit => 8,  :null => false
    t.integer "fk_addr_id",   :limit => 8,  :null => false
    t.boolean "bund",                       :null => false
    t.boolean "jugend",                     :null => false
    t.integer "nr",                         :null => false
    t.string  "funktion",     :limit => 50, :null => false
    t.text    "fkt_subtitle",               :null => false
  end

  add_index "functions", ["fk_addr_id"], :name => "fk_addr_id"
  add_index "functions", ["fk_lv_id", "fk_addr_id"], :name => "fk_lv_id"

  create_table "gallery2_AccessMap", :id => false, :force => true do |t|
    t.integer "g_accessListId",  :null => false
    t.integer "g_userOrGroupId", :null => false
    t.integer "g_permission",    :null => false
  end

  add_index "gallery2_AccessMap", ["g_accessListId"], :name => "gallery2_AccessMap_83732"
  add_index "gallery2_AccessMap", ["g_permission"], :name => "gallery2_AccessMap_18058"
  add_index "gallery2_AccessMap", ["g_userOrGroupId"], :name => "gallery2_AccessMap_48775"

  create_table "gallery2_AccessSubscriberMap", :primary_key => "g_itemId", :force => true do |t|
    t.integer "g_accessListId", :null => false
  end

  add_index "gallery2_AccessSubscriberMap", ["g_accessListId"], :name => "gallery2_AccessSubscriberMap_83732"

  create_table "gallery2_AlbumItem", :primary_key => "g_id", :force => true do |t|
    t.string "g_theme",          :limit => 32
    t.string "g_orderBy",        :limit => 128
    t.string "g_orderDirection", :limit => 32
  end

  create_table "gallery2_AnimationItem", :primary_key => "g_id", :force => true do |t|
    t.integer "g_width"
    t.integer "g_height"
  end

  create_table "gallery2_CacheMap", :id => false, :force => true do |t|
    t.string  "g_key",       :limit => 32,         :null => false
    t.text    "g_value",     :limit => 2147483647
    t.integer "g_userId",                          :null => false
    t.integer "g_itemId",                          :null => false
    t.string  "g_type",      :limit => 32,         :null => false
    t.integer "g_timestamp",                       :null => false
    t.integer "g_isEmpty"
  end

  add_index "gallery2_CacheMap", ["g_itemId"], :name => "gallery2_CacheMap_75985"
  add_index "gallery2_CacheMap", ["g_userId", "g_timestamp", "g_isEmpty"], :name => "gallery2_CacheMap_21979"

  create_table "gallery2_ChildEntity", :primary_key => "g_id", :force => true do |t|
    t.integer "g_parentId", :null => false
  end

  add_index "gallery2_ChildEntity", ["g_parentId"], :name => "gallery2_ChildEntity_52718"

  create_table "gallery2_Comment", :primary_key => "g_id", :force => true do |t|
    t.integer "g_commenterId",                                 :null => false
    t.string  "g_host",          :limit => 128,                :null => false
    t.string  "g_subject",       :limit => 128
    t.text    "g_comment"
    t.integer "g_date",                                        :null => false
    t.string  "g_author",        :limit => 128
    t.integer "g_publishStatus",                :default => 0, :null => false
  end

  add_index "gallery2_Comment", ["g_date"], :name => "gallery2_Comment_95610"
  add_index "gallery2_Comment", ["g_publishStatus"], :name => "gallery2_Comment_70722"

  create_table "gallery2_DataItem", :primary_key => "g_id", :force => true do |t|
    t.string  "g_mimeType", :limit => 128
    t.integer "g_size"
  end

  create_table "gallery2_Derivative", :primary_key => "g_id", :force => true do |t|
    t.integer "g_derivativeSourceId",                  :null => false
    t.string  "g_derivativeOperations"
    t.integer "g_derivativeOrder",                     :null => false
    t.integer "g_derivativeSize"
    t.integer "g_derivativeType",                      :null => false
    t.string  "g_mimeType",             :limit => 128, :null => false
    t.string  "g_postFilterOperations"
    t.integer "g_isBroken"
  end

  add_index "gallery2_Derivative", ["g_derivativeOrder"], :name => "gallery2_Derivative_25243"
  add_index "gallery2_Derivative", ["g_derivativeSourceId"], :name => "gallery2_Derivative_85338"
  add_index "gallery2_Derivative", ["g_derivativeType"], :name => "gallery2_Derivative_97216"

  create_table "gallery2_DerivativeImage", :primary_key => "g_id", :force => true do |t|
    t.integer "g_width"
    t.integer "g_height"
  end

  create_table "gallery2_DerivativePrefsMap", :id => false, :force => true do |t|
    t.integer "g_itemId"
    t.integer "g_order"
    t.integer "g_derivativeType"
    t.string  "g_derivativeOperations"
  end

  add_index "gallery2_DerivativePrefsMap", ["g_itemId"], :name => "gallery2_DerivativePrefsMap_75985"

  create_table "gallery2_DescendentCountsMap", :id => false, :force => true do |t|
    t.integer "g_userId",          :null => false
    t.integer "g_itemId",          :null => false
    t.integer "g_descendentCount", :null => false
  end

  create_table "gallery2_Entity", :primary_key => "g_id", :force => true do |t|
    t.integer "g_creationTimestamp",                    :null => false
    t.integer "g_isLinkable",                           :null => false
    t.integer "g_linkId"
    t.integer "g_modificationTimestamp",                :null => false
    t.integer "g_serialNumber",                         :null => false
    t.string  "g_entityType",            :limit => 32,  :null => false
    t.string  "g_onLoadHandlers",        :limit => 128
  end

  add_index "gallery2_Entity", ["g_creationTimestamp"], :name => "gallery2_Entity_76255"
  add_index "gallery2_Entity", ["g_isLinkable"], :name => "gallery2_Entity_35978"
  add_index "gallery2_Entity", ["g_linkId"], :name => "gallery2_Entity_44738"
  add_index "gallery2_Entity", ["g_modificationTimestamp"], :name => "gallery2_Entity_63025"
  add_index "gallery2_Entity", ["g_serialNumber"], :name => "gallery2_Entity_60702"

  create_table "gallery2_EventLogMap", :primary_key => "g_id", :force => true do |t|
    t.integer "g_userId"
    t.string  "g_type",      :limit => 32
    t.string  "g_summary"
    t.text    "g_details"
    t.string  "g_location"
    t.string  "g_client",    :limit => 128
    t.integer "g_timestamp",                :null => false
    t.string  "g_referer",   :limit => 128
  end

  add_index "gallery2_EventLogMap", ["g_timestamp"], :name => "gallery2_EventLogMap_24286"

  create_table "gallery2_ExifPropertiesMap", :id => false, :force => true do |t|
    t.string  "g_property", :limit => 128
    t.integer "g_viewMode"
    t.integer "g_sequence"
  end

  add_index "gallery2_ExifPropertiesMap", ["g_property", "g_viewMode"], :name => "g_property", :unique => true

  create_table "gallery2_ExternalIdMap", :id => false, :force => true do |t|
    t.string  "g_externalId", :limit => 128, :null => false
    t.string  "g_entityType", :limit => 32,  :null => false
    t.integer "g_entityId",                  :null => false
  end

  create_table "gallery2_FactoryMap", :id => false, :force => true do |t|
    t.string "g_classType",    :limit => 128
    t.string "g_className",    :limit => 128
    t.string "g_implId",       :limit => 128
    t.string "g_implPath",     :limit => 128
    t.string "g_implModuleId", :limit => 128
    t.string "g_hints"
    t.string "g_orderWeight"
  end

  create_table "gallery2_FailedLoginsMap", :primary_key => "g_userName", :force => true do |t|
    t.integer "g_count",       :null => false
    t.integer "g_lastAttempt", :null => false
  end

  create_table "gallery2_FileSystemEntity", :primary_key => "g_id", :force => true do |t|
    t.string "g_pathComponent", :limit => 128
  end

  add_index "gallery2_FileSystemEntity", ["g_pathComponent"], :name => "gallery2_FileSystemEntity_3406"

  create_table "gallery2_Group", :primary_key => "g_id", :force => true do |t|
    t.integer "g_groupType",                :null => false
    t.string  "g_groupName", :limit => 128
  end

  add_index "gallery2_Group", ["g_groupName"], :name => "g_groupName", :unique => true

  create_table "gallery2_Item", :primary_key => "g_id", :force => true do |t|
    t.integer "g_canContainChildren",                  :null => false
    t.text    "g_description"
    t.string  "g_keywords"
    t.integer "g_ownerId",                             :null => false
    t.string  "g_renderer",             :limit => 128
    t.string  "g_summary"
    t.string  "g_title",                :limit => 128
    t.integer "g_viewedSinceTimestamp",                :null => false
    t.integer "g_originationTimestamp",                :null => false
  end

  add_index "gallery2_Item", ["g_keywords"], :name => "gallery2_Item_99070"
  add_index "gallery2_Item", ["g_ownerId"], :name => "gallery2_Item_21573"
  add_index "gallery2_Item", ["g_summary"], :name => "gallery2_Item_54147"
  add_index "gallery2_Item", ["g_title"], :name => "gallery2_Item_90059"

  create_table "gallery2_ItemAttributesMap", :primary_key => "g_itemId", :force => true do |t|
    t.integer "g_viewCount"
    t.integer "g_orderWeight"
    t.string  "g_parentSequence", :null => false
  end

  add_index "gallery2_ItemAttributesMap", ["g_parentSequence"], :name => "gallery2_ItemAttributesMap_95270"

  create_table "gallery2_Lock", :id => false, :force => true do |t|
    t.integer "g_lockId"
    t.integer "g_readEntityId"
    t.integer "g_writeEntityId"
    t.integer "g_freshUntil"
    t.integer "g_request"
  end

  add_index "gallery2_Lock", ["g_lockId"], :name => "gallery2_Lock_11039"

  create_table "gallery2_MaintenanceMap", :primary_key => "g_runId", :force => true do |t|
    t.string  "g_taskId",    :limit => 128, :null => false
    t.integer "g_timestamp"
    t.integer "g_success"
    t.text    "g_details"
  end

  add_index "gallery2_MaintenanceMap", ["g_taskId"], :name => "gallery2_MaintenanceMap_21687"

  create_table "gallery2_MimeTypeMap", :primary_key => "g_extension", :force => true do |t|
    t.string  "g_mimeType", :limit => 128, :null => false
    t.integer "g_viewable"
  end

  create_table "gallery2_MovieItem", :primary_key => "g_id", :force => true do |t|
    t.integer "g_width"
    t.integer "g_height"
    t.integer "g_duration"
  end

  create_table "gallery2_OpenIdMap", :id => false, :force => true do |t|
    t.string  "g_openId",    :limit => 128
    t.integer "g_galleryId"
  end

  create_table "gallery2_PendingUser", :primary_key => "g_id", :force => true do |t|
    t.string "g_userName",        :limit => 32,  :null => false
    t.string "g_fullName",        :limit => 128
    t.string "g_hashedPassword",  :limit => 128
    t.string "g_email",           :limit => 128
    t.string "g_language",        :limit => 128
    t.string "g_registrationKey", :limit => 32
  end

  add_index "gallery2_PendingUser", ["g_userName"], :name => "g_userName", :unique => true

  create_table "gallery2_PermissionSetMap", :primary_key => "g_permission", :force => true do |t|
    t.string  "g_module",      :limit => 128, :null => false
    t.string  "g_description"
    t.integer "g_bits",                       :null => false
    t.integer "g_flags",                      :null => false
  end

  add_index "gallery2_PermissionSetMap", ["g_permission"], :name => "g_permission", :unique => true

  create_table "gallery2_PhotoItem", :primary_key => "g_id", :force => true do |t|
    t.integer "g_width"
    t.integer "g_height"
  end

  create_table "gallery2_PluginMap", :id => false, :force => true do |t|
    t.string  "g_pluginType", :limit => 32, :null => false
    t.string  "g_pluginId",   :limit => 32, :null => false
    t.integer "g_active",                   :null => false
  end

  create_table "gallery2_PluginPackageMap", :id => false, :force => true do |t|
    t.string  "g_pluginType",     :limit => 32, :null => false
    t.string  "g_pluginId",       :limit => 32, :null => false
    t.string  "g_packageName",    :limit => 32, :null => false
    t.string  "g_packageVersion", :limit => 32, :null => false
    t.string  "g_packageBuild",   :limit => 32, :null => false
    t.integer "g_locked",                       :null => false
  end

  add_index "gallery2_PluginPackageMap", ["g_pluginType"], :name => "gallery2_PluginPackageMap_80596"

  create_table "gallery2_PluginParameterMap", :id => false, :force => true do |t|
    t.string  "g_pluginType",     :limit => 32,  :null => false
    t.string  "g_pluginId",       :limit => 32,  :null => false
    t.integer "g_itemId",                        :null => false
    t.string  "g_parameterName",  :limit => 128, :null => false
    t.text    "g_parameterValue",                :null => false
  end

  add_index "gallery2_PluginParameterMap", ["g_pluginType", "g_pluginId", "g_itemId", "g_parameterName"], :name => "g_pluginType", :unique => true
  add_index "gallery2_PluginParameterMap", ["g_pluginType", "g_pluginId", "g_itemId"], :name => "gallery2_PluginParameterMap_12808"
  add_index "gallery2_PluginParameterMap", ["g_pluginType"], :name => "gallery2_PluginParameterMap_80596"

  create_table "gallery2_RatingCacheMap", :primary_key => "g_itemId", :force => true do |t|
    t.integer "g_averageRating", :null => false
    t.integer "g_voteCount",     :null => false
  end

  create_table "gallery2_RatingMap", :primary_key => "g_ratingId", :force => true do |t|
    t.integer "g_itemId",                          :null => false
    t.integer "g_userId",                          :null => false
    t.integer "g_rating",                          :null => false
    t.string  "g_sessionId",        :limit => 128
    t.string  "g_remoteIdentifier"
  end

  add_index "gallery2_RatingMap", ["g_itemId", "g_remoteIdentifier"], :name => "gallery2_RatingMap_2369"
  add_index "gallery2_RatingMap", ["g_itemId", "g_userId"], :name => "gallery2_RatingMap_80383"
  add_index "gallery2_RatingMap", ["g_itemId"], :name => "gallery2_RatingMap_75985"

  create_table "gallery2_RecoverPasswordMap", :primary_key => "g_userName", :force => true do |t|
    t.string  "g_authString",     :limit => 32, :null => false
    t.integer "g_requestExpires",               :null => false
  end

  create_table "gallery2_Schema", :primary_key => "g_name", :force => true do |t|
    t.integer "g_major",                   :null => false
    t.integer "g_minor",                   :null => false
    t.text    "g_createSql"
    t.string  "g_pluginId",  :limit => 32
    t.string  "g_type",      :limit => 32
    t.text    "g_info"
  end

  create_table "gallery2_SequenceEventLog", :id => false, :force => true do |t|
    t.integer "id", :null => false
  end

  create_table "gallery2_SequenceId", :id => false, :force => true do |t|
    t.integer "id", :null => false
  end

  create_table "gallery2_SequenceLock", :id => false, :force => true do |t|
    t.integer "id", :null => false
  end

  create_table "gallery2_SessionMap", :primary_key => "g_id", :force => true do |t|
    t.integer "g_userId",                                      :null => false
    t.string  "g_remoteIdentifier",      :limit => 128,        :null => false
    t.integer "g_creationTimestamp",                           :null => false
    t.integer "g_modificationTimestamp",                       :null => false
    t.text    "g_data",                  :limit => 2147483647
  end

  add_index "gallery2_SessionMap", ["g_userId", "g_creationTimestamp", "g_modificationTimestamp"], :name => "gallery2_SessionMap_53500"

  create_table "gallery2_TkOperatnMap", :primary_key => "g_name", :force => true do |t|
    t.string "g_parametersCrc",  :limit => 32,  :null => false
    t.string "g_outputMimeType", :limit => 128
    t.string "g_description"
  end

  create_table "gallery2_TkOperatnMimeTypeMap", :id => false, :force => true do |t|
    t.string  "g_operationName", :limit => 128, :null => false
    t.string  "g_toolkitId",     :limit => 128, :null => false
    t.string  "g_mimeType",      :limit => 128, :null => false
    t.integer "g_priority",                     :null => false
  end

  add_index "gallery2_TkOperatnMimeTypeMap", ["g_mimeType"], :name => "gallery2_TkOperatnMimeTypeMap_79463"
  add_index "gallery2_TkOperatnMimeTypeMap", ["g_operationName"], :name => "gallery2_TkOperatnMimeTypeMap_2014"

  create_table "gallery2_TkOperatnParameterMap", :id => false, :force => true do |t|
    t.string  "g_operationName", :limit => 128, :null => false
    t.integer "g_position",                     :null => false
    t.string  "g_type",          :limit => 128, :null => false
    t.string  "g_description"
  end

  add_index "gallery2_TkOperatnParameterMap", ["g_operationName"], :name => "gallery2_TkOperatnParameterMap_2014"

  create_table "gallery2_TkPropertyMap", :id => false, :force => true do |t|
    t.string "g_name",        :limit => 128, :null => false
    t.string "g_type",        :limit => 128, :null => false
    t.string "g_description", :limit => 128, :null => false
  end

  create_table "gallery2_TkPropertyMimeTypeMap", :id => false, :force => true do |t|
    t.string "g_propertyName", :limit => 128, :null => false
    t.string "g_toolkitId",    :limit => 128, :null => false
    t.string "g_mimeType",     :limit => 128, :null => false
  end

  add_index "gallery2_TkPropertyMimeTypeMap", ["g_mimeType"], :name => "gallery2_TkPropertyMimeTypeMap_79463"
  add_index "gallery2_TkPropertyMimeTypeMap", ["g_propertyName"], :name => "gallery2_TkPropertyMimeTypeMap_52881"

  create_table "gallery2_UnknownItem", :primary_key => "g_id", :force => true do |t|
  end

  create_table "gallery2_User", :primary_key => "g_id", :force => true do |t|
    t.string  "g_userName",       :limit => 32,                 :null => false
    t.string  "g_fullName",       :limit => 128
    t.string  "g_hashedPassword", :limit => 128
    t.string  "g_email"
    t.string  "g_language",       :limit => 128
    t.integer "g_locked",                        :default => 0
  end

  add_index "gallery2_User", ["g_userName"], :name => "g_userName", :unique => true

  create_table "gallery2_UserGroupMap", :id => false, :force => true do |t|
    t.integer "g_userId",  :null => false
    t.integer "g_groupId", :null => false
  end

  add_index "gallery2_UserGroupMap", ["g_groupId"], :name => "gallery2_UserGroupMap_89328"
  add_index "gallery2_UserGroupMap", ["g_userId"], :name => "gallery2_UserGroupMap_69068"

  create_table "geo_orte", :id => false, :force => true do |t|
    t.integer "loc_id",    :limit => 8,  :null => false
    t.string  "ags",       :limit => 10, :null => false
    t.string  "ascii",     :limit => 50, :null => false
    t.string  "name",      :limit => 50, :null => false
    t.float   "lat",                     :null => false
    t.float   "lon",                     :null => false
    t.string  "amt",       :limit => 20, :null => false
    t.string  "plz",                     :null => false
    t.string  "vorwahl",   :limit => 10, :null => false
    t.string  "einwohner", :limit => 15, :null => false
    t.float   "flaeche",                 :null => false
    t.string  "kz",        :limit => 10, :null => false
    t.string  "typ",       :limit => 10, :null => false
    t.string  "level",     :limit => 10, :null => false
    t.integer "of",        :limit => 8,  :null => false
    t.string  "invalid",   :limit => 10, :null => false
  end

  add_index "geo_orte", ["loc_id"], :name => "loc_id"
  add_index "geo_orte", ["name"], :name => "name"
  add_index "geo_orte", ["of"], :name => "of"
  add_index "geo_orte", ["plz"], :name => "plz"

  create_table "guestbook", :force => true do |t|
    t.string   "name",      :limit => 50, :null => false
    t.string   "email",     :limit => 50, :null => false
    t.datetime "date",                    :null => false
    t.string   "ip",                      :null => false
    t.text     "message",                 :null => false
    t.string   "anmerkung",               :null => false
    t.datetime "confirmed",               :null => false
    t.boolean  "visible",                 :null => false
  end

  create_table "hochschulen", :force => true do |t|
    t.string  "name",                      :null => false
    t.string  "institut",                  :null => false
    t.string  "strasse",     :limit => 50, :null => false
    t.string  "plz",         :limit => 10, :null => false
    t.string  "ort",         :limit => 50, :null => false
    t.integer "land",        :limit => 8,  :null => false
    t.string  "telefon",     :limit => 50, :null => false
    t.string  "studiengang",               :null => false
    t.string  "dozent",      :limit => 50, :null => false
    t.string  "email",       :limit => 50, :null => false
    t.string  "homepage",                  :null => false
  end

  add_index "hochschulen", ["land"], :name => "land"

  create_table "homepages", :force => true do |t|
    t.string   "abbrev",     :limit => 20,  :null => false
    t.string   "mitglnr",    :limit => 6,   :null => false
    t.string   "name",       :limit => 100, :null => false
    t.text     "kontakt",                   :null => false
    t.text     "proben",                    :null => false
    t.text     "descr",                     :null => false
    t.datetime "created",                   :null => false
    t.date     "lastchange",                :null => false
    t.string   "redir_url"
  end

  create_table "jugend_artikel", :force => true do |t|
    t.string  "titel",                :null => false
    t.string  "autor",                :null => false
    t.string  "file",                 :null => false
    t.integer "jahr",                 :null => false
    t.integer "ausgabe", :limit => 1, :null => false
  end

  create_table "kleinanzeigen", :force => true do |t|
    t.integer  "type",                      :default => 0,     :null => false
    t.string   "name",                      :default => "",    :null => false
    t.string   "email",                     :default => "",    :null => false
    t.string   "url",                       :default => "",    :null => false
    t.string   "object",                    :default => "",    :null => false
    t.text     "description",                                  :null => false
    t.date     "validuntil",                                   :null => false
    t.datetime "entrydate",                                    :null => false
    t.datetime "confirmed",                                    :null => false
    t.string   "ip",          :limit => 20,                    :null => false
    t.boolean  "visible",                   :default => false, :null => false
  end

  create_table "komponisten", :force => true do |t|
    t.string  "name",        :limit => 100, :null => false
    t.string  "vorname",     :limit => 100, :null => false
    t.string  "gebjahr",     :limit => 11,  :null => false
    t.string  "sterbejahr",  :limit => 11,  :null => false
    t.boolean "ca_geb",                     :null => false
    t.boolean "ca_sterb",                   :null => false
    t.integer "fk_ref_komp", :limit => 8,   :null => false
    t.string  "comment",     :limit => 200, :null => false
  end

  create_table "konz_ensemble", :force => true do |t|
    t.date     "datum",                                                                                     :null => false
    t.time     "zeit",                                                   :default => '2000-01-01 00:00:00', :null => false
    t.datetime "reported",                                                                                  :null => false
    t.datetime "confirmed",                                                                                 :null => false
    t.string   "stadt",                                                  :default => "",                    :null => false
    t.string   "ort",                                                    :default => "",                    :null => false
    t.integer  "festival",   :limit => 8,                                :default => 0,                     :null => false
    t.integer  "interpret",  :limit => 8,                                :default => 0,                     :null => false
    t.text     "titel",                                                                                     :null => false
    t.string   "bemerkung",                                              :default => "",                    :null => false
    t.decimal  "eintritt",                :precision => 10, :scale => 0,                                    :null => false
    t.integer  "bundesland", :limit => 8,                                                                   :null => false
    t.integer  "land",       :limit => 8,                                :default => 0,                     :null => false
    t.string   "email",                                                  :default => "",                    :null => false
    t.integer  "fk_owner",   :limit => 8,                                :default => 1,                     :null => false
    t.integer  "visible",    :limit => 2,                                :default => 0,                     :null => false
    t.text     "url",                                                                                       :null => false
  end

  add_index "konz_ensemble", ["bundesland"], :name => "bundesland"
  add_index "konz_ensemble", ["datum", "zeit", "interpret"], :name => "unique_event", :unique => true
  add_index "konz_ensemble", ["fk_owner"], :name => "fk_owner"
  add_index "konz_ensemble", ["interpret"], :name => "interpret"
  add_index "konz_ensemble", ["land"], :name => "land"

  create_table "konzert2ensemble", :id => false, :force => true do |t|
    t.integer "fk_konz_id", :limit => 8, :null => false
    t.integer "fk_ens_id",  :limit => 8, :null => false
  end

  create_table "konzerte", :force => true do |t|
    t.date     "datum",                                                                                      :null => false
    t.time     "zeit",                                                    :default => '2000-01-01 00:00:00', :null => false
    t.decimal  "eintritt",                 :precision => 10, :scale => 0,                                    :null => false
    t.datetime "reported",                                                                                   :null => false
    t.datetime "confirmed",                                                                                  :null => false
    t.string   "token",      :limit => 32,                                                                   :null => false
    t.string   "stadt",                                                                                      :null => false
    t.text     "titel",                                                                                      :null => false
    t.string   "ort",                                                                                        :null => false
    t.integer  "festival",   :limit => 8,                                 :default => 0,                     :null => false
    t.string   "interpret",                                                                                  :null => false
    t.string   "url",                                                                                        :null => false
    t.string   "bemerkung",                                                                                  :null => false
    t.string   "bundesland",                                              :default => "",                    :null => false
    t.integer  "bland",      :limit => 8,                                 :default => 0,                     :null => false
    t.integer  "land",       :limit => 8,                                                                    :null => false
    t.string   "email",                                                   :default => "",                    :null => false
    t.integer  "fk_owner",   :limit => 8,                                 :default => 1,                     :null => false
    t.integer  "visible",    :limit => 2,                                 :default => 1,                     :null => false
  end

  add_index "konzerte", ["bland"], :name => "bland"
  add_index "konzerte", ["datum", "zeit", "interpret"], :name => "unique_event", :unique => true, :length => {"zeit"=>nil, "interpret"=>30, "datum"=>nil}
  add_index "konzerte", ["festival"], :name => "festival"
  add_index "konzerte", ["fk_owner"], :name => "fk_owner"
  add_index "konzerte", ["land"], :name => "land"

  create_table "kurse", :force => true do |t|
    t.datetime "startdate",                                 :null => false
    t.datetime "enddate",                                   :null => false
    t.datetime "reported",                                  :null => false
    t.datetime "confirmed",                                 :null => false
    t.integer  "bland",        :limit => 8,                 :null => false
    t.integer  "fk_festival",  :limit => 8,                 :null => false
    t.text     "more_dates",                                :null => false
    t.text     "titel",                                     :null => false
    t.string   "ort",                                       :null => false
    t.text     "beschreibung",                              :null => false
    t.text     "inhalt",                                    :null => false
    t.text     "gebuehr",                                   :null => false
    t.text     "zielgruppe",                                :null => false
    t.text     "dozenten",                                  :null => false
    t.text     "anmeldung",                                 :null => false
    t.date     "deadline",                                  :null => false
    t.string   "email",                                     :null => false
    t.string   "token",        :limit => 40,                :null => false
    t.integer  "visible",                    :default => 0, :null => false
  end

  add_index "kurse", ["bland"], :name => "bland"
  add_index "kurse", ["fk_festival"], :name => "fk_festival"

  create_table "landesverband", :force => true do |t|
    t.integer "nummer",                   :null => false
    t.string  "name",       :limit => 40, :null => false
    t.string  "subname",    :limit => 50, :null => false
    t.string  "homepage",   :limit => 50, :null => false
    t.string  "jugend_url", :limit => 50, :null => false
  end

  create_table "orte", :primary_key => "ID", :force => true do |t|
    t.string  "PLZ",         :limit => 11, :default => "-", :null => false
    t.string  "Ort",         :limit => 50, :default => "-", :null => false
    t.string  "Land",        :limit => 3,  :default => "-", :null => false
    t.integer "fk_bland_id", :limit => 8,                   :null => false
    t.string  "Vorwahl",     :limit => 12, :default => "-", :null => false
    t.string  "Staat",       :limit => 5,  :default => "-", :null => false
  end

  add_index "orte", ["Ort"], :name => "Ort"
  add_index "orte", ["PLZ"], :name => "PLZ"
  add_index "orte", ["Staat"], :name => "Staat"
  add_index "orte", ["Vorwahl"], :name => "Vorwahl"
  add_index "orte", ["fk_bland_id"], :name => "fk_bland_id"

  create_table "pages", :primary_key => "uid", :force => true do |t|
    t.integer "pid",                              :default => 0,     :null => false
    t.integer "t3ver_oid",                        :default => 0,     :null => false
    t.integer "t3ver_id",                         :default => 0,     :null => false
    t.integer "t3ver_wsid",                       :default => 0,     :null => false
    t.string  "t3ver_label",                      :default => ""
    t.integer "t3ver_state",       :limit => 1,   :default => 0,     :null => false
    t.integer "t3ver_stage",       :limit => 1,   :default => 0,     :null => false
    t.integer "t3ver_count",                      :default => 0,     :null => false
    t.integer "t3ver_tstamp",                     :default => 0,     :null => false
    t.integer "t3ver_swapmode",    :limit => 1,   :default => 0,     :null => false
    t.integer "t3ver_move_id",                    :default => 0,     :null => false
    t.integer "t3_origuid",                       :default => 0,     :null => false
    t.integer "tstamp",                           :default => 0,     :null => false
    t.integer "sorting",                          :default => 0,     :null => false
    t.boolean "deleted",                          :default => false, :null => false
    t.integer "perms_userid",                     :default => 0,     :null => false
    t.integer "perms_groupid",                    :default => 0,     :null => false
    t.integer "perms_user",        :limit => 1,   :default => 0,     :null => false
    t.integer "perms_group",       :limit => 1,   :default => 0,     :null => false
    t.integer "perms_everybody",   :limit => 1,   :default => 0,     :null => false
    t.integer "editlock",          :limit => 1,   :default => 0,     :null => false
    t.integer "crdate",                           :default => 0,     :null => false
    t.integer "cruser_id",                        :default => 0,     :null => false
    t.integer "hidden",            :limit => 1,   :default => 0,     :null => false
    t.string  "title",                            :default => "",    :null => false
    t.integer "doktype",           :limit => 1,   :default => 0,     :null => false
    t.text    "TSconfig"
    t.integer "storage_pid",                      :default => 0,     :null => false
    t.integer "is_siteroot",       :limit => 1,   :default => 0,     :null => false
    t.integer "php_tree_stop",     :limit => 1,   :default => 0,     :null => false
    t.integer "tx_impexp_origuid",                :default => 0,     :null => false
    t.string  "url",                              :default => "",    :null => false
    t.integer "starttime",                        :default => 0,     :null => false
    t.integer "endtime",                          :default => 0,     :null => false
    t.integer "urltype",           :limit => 1,   :default => 0,     :null => false
    t.integer "shortcut",                         :default => 0,     :null => false
    t.integer "shortcut_mode",                    :default => 0,     :null => false
    t.integer "no_cache",                         :default => 0,     :null => false
    t.string  "fe_group",          :limit => 100, :default => "0",   :null => false
    t.string  "subtitle",                         :default => "",    :null => false
    t.integer "layout",            :limit => 1,   :default => 0,     :null => false
    t.string  "target",            :limit => 80,  :default => ""
    t.text    "media"
    t.integer "lastUpdated",                      :default => 0,     :null => false
    t.text    "keywords"
    t.integer "cache_timeout",                    :default => 0,     :null => false
    t.integer "newUntil",                         :default => 0,     :null => false
    t.text    "description"
    t.integer "no_search",         :limit => 1,   :default => 0,     :null => false
    t.integer "SYS_LASTCHANGED",                  :default => 0,     :null => false
    t.text    "abstract"
    t.string  "module",            :limit => 10,  :default => "",    :null => false
    t.integer "extendToSubpages",  :limit => 1,   :default => 0,     :null => false
    t.string  "author",                           :default => "",    :null => false
    t.string  "author_email",      :limit => 80,  :default => "",    :null => false
    t.string  "nav_title",                        :default => "",    :null => false
    t.integer "nav_hide",          :limit => 1,   :default => 0,     :null => false
    t.integer "content_from_pid",                 :default => 0,     :null => false
    t.integer "mount_pid",                        :default => 0,     :null => false
    t.integer "mount_pid_ol",      :limit => 1,   :default => 0,     :null => false
    t.string  "alias",             :limit => 32,  :default => "",    :null => false
    t.integer "l18n_cfg",          :limit => 1,   :default => 0,     :null => false
    t.integer "fe_login_mode",     :limit => 1,   :default => 0,     :null => false
  end

  add_index "pages", ["alias"], :name => "alias"
  add_index "pages", ["pid", "sorting", "deleted", "hidden"], :name => "parent"
  add_index "pages", ["t3ver_oid", "t3ver_wsid"], :name => "t3ver_oid"

  create_table "pages_language_overlay", :primary_key => "uid", :force => true do |t|
    t.integer "pid",                                   :default => 0,  :null => false
    t.integer "t3ver_oid",                             :default => 0,  :null => false
    t.integer "t3ver_id",                              :default => 0,  :null => false
    t.integer "t3ver_wsid",                            :default => 0,  :null => false
    t.string  "t3ver_label",                           :default => ""
    t.integer "t3ver_state",       :limit => 1,        :default => 0,  :null => false
    t.integer "t3ver_stage",       :limit => 1,        :default => 0,  :null => false
    t.integer "t3ver_count",                           :default => 0,  :null => false
    t.integer "t3ver_tstamp",                          :default => 0,  :null => false
    t.integer "t3_origuid",                            :default => 0,  :null => false
    t.integer "tstamp",                                :default => 0,  :null => false
    t.integer "crdate",                                :default => 0,  :null => false
    t.integer "cruser_id",                             :default => 0,  :null => false
    t.integer "sys_language_uid",                      :default => 0,  :null => false
    t.string  "title",                                 :default => "", :null => false
    t.integer "hidden",            :limit => 1,        :default => 0,  :null => false
    t.integer "starttime",                             :default => 0,  :null => false
    t.integer "endtime",                               :default => 0,  :null => false
    t.integer "deleted",           :limit => 1,        :default => 0,  :null => false
    t.string  "subtitle",                              :default => "", :null => false
    t.string  "nav_title",                             :default => "", :null => false
    t.text    "media",             :limit => 255
    t.text    "keywords"
    t.text    "description"
    t.text    "abstract"
    t.string  "author",                                :default => "", :null => false
    t.string  "author_email",      :limit => 80,       :default => "", :null => false
    t.integer "tx_impexp_origuid",                     :default => 0,  :null => false
    t.binary  "l18n_diffsource",   :limit => 16777215
    t.integer "doktype",           :limit => 1,        :default => 0,  :null => false
    t.string  "url",                                   :default => "", :null => false
    t.integer "urltype",           :limit => 1,        :default => 0,  :null => false
    t.integer "shortcut",                              :default => 0,  :null => false
    t.integer "shortcut_mode",                         :default => 0,  :null => false
  end

  add_index "pages_language_overlay", ["pid", "sys_language_uid"], :name => "parent"
  add_index "pages_language_overlay", ["t3ver_oid", "t3ver_wsid"], :name => "t3ver_oid"

  create_table "phpbb3_acl_groups", :id => false, :force => true do |t|
    t.integer "group_id",       :limit => 3, :default => 0, :null => false
    t.integer "forum_id",       :limit => 3, :default => 0, :null => false
    t.integer "auth_option_id", :limit => 3, :default => 0, :null => false
    t.integer "auth_role_id",   :limit => 3, :default => 0, :null => false
    t.integer "auth_setting",   :limit => 1, :default => 0, :null => false
  end

  add_index "phpbb3_acl_groups", ["auth_option_id"], :name => "auth_opt_id"
  add_index "phpbb3_acl_groups", ["auth_role_id"], :name => "auth_role_id"
  add_index "phpbb3_acl_groups", ["group_id"], :name => "group_id"

  create_table "phpbb3_acl_options", :primary_key => "auth_option_id", :force => true do |t|
    t.string  "auth_option",  :limit => 50, :default => "",    :null => false
    t.boolean "is_global",                  :default => false, :null => false
    t.boolean "is_local",                   :default => false, :null => false
    t.boolean "founder_only",               :default => false, :null => false
  end

  add_index "phpbb3_acl_options", ["auth_option"], :name => "auth_option", :unique => true

  create_table "phpbb3_acl_roles", :primary_key => "role_id", :force => true do |t|
    t.string  "role_name",                      :default => "", :null => false
    t.text    "role_description",                               :null => false
    t.string  "role_type",        :limit => 10, :default => "", :null => false
    t.integer "role_order",       :limit => 2,  :default => 0,  :null => false
  end

  add_index "phpbb3_acl_roles", ["role_order"], :name => "role_order"
  add_index "phpbb3_acl_roles", ["role_type"], :name => "role_type"

  create_table "phpbb3_acl_roles_data", :id => false, :force => true do |t|
    t.integer "role_id",        :limit => 3, :default => 0, :null => false
    t.integer "auth_option_id", :limit => 3, :default => 0, :null => false
    t.integer "auth_setting",   :limit => 1, :default => 0, :null => false
  end

  add_index "phpbb3_acl_roles_data", ["auth_option_id"], :name => "ath_op_id"

  create_table "phpbb3_acl_users", :id => false, :force => true do |t|
    t.integer "user_id",        :limit => 3, :default => 0, :null => false
    t.integer "forum_id",       :limit => 3, :default => 0, :null => false
    t.integer "auth_option_id", :limit => 3, :default => 0, :null => false
    t.integer "auth_role_id",   :limit => 3, :default => 0, :null => false
    t.integer "auth_setting",   :limit => 1, :default => 0, :null => false
  end

  add_index "phpbb3_acl_users", ["auth_option_id"], :name => "auth_option_id"
  add_index "phpbb3_acl_users", ["auth_role_id"], :name => "auth_role_id"
  add_index "phpbb3_acl_users", ["user_id"], :name => "user_id"

  create_table "phpbb3_attachments", :primary_key => "attach_id", :force => true do |t|
    t.integer "post_msg_id",       :limit => 3,   :default => 0,     :null => false
    t.integer "topic_id",          :limit => 3,   :default => 0,     :null => false
    t.boolean "in_message",                       :default => false, :null => false
    t.integer "poster_id",         :limit => 3,   :default => 0,     :null => false
    t.boolean "is_orphan",                        :default => true,  :null => false
    t.string  "physical_filename",                :default => "",    :null => false
    t.string  "real_filename",                    :default => "",    :null => false
    t.integer "download_count",    :limit => 3,   :default => 0,     :null => false
    t.text    "attach_comment",                                      :null => false
    t.string  "extension",         :limit => 100, :default => "",    :null => false
    t.string  "mimetype",          :limit => 100, :default => "",    :null => false
    t.integer "filesize",                         :default => 0,     :null => false
    t.integer "filetime",                         :default => 0,     :null => false
    t.boolean "thumbnail",                        :default => false, :null => false
  end

  add_index "phpbb3_attachments", ["filetime"], :name => "filetime"
  add_index "phpbb3_attachments", ["is_orphan"], :name => "is_orphan"
  add_index "phpbb3_attachments", ["post_msg_id"], :name => "post_msg_id"
  add_index "phpbb3_attachments", ["poster_id"], :name => "poster_id"
  add_index "phpbb3_attachments", ["topic_id"], :name => "topic_id"

  create_table "phpbb3_banlist", :primary_key => "ban_id", :force => true do |t|
    t.integer "ban_userid",      :limit => 3,   :default => 0,     :null => false
    t.string  "ban_ip",          :limit => 40,  :default => "",    :null => false
    t.string  "ban_email",       :limit => 100, :default => "",    :null => false
    t.integer "ban_start",                      :default => 0,     :null => false
    t.integer "ban_end",                        :default => 0,     :null => false
    t.boolean "ban_exclude",                    :default => false, :null => false
    t.string  "ban_reason",                     :default => "",    :null => false
    t.string  "ban_give_reason",                :default => "",    :null => false
  end

  add_index "phpbb3_banlist", ["ban_email", "ban_exclude"], :name => "ban_email"
  add_index "phpbb3_banlist", ["ban_end"], :name => "ban_end"
  add_index "phpbb3_banlist", ["ban_ip", "ban_exclude"], :name => "ban_ip"
  add_index "phpbb3_banlist", ["ban_userid", "ban_exclude"], :name => "ban_user"

  create_table "phpbb3_bbcodes", :primary_key => "bbcode_id", :force => true do |t|
    t.string  "bbcode_tag",          :limit => 16,       :default => "",    :null => false
    t.string  "bbcode_helpline",                         :default => "",    :null => false
    t.boolean "display_on_posting",                      :default => false, :null => false
    t.text    "bbcode_match",                                               :null => false
    t.text    "bbcode_tpl",          :limit => 16777215,                    :null => false
    t.text    "first_pass_match",    :limit => 16777215,                    :null => false
    t.text    "first_pass_replace",  :limit => 16777215,                    :null => false
    t.text    "second_pass_match",   :limit => 16777215,                    :null => false
    t.text    "second_pass_replace", :limit => 16777215,                    :null => false
  end

  add_index "phpbb3_bbcodes", ["display_on_posting"], :name => "display_on_post"

  create_table "phpbb3_bookmarks", :id => false, :force => true do |t|
    t.integer "topic_id", :limit => 3, :default => 0, :null => false
    t.integer "user_id",  :limit => 3, :default => 0, :null => false
  end

  create_table "phpbb3_bots", :primary_key => "bot_id", :force => true do |t|
    t.boolean "bot_active",              :default => true, :null => false
    t.string  "bot_name",                :default => "",   :null => false
    t.integer "user_id",    :limit => 3, :default => 0,    :null => false
    t.string  "bot_agent",               :default => "",   :null => false
    t.string  "bot_ip",                  :default => "",   :null => false
  end

  add_index "phpbb3_bots", ["bot_active"], :name => "bot_active"

  create_table "phpbb3_config", :primary_key => "config_name", :force => true do |t|
    t.string  "config_value", :default => "",    :null => false
    t.boolean "is_dynamic",   :default => false, :null => false
  end

  add_index "phpbb3_config", ["is_dynamic"], :name => "is_dynamic"

  create_table "phpbb3_confirm", :id => false, :force => true do |t|
    t.string  "confirm_id",   :limit => 32, :default => "", :null => false
    t.string  "session_id",   :limit => 32, :default => "", :null => false
    t.integer "confirm_type", :limit => 1,  :default => 0,  :null => false
    t.string  "code",         :limit => 8,  :default => "", :null => false
    t.integer "seed",                       :default => 0,  :null => false
    t.integer "attempts",     :limit => 3,  :default => 0,  :null => false
  end

  add_index "phpbb3_confirm", ["confirm_type"], :name => "confirm_type"

  create_table "phpbb3_disallow", :primary_key => "disallow_id", :force => true do |t|
    t.string "disallow_username", :default => "", :null => false
  end

  create_table "phpbb3_drafts", :primary_key => "draft_id", :force => true do |t|
    t.integer "user_id",       :limit => 3,        :default => 0,  :null => false
    t.integer "topic_id",      :limit => 3,        :default => 0,  :null => false
    t.integer "forum_id",      :limit => 3,        :default => 0,  :null => false
    t.integer "save_time",                         :default => 0,  :null => false
    t.string  "draft_subject",                     :default => "", :null => false
    t.text    "draft_message", :limit => 16777215,                 :null => false
  end

  add_index "phpbb3_drafts", ["save_time"], :name => "save_time"

  create_table "phpbb3_extension_groups", :primary_key => "group_id", :force => true do |t|
    t.string  "group_name",                  :default => "",    :null => false
    t.integer "cat_id",         :limit => 1, :default => 0,     :null => false
    t.boolean "allow_group",                 :default => false, :null => false
    t.boolean "download_mode",               :default => true,  :null => false
    t.string  "upload_icon",                 :default => "",    :null => false
    t.integer "max_filesize",                :default => 0,     :null => false
    t.text    "allowed_forums",                                 :null => false
    t.boolean "allow_in_pm",                 :default => false, :null => false
  end

  create_table "phpbb3_extensions", :primary_key => "extension_id", :force => true do |t|
    t.integer "group_id",  :limit => 3,   :default => 0,  :null => false
    t.string  "extension", :limit => 100, :default => "", :null => false
  end

  create_table "phpbb3_forums", :primary_key => "forum_id", :force => true do |t|
    t.integer "parent_id",                :limit => 3,        :default => 0,     :null => false
    t.integer "left_id",                  :limit => 3,        :default => 0,     :null => false
    t.integer "right_id",                 :limit => 3,        :default => 0,     :null => false
    t.text    "forum_parents",            :limit => 16777215,                    :null => false
    t.string  "forum_name",                                   :default => "",    :null => false
    t.text    "forum_desc",                                                      :null => false
    t.string  "forum_desc_bitfield",                          :default => "",    :null => false
    t.integer "forum_desc_options",                           :default => 7,     :null => false
    t.string  "forum_desc_uid",           :limit => 8,        :default => "",    :null => false
    t.string  "forum_link",                                   :default => "",    :null => false
    t.string  "forum_password",           :limit => 40,       :default => "",    :null => false
    t.integer "forum_style",              :limit => 3,        :default => 0,     :null => false
    t.string  "forum_image",                                  :default => "",    :null => false
    t.text    "forum_rules",                                                     :null => false
    t.string  "forum_rules_link",                             :default => "",    :null => false
    t.string  "forum_rules_bitfield",                         :default => "",    :null => false
    t.integer "forum_rules_options",                          :default => 7,     :null => false
    t.string  "forum_rules_uid",          :limit => 8,        :default => "",    :null => false
    t.integer "forum_topics_per_page",    :limit => 1,        :default => 0,     :null => false
    t.integer "forum_type",               :limit => 1,        :default => 0,     :null => false
    t.integer "forum_status",             :limit => 1,        :default => 0,     :null => false
    t.integer "forum_posts",              :limit => 3,        :default => 0,     :null => false
    t.integer "forum_topics",             :limit => 3,        :default => 0,     :null => false
    t.integer "forum_topics_real",        :limit => 3,        :default => 0,     :null => false
    t.integer "forum_last_post_id",       :limit => 3,        :default => 0,     :null => false
    t.integer "forum_last_poster_id",     :limit => 3,        :default => 0,     :null => false
    t.string  "forum_last_post_subject",                      :default => "",    :null => false
    t.integer "forum_last_post_time",                         :default => 0,     :null => false
    t.string  "forum_last_poster_name",                       :default => "",    :null => false
    t.string  "forum_last_poster_colour", :limit => 6,        :default => "",    :null => false
    t.integer "forum_flags",              :limit => 1,        :default => 32,    :null => false
    t.boolean "display_on_index",                             :default => true,  :null => false
    t.boolean "enable_indexing",                              :default => true,  :null => false
    t.boolean "enable_icons",                                 :default => true,  :null => false
    t.boolean "enable_prune",                                 :default => false, :null => false
    t.integer "prune_next",                                   :default => 0,     :null => false
    t.integer "prune_days",               :limit => 3,        :default => 0,     :null => false
    t.integer "prune_viewed",             :limit => 3,        :default => 0,     :null => false
    t.integer "prune_freq",               :limit => 3,        :default => 0,     :null => false
    t.boolean "display_subforum_list",                        :default => true,  :null => false
    t.integer "forum_options",                                :default => 0,     :null => false
  end

  add_index "phpbb3_forums", ["forum_last_post_id"], :name => "forum_lastpost_id"
  add_index "phpbb3_forums", ["left_id", "right_id"], :name => "left_right_id"

  create_table "phpbb3_forums_access", :id => false, :force => true do |t|
    t.integer "forum_id",   :limit => 3,  :default => 0,  :null => false
    t.integer "user_id",    :limit => 3,  :default => 0,  :null => false
    t.string  "session_id", :limit => 32, :default => "", :null => false
  end

  create_table "phpbb3_forums_track", :id => false, :force => true do |t|
    t.integer "user_id",   :limit => 3, :default => 0, :null => false
    t.integer "forum_id",  :limit => 3, :default => 0, :null => false
    t.integer "mark_time",              :default => 0, :null => false
  end

  create_table "phpbb3_forums_watch", :id => false, :force => true do |t|
    t.integer "forum_id",      :limit => 3, :default => 0,     :null => false
    t.integer "user_id",       :limit => 3, :default => 0,     :null => false
    t.boolean "notify_status",              :default => false, :null => false
  end

  add_index "phpbb3_forums_watch", ["forum_id"], :name => "forum_id"
  add_index "phpbb3_forums_watch", ["notify_status"], :name => "notify_stat"
  add_index "phpbb3_forums_watch", ["user_id"], :name => "user_id"

  create_table "phpbb3_groups", :primary_key => "group_id", :force => true do |t|
    t.integer "group_type",           :limit => 1, :default => 1,     :null => false
    t.boolean "group_founder_manage",              :default => false, :null => false
    t.string  "group_name",                        :default => "",    :null => false
    t.text    "group_desc",                                           :null => false
    t.string  "group_desc_bitfield",               :default => "",    :null => false
    t.integer "group_desc_options",                :default => 7,     :null => false
    t.string  "group_desc_uid",       :limit => 8, :default => "",    :null => false
    t.boolean "group_display",                     :default => false, :null => false
    t.string  "group_avatar",                      :default => "",    :null => false
    t.integer "group_avatar_type",    :limit => 1, :default => 0,     :null => false
    t.integer "group_avatar_width",   :limit => 2, :default => 0,     :null => false
    t.integer "group_avatar_height",  :limit => 2, :default => 0,     :null => false
    t.integer "group_rank",           :limit => 3, :default => 0,     :null => false
    t.string  "group_colour",         :limit => 6, :default => "",    :null => false
    t.integer "group_sig_chars",      :limit => 3, :default => 0,     :null => false
    t.boolean "group_receive_pm",                  :default => false, :null => false
    t.integer "group_message_limit",  :limit => 3, :default => 0,     :null => false
    t.boolean "group_legend",                      :default => true,  :null => false
    t.integer "group_max_recipients", :limit => 3, :default => 0,     :null => false
    t.boolean "group_skip_auth",                   :default => false, :null => false
  end

  add_index "phpbb3_groups", ["group_legend", "group_name"], :name => "group_legend_name"

  create_table "phpbb3_icons", :primary_key => "icons_id", :force => true do |t|
    t.string  "icons_url",                       :default => "",   :null => false
    t.integer "icons_width",        :limit => 1, :default => 0,    :null => false
    t.integer "icons_height",       :limit => 1, :default => 0,    :null => false
    t.integer "icons_order",        :limit => 3, :default => 0,    :null => false
    t.boolean "display_on_posting",              :default => true, :null => false
  end

  add_index "phpbb3_icons", ["display_on_posting"], :name => "display_on_posting"

  create_table "phpbb3_lang", :primary_key => "lang_id", :force => true do |t|
    t.string "lang_iso",          :limit => 30,  :default => "", :null => false
    t.string "lang_dir",          :limit => 30,  :default => "", :null => false
    t.string "lang_english_name", :limit => 100, :default => "", :null => false
    t.string "lang_local_name",                  :default => "", :null => false
    t.string "lang_author",                      :default => "", :null => false
  end

  add_index "phpbb3_lang", ["lang_iso"], :name => "lang_iso"

  create_table "phpbb3_log", :primary_key => "log_id", :force => true do |t|
    t.integer "log_type",      :limit => 1,        :default => 0,  :null => false
    t.integer "user_id",       :limit => 3,        :default => 0,  :null => false
    t.integer "forum_id",      :limit => 3,        :default => 0,  :null => false
    t.integer "topic_id",      :limit => 3,        :default => 0,  :null => false
    t.integer "reportee_id",   :limit => 3,        :default => 0,  :null => false
    t.string  "log_ip",        :limit => 40,       :default => "", :null => false
    t.integer "log_time",                          :default => 0,  :null => false
    t.text    "log_operation",                                     :null => false
    t.text    "log_data",      :limit => 16777215,                 :null => false
  end

  add_index "phpbb3_log", ["forum_id"], :name => "forum_id"
  add_index "phpbb3_log", ["log_type"], :name => "log_type"
  add_index "phpbb3_log", ["reportee_id"], :name => "reportee_id"
  add_index "phpbb3_log", ["topic_id"], :name => "topic_id"
  add_index "phpbb3_log", ["user_id"], :name => "user_id"

  create_table "phpbb3_moderator_cache", :id => false, :force => true do |t|
    t.integer "forum_id",         :limit => 3, :default => 0,    :null => false
    t.integer "user_id",          :limit => 3, :default => 0,    :null => false
    t.string  "username",                      :default => "",   :null => false
    t.integer "group_id",         :limit => 3, :default => 0,    :null => false
    t.string  "group_name",                    :default => "",   :null => false
    t.boolean "display_on_index",              :default => true, :null => false
  end

  add_index "phpbb3_moderator_cache", ["display_on_index"], :name => "disp_idx"
  add_index "phpbb3_moderator_cache", ["forum_id"], :name => "forum_id"

  create_table "phpbb3_modules", :primary_key => "module_id", :force => true do |t|
    t.boolean "module_enabled",                :default => true, :null => false
    t.boolean "module_display",                :default => true, :null => false
    t.string  "module_basename",               :default => "",   :null => false
    t.string  "module_class",    :limit => 10, :default => "",   :null => false
    t.integer "parent_id",       :limit => 3,  :default => 0,    :null => false
    t.integer "left_id",         :limit => 3,  :default => 0,    :null => false
    t.integer "right_id",        :limit => 3,  :default => 0,    :null => false
    t.string  "module_langname",               :default => "",   :null => false
    t.string  "module_mode",                   :default => "",   :null => false
    t.string  "module_auth",                   :default => "",   :null => false
  end

  add_index "phpbb3_modules", ["left_id", "right_id"], :name => "left_right_id"
  add_index "phpbb3_modules", ["module_class", "left_id"], :name => "class_left_id"
  add_index "phpbb3_modules", ["module_enabled"], :name => "module_enabled"

  create_table "phpbb3_poll_options", :id => false, :force => true do |t|
    t.integer "poll_option_id",    :limit => 1, :default => 0, :null => false
    t.integer "topic_id",          :limit => 3, :default => 0, :null => false
    t.text    "poll_option_text",                              :null => false
    t.integer "poll_option_total", :limit => 3, :default => 0, :null => false
  end

  add_index "phpbb3_poll_options", ["poll_option_id"], :name => "poll_opt_id"
  add_index "phpbb3_poll_options", ["topic_id"], :name => "topic_id"

  create_table "phpbb3_poll_votes", :id => false, :force => true do |t|
    t.integer "topic_id",       :limit => 3,  :default => 0,  :null => false
    t.integer "poll_option_id", :limit => 1,  :default => 0,  :null => false
    t.integer "vote_user_id",   :limit => 3,  :default => 0,  :null => false
    t.string  "vote_user_ip",   :limit => 40, :default => "", :null => false
  end

  add_index "phpbb3_poll_votes", ["topic_id"], :name => "topic_id"
  add_index "phpbb3_poll_votes", ["vote_user_id"], :name => "vote_user_id"
  add_index "phpbb3_poll_votes", ["vote_user_ip"], :name => "vote_user_ip"

  create_table "phpbb3_posts", :primary_key => "post_id", :force => true do |t|
    t.integer "topic_id",         :limit => 3,        :default => 0,     :null => false
    t.integer "forum_id",         :limit => 3,        :default => 0,     :null => false
    t.integer "poster_id",        :limit => 3,        :default => 0,     :null => false
    t.integer "icon_id",          :limit => 3,        :default => 0,     :null => false
    t.string  "poster_ip",        :limit => 40,       :default => "",    :null => false
    t.integer "post_time",                            :default => 0,     :null => false
    t.boolean "post_approved",                        :default => true,  :null => false
    t.boolean "post_reported",                        :default => false, :null => false
    t.boolean "enable_bbcode",                        :default => true,  :null => false
    t.boolean "enable_smilies",                       :default => true,  :null => false
    t.boolean "enable_magic_url",                     :default => true,  :null => false
    t.boolean "enable_sig",                           :default => true,  :null => false
    t.string  "post_username",                        :default => "",    :null => false
    t.string  "post_subject",                         :default => "",    :null => false
    t.text    "post_text",        :limit => 16777215,                    :null => false
    t.string  "post_checksum",    :limit => 32,       :default => "",    :null => false
    t.boolean "post_attachment",                      :default => false, :null => false
    t.string  "bbcode_bitfield",                      :default => "",    :null => false
    t.string  "bbcode_uid",       :limit => 8,        :default => "",    :null => false
    t.boolean "post_postcount",                       :default => true,  :null => false
    t.integer "post_edit_time",                       :default => 0,     :null => false
    t.string  "post_edit_reason",                     :default => "",    :null => false
    t.integer "post_edit_user",   :limit => 3,        :default => 0,     :null => false
    t.integer "post_edit_count",  :limit => 2,        :default => 0,     :null => false
    t.boolean "post_edit_locked",                     :default => false, :null => false
  end

  add_index "phpbb3_posts", ["forum_id"], :name => "forum_id"
  add_index "phpbb3_posts", ["post_approved"], :name => "post_approved"
  add_index "phpbb3_posts", ["post_subject", "post_text"], :name => "post_content"
  add_index "phpbb3_posts", ["post_subject"], :name => "post_subject"
  add_index "phpbb3_posts", ["post_text"], :name => "post_text"
  add_index "phpbb3_posts", ["post_username"], :name => "post_username"
  add_index "phpbb3_posts", ["poster_id"], :name => "poster_id"
  add_index "phpbb3_posts", ["poster_ip"], :name => "poster_ip"
  add_index "phpbb3_posts", ["topic_id", "post_time"], :name => "tid_post_time"
  add_index "phpbb3_posts", ["topic_id"], :name => "topic_id"

  create_table "phpbb3_privmsgs", :primary_key => "msg_id", :force => true do |t|
    t.integer "root_level",          :limit => 3,        :default => 0,     :null => false
    t.integer "author_id",           :limit => 3,        :default => 0,     :null => false
    t.integer "icon_id",             :limit => 3,        :default => 0,     :null => false
    t.string  "author_ip",           :limit => 40,       :default => "",    :null => false
    t.integer "message_time",                            :default => 0,     :null => false
    t.boolean "enable_bbcode",                           :default => true,  :null => false
    t.boolean "enable_smilies",                          :default => true,  :null => false
    t.boolean "enable_magic_url",                        :default => true,  :null => false
    t.boolean "enable_sig",                              :default => true,  :null => false
    t.string  "message_subject",                         :default => "",    :null => false
    t.text    "message_text",        :limit => 16777215,                    :null => false
    t.string  "message_edit_reason",                     :default => "",    :null => false
    t.integer "message_edit_user",   :limit => 3,        :default => 0,     :null => false
    t.boolean "message_attachment",                      :default => false, :null => false
    t.string  "bbcode_bitfield",                         :default => "",    :null => false
    t.string  "bbcode_uid",          :limit => 8,        :default => "",    :null => false
    t.integer "message_edit_time",                       :default => 0,     :null => false
    t.integer "message_edit_count",  :limit => 2,        :default => 0,     :null => false
    t.text    "to_address",                                                 :null => false
    t.text    "bcc_address",                                                :null => false
    t.boolean "message_reported",                        :default => false, :null => false
  end

  add_index "phpbb3_privmsgs", ["author_id"], :name => "author_id"
  add_index "phpbb3_privmsgs", ["author_ip"], :name => "author_ip"
  add_index "phpbb3_privmsgs", ["message_time"], :name => "message_time"
  add_index "phpbb3_privmsgs", ["root_level"], :name => "root_level"

  create_table "phpbb3_privmsgs_folder", :primary_key => "folder_id", :force => true do |t|
    t.integer "user_id",     :limit => 3, :default => 0,  :null => false
    t.string  "folder_name",              :default => "", :null => false
    t.integer "pm_count",    :limit => 3, :default => 0,  :null => false
  end

  add_index "phpbb3_privmsgs_folder", ["user_id"], :name => "user_id"

  create_table "phpbb3_privmsgs_rules", :primary_key => "rule_id", :force => true do |t|
    t.integer "user_id",         :limit => 3, :default => 0,  :null => false
    t.integer "rule_check",      :limit => 3, :default => 0,  :null => false
    t.integer "rule_connection", :limit => 3, :default => 0,  :null => false
    t.string  "rule_string",                  :default => "", :null => false
    t.integer "rule_user_id",    :limit => 3, :default => 0,  :null => false
    t.integer "rule_group_id",   :limit => 3, :default => 0,  :null => false
    t.integer "rule_action",     :limit => 3, :default => 0,  :null => false
    t.integer "rule_folder_id",               :default => 0,  :null => false
  end

  add_index "phpbb3_privmsgs_rules", ["user_id"], :name => "user_id"

  create_table "phpbb3_privmsgs_to", :id => false, :force => true do |t|
    t.integer "msg_id",       :limit => 3, :default => 0,     :null => false
    t.integer "user_id",      :limit => 3, :default => 0,     :null => false
    t.integer "author_id",    :limit => 3, :default => 0,     :null => false
    t.boolean "pm_deleted",                :default => false, :null => false
    t.boolean "pm_new",                    :default => true,  :null => false
    t.boolean "pm_unread",                 :default => true,  :null => false
    t.boolean "pm_replied",                :default => false, :null => false
    t.boolean "pm_marked",                 :default => false, :null => false
    t.boolean "pm_forwarded",              :default => false, :null => false
    t.integer "folder_id",                 :default => 0,     :null => false
  end

  add_index "phpbb3_privmsgs_to", ["author_id"], :name => "author_id"
  add_index "phpbb3_privmsgs_to", ["msg_id"], :name => "msg_id"
  add_index "phpbb3_privmsgs_to", ["user_id", "folder_id"], :name => "usr_flder_id"

  create_table "phpbb3_profile_fields", :primary_key => "field_id", :force => true do |t|
    t.string  "field_name",                        :default => "",    :null => false
    t.integer "field_type",          :limit => 1,  :default => 0,     :null => false
    t.string  "field_ident",         :limit => 20, :default => "",    :null => false
    t.string  "field_length",        :limit => 20, :default => "",    :null => false
    t.string  "field_minlen",                      :default => "",    :null => false
    t.string  "field_maxlen",                      :default => "",    :null => false
    t.string  "field_novalue",                     :default => "",    :null => false
    t.string  "field_default_value",               :default => "",    :null => false
    t.string  "field_validation",    :limit => 20, :default => "",    :null => false
    t.boolean "field_required",                    :default => false, :null => false
    t.boolean "field_show_on_reg",                 :default => false, :null => false
    t.boolean "field_hide",                        :default => false, :null => false
    t.boolean "field_no_view",                     :default => false, :null => false
    t.boolean "field_active",                      :default => false, :null => false
    t.integer "field_order",         :limit => 3,  :default => 0,     :null => false
    t.boolean "field_show_profile",                :default => false, :null => false
    t.boolean "field_show_on_vt",                  :default => false, :null => false
  end

  add_index "phpbb3_profile_fields", ["field_order"], :name => "fld_ordr"
  add_index "phpbb3_profile_fields", ["field_type"], :name => "fld_type"

  create_table "phpbb3_profile_fields_data", :primary_key => "user_id", :force => true do |t|
  end

  create_table "phpbb3_profile_fields_lang", :id => false, :force => true do |t|
    t.integer "field_id",   :limit => 3, :default => 0,  :null => false
    t.integer "lang_id",    :limit => 3, :default => 0,  :null => false
    t.integer "option_id",  :limit => 3, :default => 0,  :null => false
    t.integer "field_type", :limit => 1, :default => 0,  :null => false
    t.string  "lang_value",              :default => "", :null => false
  end

  create_table "phpbb3_profile_lang", :id => false, :force => true do |t|
    t.integer "field_id",           :limit => 3, :default => 0,  :null => false
    t.integer "lang_id",            :limit => 3, :default => 0,  :null => false
    t.string  "lang_name",                       :default => "", :null => false
    t.text    "lang_explain",                                    :null => false
    t.string  "lang_default_value",              :default => "", :null => false
  end

  create_table "phpbb3_ranks", :primary_key => "rank_id", :force => true do |t|
    t.string  "rank_title",                :default => "",    :null => false
    t.integer "rank_min",     :limit => 3, :default => 0,     :null => false
    t.boolean "rank_special",              :default => false, :null => false
    t.string  "rank_image",                :default => "",    :null => false
  end

  create_table "phpbb3_reports", :primary_key => "report_id", :force => true do |t|
    t.integer "reason_id",     :limit => 2,        :default => 0,     :null => false
    t.integer "post_id",       :limit => 3,        :default => 0,     :null => false
    t.integer "user_id",       :limit => 3,        :default => 0,     :null => false
    t.boolean "user_notify",                       :default => false, :null => false
    t.boolean "report_closed",                     :default => false, :null => false
    t.integer "report_time",                       :default => 0,     :null => false
    t.text    "report_text",   :limit => 16777215,                    :null => false
    t.integer "pm_id",         :limit => 3,        :default => 0,     :null => false
  end

  add_index "phpbb3_reports", ["pm_id"], :name => "pm_id"
  add_index "phpbb3_reports", ["post_id"], :name => "post_id"

  create_table "phpbb3_reports_reasons", :primary_key => "reason_id", :force => true do |t|
    t.string  "reason_title",                           :default => "", :null => false
    t.text    "reason_description", :limit => 16777215,                 :null => false
    t.integer "reason_order",       :limit => 2,        :default => 0,  :null => false
  end

  create_table "phpbb3_search_results", :primary_key => "search_key", :force => true do |t|
    t.integer "search_time",                         :default => 0, :null => false
    t.text    "search_keywords", :limit => 16777215,                :null => false
    t.text    "search_authors",  :limit => 16777215,                :null => false
  end

  create_table "phpbb3_search_wordlist", :primary_key => "word_id", :force => true do |t|
    t.string  "word_text",                :default => "",    :null => false
    t.boolean "word_common",              :default => false, :null => false
    t.integer "word_count",  :limit => 3, :default => 0,     :null => false
  end

  add_index "phpbb3_search_wordlist", ["word_count"], :name => "wrd_cnt"
  add_index "phpbb3_search_wordlist", ["word_text"], :name => "wrd_txt", :unique => true

  create_table "phpbb3_search_wordmatch", :id => false, :force => true do |t|
    t.integer "post_id",     :limit => 3, :default => 0,     :null => false
    t.integer "word_id",     :limit => 3, :default => 0,     :null => false
    t.boolean "title_match",              :default => false, :null => false
  end

  add_index "phpbb3_search_wordmatch", ["post_id"], :name => "post_id"
  add_index "phpbb3_search_wordmatch", ["word_id", "post_id", "title_match"], :name => "unq_mtch", :unique => true
  add_index "phpbb3_search_wordmatch", ["word_id"], :name => "word_id"

  create_table "phpbb3_sessions", :primary_key => "session_id", :force => true do |t|
    t.integer "session_user_id",       :limit => 3,   :default => 0,     :null => false
    t.integer "session_last_visit",                   :default => 0,     :null => false
    t.integer "session_start",                        :default => 0,     :null => false
    t.integer "session_time",                         :default => 0,     :null => false
    t.string  "session_ip",            :limit => 40,  :default => "",    :null => false
    t.string  "session_browser",       :limit => 150, :default => "",    :null => false
    t.string  "session_forwarded_for",                :default => "",    :null => false
    t.string  "session_page",                         :default => "",    :null => false
    t.boolean "session_viewonline",                   :default => true,  :null => false
    t.boolean "session_autologin",                    :default => false, :null => false
    t.boolean "session_admin",                        :default => false, :null => false
    t.integer "session_forum_id",      :limit => 3,   :default => 0,     :null => false
  end

  add_index "phpbb3_sessions", ["session_forum_id"], :name => "session_fid"
  add_index "phpbb3_sessions", ["session_time"], :name => "session_time"
  add_index "phpbb3_sessions", ["session_user_id"], :name => "session_user_id"

  create_table "phpbb3_sessions_keys", :id => false, :force => true do |t|
    t.string  "key_id",     :limit => 32, :default => "", :null => false
    t.integer "user_id",    :limit => 3,  :default => 0,  :null => false
    t.string  "last_ip",    :limit => 40, :default => "", :null => false
    t.integer "last_login",               :default => 0,  :null => false
  end

  add_index "phpbb3_sessions_keys", ["last_login"], :name => "last_login"

  create_table "phpbb3_sitelist", :primary_key => "site_id", :force => true do |t|
    t.string  "site_ip",       :limit => 40, :default => "",    :null => false
    t.string  "site_hostname",               :default => "",    :null => false
    t.boolean "ip_exclude",                  :default => false, :null => false
  end

  create_table "phpbb3_smilies", :primary_key => "smiley_id", :force => true do |t|
    t.string  "code",               :limit => 50, :default => "",   :null => false
    t.string  "emotion",            :limit => 50, :default => "",   :null => false
    t.string  "smiley_url",         :limit => 50, :default => "",   :null => false
    t.integer "smiley_width",       :limit => 2,  :default => 0,    :null => false
    t.integer "smiley_height",      :limit => 2,  :default => 0,    :null => false
    t.integer "smiley_order",       :limit => 3,  :default => 0,    :null => false
    t.boolean "display_on_posting",               :default => true, :null => false
  end

  add_index "phpbb3_smilies", ["display_on_posting"], :name => "display_on_post"

  create_table "phpbb3_styles", :primary_key => "style_id", :force => true do |t|
    t.string  "style_name",                   :default => "",   :null => false
    t.string  "style_copyright",              :default => "",   :null => false
    t.boolean "style_active",                 :default => true, :null => false
    t.integer "template_id",     :limit => 3, :default => 0,    :null => false
    t.integer "theme_id",        :limit => 3, :default => 0,    :null => false
    t.integer "imageset_id",     :limit => 3, :default => 0,    :null => false
  end

  add_index "phpbb3_styles", ["imageset_id"], :name => "imageset_id"
  add_index "phpbb3_styles", ["style_name"], :name => "style_name", :unique => true
  add_index "phpbb3_styles", ["template_id"], :name => "template_id"
  add_index "phpbb3_styles", ["theme_id"], :name => "theme_id"

  create_table "phpbb3_styles_imageset", :primary_key => "imageset_id", :force => true do |t|
    t.string "imageset_name",                     :default => "", :null => false
    t.string "imageset_copyright",                :default => "", :null => false
    t.string "imageset_path",      :limit => 100, :default => "", :null => false
  end

  add_index "phpbb3_styles_imageset", ["imageset_name"], :name => "imgset_nm", :unique => true

  create_table "phpbb3_styles_imageset_data", :primary_key => "image_id", :force => true do |t|
    t.string  "image_name",     :limit => 200, :default => "", :null => false
    t.string  "image_filename", :limit => 200, :default => "", :null => false
    t.string  "image_lang",     :limit => 30,  :default => "", :null => false
    t.integer "image_height",   :limit => 2,   :default => 0,  :null => false
    t.integer "image_width",    :limit => 2,   :default => 0,  :null => false
    t.integer "imageset_id",    :limit => 3,   :default => 0,  :null => false
  end

  add_index "phpbb3_styles_imageset_data", ["imageset_id"], :name => "i_d"

  create_table "phpbb3_styles_template", :primary_key => "template_id", :force => true do |t|
    t.string  "template_name",                        :default => "",     :null => false
    t.string  "template_copyright",                   :default => "",     :null => false
    t.string  "template_path",         :limit => 100, :default => "",     :null => false
    t.string  "bbcode_bitfield",                      :default => "kNg=", :null => false
    t.boolean "template_storedb",                     :default => false,  :null => false
    t.integer "template_inherits_id",                 :default => 0,      :null => false
    t.string  "template_inherit_path",                :default => "",     :null => false
  end

  add_index "phpbb3_styles_template", ["template_name"], :name => "tmplte_nm", :unique => true

  create_table "phpbb3_styles_template_data", :id => false, :force => true do |t|
    t.integer "template_id",       :limit => 3,        :default => 0,  :null => false
    t.string  "template_filename", :limit => 100,      :default => "", :null => false
    t.text    "template_included",                                     :null => false
    t.integer "template_mtime",                        :default => 0,  :null => false
    t.text    "template_data",     :limit => 16777215,                 :null => false
  end

  add_index "phpbb3_styles_template_data", ["template_filename"], :name => "tfn"
  add_index "phpbb3_styles_template_data", ["template_id"], :name => "tid"

  create_table "phpbb3_styles_theme", :primary_key => "theme_id", :force => true do |t|
    t.string  "theme_name",                          :default => "",    :null => false
    t.string  "theme_copyright",                     :default => "",    :null => false
    t.string  "theme_path",      :limit => 100,      :default => "",    :null => false
    t.boolean "theme_storedb",                       :default => false, :null => false
    t.integer "theme_mtime",                         :default => 0,     :null => false
    t.text    "theme_data",      :limit => 16777215,                    :null => false
  end

  add_index "phpbb3_styles_theme", ["theme_name"], :name => "theme_name", :unique => true

  create_table "phpbb3_topics", :primary_key => "topic_id", :force => true do |t|
    t.integer "forum_id",                  :limit => 3, :default => 0,     :null => false
    t.integer "icon_id",                   :limit => 3, :default => 0,     :null => false
    t.boolean "topic_attachment",                       :default => false, :null => false
    t.boolean "topic_approved",                         :default => true,  :null => false
    t.boolean "topic_reported",                         :default => false, :null => false
    t.string  "topic_title",                            :default => "",    :null => false
    t.integer "topic_poster",              :limit => 3, :default => 0,     :null => false
    t.integer "topic_time",                             :default => 0,     :null => false
    t.integer "topic_time_limit",                       :default => 0,     :null => false
    t.integer "topic_views",               :limit => 3, :default => 0,     :null => false
    t.integer "topic_replies",             :limit => 3, :default => 0,     :null => false
    t.integer "topic_replies_real",        :limit => 3, :default => 0,     :null => false
    t.integer "topic_status",              :limit => 1, :default => 0,     :null => false
    t.integer "topic_type",                :limit => 1, :default => 0,     :null => false
    t.integer "topic_first_post_id",       :limit => 3, :default => 0,     :null => false
    t.string  "topic_first_poster_name",                :default => "",    :null => false
    t.string  "topic_first_poster_colour", :limit => 6, :default => "",    :null => false
    t.integer "topic_last_post_id",        :limit => 3, :default => 0,     :null => false
    t.integer "topic_last_poster_id",      :limit => 3, :default => 0,     :null => false
    t.string  "topic_last_poster_name",                 :default => "",    :null => false
    t.string  "topic_last_poster_colour",  :limit => 6, :default => "",    :null => false
    t.string  "topic_last_post_subject",                :default => "",    :null => false
    t.integer "topic_last_post_time",                   :default => 0,     :null => false
    t.integer "topic_last_view_time",                   :default => 0,     :null => false
    t.integer "topic_moved_id",            :limit => 3, :default => 0,     :null => false
    t.boolean "topic_bumped",                           :default => false, :null => false
    t.integer "topic_bumper",              :limit => 3, :default => 0,     :null => false
    t.string  "poll_title",                             :default => "",    :null => false
    t.integer "poll_start",                             :default => 0,     :null => false
    t.integer "poll_length",                            :default => 0,     :null => false
    t.integer "poll_max_options",          :limit => 1, :default => 1,     :null => false
    t.integer "poll_last_vote",                         :default => 0,     :null => false
    t.boolean "poll_vote_change",                       :default => false, :null => false
  end

  add_index "phpbb3_topics", ["forum_id", "topic_approved", "topic_last_post_id"], :name => "forum_appr_last"
  add_index "phpbb3_topics", ["forum_id", "topic_last_post_time", "topic_moved_id"], :name => "fid_time_moved"
  add_index "phpbb3_topics", ["forum_id", "topic_type"], :name => "forum_id_type"
  add_index "phpbb3_topics", ["forum_id"], :name => "forum_id"
  add_index "phpbb3_topics", ["topic_approved"], :name => "topic_approved"
  add_index "phpbb3_topics", ["topic_last_post_time"], :name => "last_post_time"

  create_table "phpbb3_topics_posted", :id => false, :force => true do |t|
    t.integer "user_id",      :limit => 3, :default => 0,     :null => false
    t.integer "topic_id",     :limit => 3, :default => 0,     :null => false
    t.boolean "topic_posted",              :default => false, :null => false
  end

  create_table "phpbb3_topics_track", :id => false, :force => true do |t|
    t.integer "user_id",   :limit => 3, :default => 0, :null => false
    t.integer "topic_id",  :limit => 3, :default => 0, :null => false
    t.integer "forum_id",  :limit => 3, :default => 0, :null => false
    t.integer "mark_time",              :default => 0, :null => false
  end

  add_index "phpbb3_topics_track", ["forum_id"], :name => "forum_id"

  create_table "phpbb3_topics_watch", :id => false, :force => true do |t|
    t.integer "topic_id",      :limit => 3, :default => 0,     :null => false
    t.integer "user_id",       :limit => 3, :default => 0,     :null => false
    t.boolean "notify_status",              :default => false, :null => false
  end

  add_index "phpbb3_topics_watch", ["notify_status"], :name => "notify_stat"
  add_index "phpbb3_topics_watch", ["topic_id"], :name => "topic_id"
  add_index "phpbb3_topics_watch", ["user_id"], :name => "user_id"

  create_table "phpbb3_user_group", :id => false, :force => true do |t|
    t.integer "group_id",     :limit => 3, :default => 0,     :null => false
    t.integer "user_id",      :limit => 3, :default => 0,     :null => false
    t.boolean "group_leader",              :default => false, :null => false
    t.boolean "user_pending",              :default => true,  :null => false
  end

  add_index "phpbb3_user_group", ["group_id"], :name => "group_id"
  add_index "phpbb3_user_group", ["group_leader"], :name => "group_leader"
  add_index "phpbb3_user_group", ["user_id"], :name => "user_id"

  create_table "phpbb3_users", :primary_key => "user_id", :force => true do |t|
    t.integer "user_type",                :limit => 1,                                      :default => 0,           :null => false
    t.integer "group_id",                 :limit => 3,                                      :default => 3,           :null => false
    t.text    "user_permissions",         :limit => 16777215,                                                        :null => false
    t.integer "user_perm_from",           :limit => 3,                                      :default => 0,           :null => false
    t.string  "user_ip",                  :limit => 40,                                     :default => "",          :null => false
    t.integer "user_regdate",                                                               :default => 0,           :null => false
    t.string  "username",                                                                   :default => "",          :null => false
    t.string  "username_clean",                                                             :default => "",          :null => false
    t.string  "user_password",            :limit => 40,                                     :default => "",          :null => false
    t.integer "user_passchg",                                                               :default => 0,           :null => false
    t.boolean "user_pass_convert",                                                          :default => false,       :null => false
    t.string  "user_email",               :limit => 100,                                    :default => "",          :null => false
    t.integer "user_email_hash",          :limit => 8,                                      :default => 0,           :null => false
    t.string  "user_birthday",            :limit => 10,                                     :default => "",          :null => false
    t.integer "user_lastvisit",                                                             :default => 0,           :null => false
    t.integer "user_lastmark",                                                              :default => 0,           :null => false
    t.integer "user_lastpost_time",                                                         :default => 0,           :null => false
    t.string  "user_lastpage",            :limit => 200,                                    :default => "",          :null => false
    t.string  "user_last_confirm_key",    :limit => 10,                                     :default => "",          :null => false
    t.integer "user_last_search",                                                           :default => 0,           :null => false
    t.integer "user_warnings",            :limit => 1,                                      :default => 0,           :null => false
    t.integer "user_last_warning",                                                          :default => 0,           :null => false
    t.integer "user_login_attempts",      :limit => 1,                                      :default => 0,           :null => false
    t.integer "user_inactive_reason",     :limit => 1,                                      :default => 0,           :null => false
    t.integer "user_inactive_time",                                                         :default => 0,           :null => false
    t.integer "user_posts",               :limit => 3,                                      :default => 0,           :null => false
    t.string  "user_lang",                :limit => 30,                                     :default => "",          :null => false
    t.decimal "user_timezone",                                :precision => 5, :scale => 2, :default => 0.0,         :null => false
    t.boolean "user_dst",                                                                   :default => false,       :null => false
    t.string  "user_dateformat",          :limit => 30,                                     :default => "d M Y H:i", :null => false
    t.integer "user_style",               :limit => 3,                                      :default => 0,           :null => false
    t.integer "user_rank",                :limit => 3,                                      :default => 0,           :null => false
    t.string  "user_colour",              :limit => 6,                                      :default => "",          :null => false
    t.integer "user_new_privmsg",                                                           :default => 0,           :null => false
    t.integer "user_unread_privmsg",                                                        :default => 0,           :null => false
    t.integer "user_last_privmsg",                                                          :default => 0,           :null => false
    t.boolean "user_message_rules",                                                         :default => false,       :null => false
    t.integer "user_full_folder",                                                           :default => -3,          :null => false
    t.integer "user_emailtime",                                                             :default => 0,           :null => false
    t.integer "user_topic_show_days",     :limit => 2,                                      :default => 0,           :null => false
    t.string  "user_topic_sortby_type",   :limit => 1,                                      :default => "t",         :null => false
    t.string  "user_topic_sortby_dir",    :limit => 1,                                      :default => "d",         :null => false
    t.integer "user_post_show_days",      :limit => 2,                                      :default => 0,           :null => false
    t.string  "user_post_sortby_type",    :limit => 1,                                      :default => "t",         :null => false
    t.string  "user_post_sortby_dir",     :limit => 1,                                      :default => "a",         :null => false
    t.boolean "user_notify",                                                                :default => false,       :null => false
    t.boolean "user_notify_pm",                                                             :default => true,        :null => false
    t.integer "user_notify_type",         :limit => 1,                                      :default => 0,           :null => false
    t.boolean "user_allow_pm",                                                              :default => true,        :null => false
    t.boolean "user_allow_viewonline",                                                      :default => true,        :null => false
    t.boolean "user_allow_viewemail",                                                       :default => true,        :null => false
    t.boolean "user_allow_massemail",                                                       :default => true,        :null => false
    t.integer "user_options",                                                               :default => 230271,      :null => false
    t.string  "user_avatar",                                                                :default => "",          :null => false
    t.integer "user_avatar_type",         :limit => 1,                                      :default => 0,           :null => false
    t.integer "user_avatar_width",        :limit => 2,                                      :default => 0,           :null => false
    t.integer "user_avatar_height",       :limit => 2,                                      :default => 0,           :null => false
    t.text    "user_sig",                 :limit => 16777215,                                                        :null => false
    t.string  "user_sig_bbcode_uid",      :limit => 8,                                      :default => "",          :null => false
    t.string  "user_sig_bbcode_bitfield",                                                   :default => "",          :null => false
    t.string  "user_from",                :limit => 100,                                    :default => "",          :null => false
    t.string  "user_icq",                 :limit => 15,                                     :default => "",          :null => false
    t.string  "user_aim",                                                                   :default => "",          :null => false
    t.string  "user_yim",                                                                   :default => "",          :null => false
    t.string  "user_msnm",                                                                  :default => "",          :null => false
    t.string  "user_jabber",                                                                :default => "",          :null => false
    t.string  "user_website",             :limit => 200,                                    :default => "",          :null => false
    t.text    "user_occ",                                                                                            :null => false
    t.text    "user_interests",                                                                                      :null => false
    t.string  "user_actkey",              :limit => 32,                                     :default => "",          :null => false
    t.string  "user_newpasswd",           :limit => 40,                                     :default => "",          :null => false
    t.string  "user_form_salt",           :limit => 32,                                     :default => "",          :null => false
    t.boolean "user_new",                                                                   :default => true,        :null => false
    t.integer "user_reminded",            :limit => 1,                                      :default => 0,           :null => false
    t.integer "user_reminded_time",                                                         :default => 0,           :null => false
  end

  add_index "phpbb3_users", ["user_birthday"], :name => "user_birthday"
  add_index "phpbb3_users", ["user_email_hash"], :name => "user_email_hash"
  add_index "phpbb3_users", ["user_type"], :name => "user_type"
  add_index "phpbb3_users", ["username_clean"], :name => "username_clean", :unique => true

  create_table "phpbb3_warnings", :primary_key => "warning_id", :force => true do |t|
    t.integer "user_id",      :limit => 3, :default => 0, :null => false
    t.integer "post_id",      :limit => 3, :default => 0, :null => false
    t.integer "log_id",       :limit => 3, :default => 0, :null => false
    t.integer "warning_time",              :default => 0, :null => false
  end

  create_table "phpbb3_words", :primary_key => "word_id", :force => true do |t|
    t.string "word",        :default => "", :null => false
    t.string "replacement", :default => "", :null => false
  end

  create_table "phpbb3_zebra", :id => false, :force => true do |t|
    t.integer "user_id",  :limit => 3, :default => 0,     :null => false
    t.integer "zebra_id", :limit => 3, :default => 0,     :null => false
    t.boolean "friend",                :default => false, :null => false
    t.boolean "foe",                   :default => false, :null => false
  end

  create_table "phpbb_auth_access", :id => false, :force => true do |t|
    t.integer "group_id",         :limit => 3, :default => 0,     :null => false
    t.integer "forum_id",         :limit => 2, :default => 0,     :null => false
    t.boolean "auth_view",                     :default => false, :null => false
    t.boolean "auth_read",                     :default => false, :null => false
    t.boolean "auth_post",                     :default => false, :null => false
    t.boolean "auth_reply",                    :default => false, :null => false
    t.boolean "auth_edit",                     :default => false, :null => false
    t.boolean "auth_delete",                   :default => false, :null => false
    t.boolean "auth_sticky",                   :default => false, :null => false
    t.boolean "auth_announce",                 :default => false, :null => false
    t.boolean "auth_vote",                     :default => false, :null => false
    t.boolean "auth_pollcreate",               :default => false, :null => false
    t.boolean "auth_attachments",              :default => false, :null => false
    t.boolean "auth_mod",                      :default => false, :null => false
  end

  add_index "phpbb_auth_access", ["forum_id"], :name => "forum_id"
  add_index "phpbb_auth_access", ["group_id"], :name => "group_id"

  create_table "phpbb_banlist", :primary_key => "ban_id", :force => true do |t|
    t.integer "ban_userid", :limit => 3, :null => false
    t.string  "ban_ip",     :limit => 8, :null => false
    t.string  "ban_email"
  end

  add_index "phpbb_banlist", ["ban_ip", "ban_userid"], :name => "ban_ip_user_id"

  create_table "phpbb_categories", :primary_key => "cat_id", :force => true do |t|
    t.string  "cat_title", :limit => 100
    t.integer "cat_order", :limit => 3,   :null => false
  end

  add_index "phpbb_categories", ["cat_order"], :name => "cat_order"

  create_table "phpbb_config", :primary_key => "config_name", :force => true do |t|
    t.string "config_value", :null => false
  end

  create_table "phpbb_confirm", :id => false, :force => true do |t|
    t.string "confirm_id", :limit => 32, :default => "", :null => false
    t.string "session_id", :limit => 32, :default => "", :null => false
    t.string "code",       :limit => 6,  :default => "", :null => false
  end

  create_table "phpbb_disallow", :primary_key => "disallow_id", :force => true do |t|
    t.string "disallow_username", :limit => 25, :default => "", :null => false
  end

  create_table "phpbb_forum_prune", :primary_key => "prune_id", :force => true do |t|
    t.integer "forum_id",   :limit => 2, :null => false
    t.integer "prune_days", :limit => 2, :null => false
    t.integer "prune_freq", :limit => 2, :null => false
  end

  add_index "phpbb_forum_prune", ["forum_id"], :name => "forum_id"

  create_table "phpbb_forums", :primary_key => "forum_id", :force => true do |t|
    t.integer "cat_id",             :limit => 3,                      :null => false
    t.string  "forum_name",         :limit => 150
    t.text    "forum_desc"
    t.integer "forum_status",       :limit => 1,   :default => 0,     :null => false
    t.integer "forum_order",        :limit => 3,   :default => 1,     :null => false
    t.integer "forum_posts",        :limit => 3,   :default => 0,     :null => false
    t.integer "forum_topics",       :limit => 3,   :default => 0,     :null => false
    t.integer "forum_last_post_id", :limit => 3,   :default => 0,     :null => false
    t.integer "prune_next"
    t.boolean "prune_enable",                      :default => false, :null => false
    t.integer "auth_view",          :limit => 1,   :default => 0,     :null => false
    t.integer "auth_read",          :limit => 1,   :default => 0,     :null => false
    t.integer "auth_post",          :limit => 1,   :default => 0,     :null => false
    t.integer "auth_reply",         :limit => 1,   :default => 0,     :null => false
    t.integer "auth_edit",          :limit => 1,   :default => 0,     :null => false
    t.integer "auth_delete",        :limit => 1,   :default => 0,     :null => false
    t.integer "auth_sticky",        :limit => 1,   :default => 0,     :null => false
    t.integer "auth_announce",      :limit => 1,   :default => 0,     :null => false
    t.integer "auth_vote",          :limit => 1,   :default => 0,     :null => false
    t.integer "auth_pollcreate",    :limit => 1,   :default => 0,     :null => false
    t.integer "auth_attachments",   :limit => 1,   :default => 0,     :null => false
  end

  add_index "phpbb_forums", ["cat_id"], :name => "cat_id"
  add_index "phpbb_forums", ["forum_last_post_id"], :name => "forum_last_post_id"
  add_index "phpbb_forums", ["forum_order"], :name => "forums_order"

  create_table "phpbb_groups", :primary_key => "group_id", :force => true do |t|
    t.integer "group_type",        :limit => 1,  :default => 1,    :null => false
    t.string  "group_name",        :limit => 40,                   :null => false
    t.string  "group_description",                                 :null => false
    t.integer "group_moderator",   :limit => 3,  :default => 0,    :null => false
    t.boolean "group_single_user",               :default => true, :null => false
  end

  add_index "phpbb_groups", ["group_single_user"], :name => "group_single_user"

  create_table "phpbb_posts", :primary_key => "post_id", :force => true do |t|
    t.integer "topic_id",        :limit => 3,  :default => 0,     :null => false
    t.integer "forum_id",        :limit => 2,  :default => 0,     :null => false
    t.integer "poster_id",       :limit => 3,  :default => 0,     :null => false
    t.integer "post_time",                     :default => 0,     :null => false
    t.string  "poster_ip",       :limit => 8,                     :null => false
    t.string  "post_username",   :limit => 25
    t.boolean "enable_bbcode",                 :default => true,  :null => false
    t.boolean "enable_html",                   :default => false, :null => false
    t.boolean "enable_smilies",                :default => true,  :null => false
    t.boolean "enable_sig",                    :default => true,  :null => false
    t.integer "post_edit_time"
    t.integer "post_edit_count", :limit => 2,  :default => 0,     :null => false
  end

  add_index "phpbb_posts", ["forum_id"], :name => "forum_id"
  add_index "phpbb_posts", ["post_time"], :name => "post_time"
  add_index "phpbb_posts", ["poster_id"], :name => "poster_id"
  add_index "phpbb_posts", ["topic_id"], :name => "topic_id"

  create_table "phpbb_posts_text", :primary_key => "post_id", :force => true do |t|
    t.string "bbcode_uid",   :limit => 10, :default => "", :null => false
    t.string "post_subject", :limit => 60
    t.text   "post_text"
  end

  create_table "phpbb_privmsgs", :primary_key => "privmsgs_id", :force => true do |t|
    t.integer "privmsgs_type",           :limit => 1, :default => 0,     :null => false
    t.string  "privmsgs_subject",                     :default => "0",   :null => false
    t.integer "privmsgs_from_userid",    :limit => 3, :default => 0,     :null => false
    t.integer "privmsgs_to_userid",      :limit => 3, :default => 0,     :null => false
    t.integer "privmsgs_date",                        :default => 0,     :null => false
    t.string  "privmsgs_ip",             :limit => 8,                    :null => false
    t.boolean "privmsgs_enable_bbcode",               :default => true,  :null => false
    t.boolean "privmsgs_enable_html",                 :default => false, :null => false
    t.boolean "privmsgs_enable_smilies",              :default => true,  :null => false
    t.boolean "privmsgs_attach_sig",                  :default => true,  :null => false
  end

  add_index "phpbb_privmsgs", ["privmsgs_from_userid"], :name => "privmsgs_from_userid"
  add_index "phpbb_privmsgs", ["privmsgs_to_userid"], :name => "privmsgs_to_userid"

  create_table "phpbb_privmsgs_text", :primary_key => "privmsgs_text_id", :force => true do |t|
    t.string "privmsgs_bbcode_uid", :limit => 10, :default => "0", :null => false
    t.text   "privmsgs_text"
  end

  create_table "phpbb_ranks", :primary_key => "rank_id", :force => true do |t|
    t.string  "rank_title",   :limit => 50,                    :null => false
    t.integer "rank_min",     :limit => 3,  :default => 0,     :null => false
    t.boolean "rank_special",               :default => false
    t.string  "rank_image"
  end

  create_table "phpbb_search_results", :primary_key => "search_id", :force => true do |t|
    t.string  "session_id",   :limit => 32,       :default => "", :null => false
    t.integer "search_time",                      :default => 0,  :null => false
    t.text    "search_array", :limit => 16777215,                 :null => false
  end

  add_index "phpbb_search_results", ["session_id"], :name => "session_id"

  create_table "phpbb_search_wordlist", :primary_key => "word_text", :force => true do |t|
    t.integer "word_id",     :limit => 3,                    :null => false
    t.boolean "word_common",              :default => false, :null => false
  end

  add_index "phpbb_search_wordlist", ["word_id"], :name => "word_id"

  create_table "phpbb_search_wordmatch", :id => false, :force => true do |t|
    t.integer "post_id",     :limit => 3, :default => 0,     :null => false
    t.integer "word_id",     :limit => 3, :default => 0,     :null => false
    t.boolean "title_match",              :default => false, :null => false
  end

  add_index "phpbb_search_wordmatch", ["post_id"], :name => "post_id"
  add_index "phpbb_search_wordmatch", ["word_id"], :name => "word_id"

  create_table "phpbb_sessions", :primary_key => "session_id", :force => true do |t|
    t.integer "session_user_id",   :limit => 3, :default => 0,     :null => false
    t.integer "session_start",                  :default => 0,     :null => false
    t.integer "session_time",                   :default => 0,     :null => false
    t.string  "session_ip",        :limit => 8, :default => "0",   :null => false
    t.integer "session_page",                   :default => 0,     :null => false
    t.boolean "session_logged_in",              :default => false, :null => false
    t.integer "session_admin",     :limit => 1, :default => 0,     :null => false
  end

  add_index "phpbb_sessions", ["session_id", "session_ip", "session_user_id"], :name => "session_id_ip_user_id"
  add_index "phpbb_sessions", ["session_user_id"], :name => "session_user_id"

  create_table "phpbb_sessions_keys", :id => false, :force => true do |t|
    t.string  "key_id",     :limit => 32, :default => "0", :null => false
    t.integer "user_id",    :limit => 3,  :default => 0,   :null => false
    t.string  "last_ip",    :limit => 8,  :default => "0", :null => false
    t.integer "last_login",               :default => 0,   :null => false
  end

  add_index "phpbb_sessions_keys", ["last_login"], :name => "last_login"

  create_table "phpbb_smilies", :primary_key => "smilies_id", :force => true do |t|
    t.string "code",      :limit => 50
    t.string "smile_url", :limit => 100
    t.string "emoticon",  :limit => 75
  end

  create_table "phpbb_themes", :primary_key => "themes_id", :force => true do |t|
    t.string  "template_name",    :limit => 30,  :default => "", :null => false
    t.string  "style_name",       :limit => 30,  :default => "", :null => false
    t.string  "head_stylesheet",  :limit => 100
    t.string  "body_background",  :limit => 100
    t.string  "body_bgcolor",     :limit => 6
    t.string  "body_text",        :limit => 6
    t.string  "body_link",        :limit => 6
    t.string  "body_vlink",       :limit => 6
    t.string  "body_alink",       :limit => 6
    t.string  "body_hlink",       :limit => 6
    t.string  "tr_color1",        :limit => 6
    t.string  "tr_color2",        :limit => 6
    t.string  "tr_color3",        :limit => 6
    t.string  "tr_class1",        :limit => 25
    t.string  "tr_class2",        :limit => 25
    t.string  "tr_class3",        :limit => 25
    t.string  "th_color1",        :limit => 6
    t.string  "th_color2",        :limit => 6
    t.string  "th_color3",        :limit => 6
    t.string  "th_class1",        :limit => 25
    t.string  "th_class2",        :limit => 25
    t.string  "th_class3",        :limit => 25
    t.string  "td_color1",        :limit => 6
    t.string  "td_color2",        :limit => 6
    t.string  "td_color3",        :limit => 6
    t.string  "td_class1",        :limit => 25
    t.string  "td_class2",        :limit => 25
    t.string  "td_class3",        :limit => 25
    t.string  "fontface1",        :limit => 50
    t.string  "fontface2",        :limit => 50
    t.string  "fontface3",        :limit => 50
    t.integer "fontsize1",        :limit => 1
    t.integer "fontsize2",        :limit => 1
    t.integer "fontsize3",        :limit => 1
    t.string  "fontcolor1",       :limit => 6
    t.string  "fontcolor2",       :limit => 6
    t.string  "fontcolor3",       :limit => 6
    t.string  "span_class1",      :limit => 25
    t.string  "span_class2",      :limit => 25
    t.string  "span_class3",      :limit => 25
    t.integer "img_size_poll",    :limit => 2
    t.integer "img_size_privmsg", :limit => 2
  end

  create_table "phpbb_themes_name", :primary_key => "themes_id", :force => true do |t|
    t.string "tr_color1_name",   :limit => 50
    t.string "tr_color2_name",   :limit => 50
    t.string "tr_color3_name",   :limit => 50
    t.string "tr_class1_name",   :limit => 50
    t.string "tr_class2_name",   :limit => 50
    t.string "tr_class3_name",   :limit => 50
    t.string "th_color1_name",   :limit => 50
    t.string "th_color2_name",   :limit => 50
    t.string "th_color3_name",   :limit => 50
    t.string "th_class1_name",   :limit => 50
    t.string "th_class2_name",   :limit => 50
    t.string "th_class3_name",   :limit => 50
    t.string "td_color1_name",   :limit => 50
    t.string "td_color2_name",   :limit => 50
    t.string "td_color3_name",   :limit => 50
    t.string "td_class1_name",   :limit => 50
    t.string "td_class2_name",   :limit => 50
    t.string "td_class3_name",   :limit => 50
    t.string "fontface1_name",   :limit => 50
    t.string "fontface2_name",   :limit => 50
    t.string "fontface3_name",   :limit => 50
    t.string "fontsize1_name",   :limit => 50
    t.string "fontsize2_name",   :limit => 50
    t.string "fontsize3_name",   :limit => 50
    t.string "fontcolor1_name",  :limit => 50
    t.string "fontcolor2_name",  :limit => 50
    t.string "fontcolor3_name",  :limit => 50
    t.string "span_class1_name", :limit => 50
    t.string "span_class2_name", :limit => 50
    t.string "span_class3_name", :limit => 50
  end

  create_table "phpbb_topics", :primary_key => "topic_id", :force => true do |t|
    t.integer "forum_id",            :limit => 2,  :default => 0,     :null => false
    t.string  "topic_title",         :limit => 60,                    :null => false
    t.integer "topic_poster",        :limit => 3,  :default => 0,     :null => false
    t.integer "topic_time",                        :default => 0,     :null => false
    t.integer "topic_views",         :limit => 3,  :default => 0,     :null => false
    t.integer "topic_replies",       :limit => 3,  :default => 0,     :null => false
    t.integer "topic_status",        :limit => 1,  :default => 0,     :null => false
    t.boolean "topic_vote",                        :default => false, :null => false
    t.integer "topic_type",          :limit => 1,  :default => 0,     :null => false
    t.integer "topic_first_post_id", :limit => 3,  :default => 0,     :null => false
    t.integer "topic_last_post_id",  :limit => 3,  :default => 0,     :null => false
    t.integer "topic_moved_id",      :limit => 3,  :default => 0,     :null => false
  end

  add_index "phpbb_topics", ["forum_id"], :name => "forum_id"
  add_index "phpbb_topics", ["topic_moved_id"], :name => "topic_moved_id"
  add_index "phpbb_topics", ["topic_status"], :name => "topic_status"
  add_index "phpbb_topics", ["topic_type"], :name => "topic_type"

  create_table "phpbb_topics_watch", :id => false, :force => true do |t|
    t.integer "topic_id",      :limit => 3, :default => 0,     :null => false
    t.integer "user_id",       :limit => 3, :default => 0,     :null => false
    t.boolean "notify_status",              :default => false, :null => false
  end

  add_index "phpbb_topics_watch", ["notify_status"], :name => "notify_status"
  add_index "phpbb_topics_watch", ["topic_id"], :name => "topic_id"
  add_index "phpbb_topics_watch", ["user_id"], :name => "user_id"

  create_table "phpbb_user_group", :id => false, :force => true do |t|
    t.integer "group_id",     :limit => 3, :default => 0, :null => false
    t.integer "user_id",      :limit => 3, :default => 0, :null => false
    t.boolean "user_pending"
  end

  add_index "phpbb_user_group", ["group_id"], :name => "group_id"
  add_index "phpbb_user_group", ["user_id"], :name => "user_id"

  create_table "phpbb_users", :primary_key => "user_id", :force => true do |t|
    t.boolean "user_active",                                                        :default => true
    t.string  "username",              :limit => 25,                                                         :null => false
    t.string  "user_password",         :limit => 32,                                                         :null => false
    t.integer "user_session_time",                                                  :default => 0,           :null => false
    t.integer "user_session_page",     :limit => 2,                                 :default => 0,           :null => false
    t.integer "user_lastvisit",                                                     :default => 0,           :null => false
    t.integer "user_regdate",                                                       :default => 0,           :null => false
    t.integer "user_level",            :limit => 1,                                 :default => 0
    t.integer "user_posts",            :limit => 3,                                 :default => 0,           :null => false
    t.decimal "user_timezone",                        :precision => 5, :scale => 2, :default => 0.0,         :null => false
    t.integer "user_style",            :limit => 1
    t.string  "user_lang"
    t.string  "user_dateformat",       :limit => 14,                                :default => "d M Y H:i", :null => false
    t.integer "user_new_privmsg",      :limit => 2,                                 :default => 0,           :null => false
    t.integer "user_unread_privmsg",   :limit => 2,                                 :default => 0,           :null => false
    t.integer "user_last_privmsg",                                                  :default => 0,           :null => false
    t.integer "user_login_tries",      :limit => 2,                                 :default => 0,           :null => false
    t.integer "user_last_login_try",                                                :default => 0,           :null => false
    t.integer "user_emailtime"
    t.boolean "user_viewemail"
    t.boolean "user_attachsig"
    t.boolean "user_allowhtml",                                                     :default => true
    t.boolean "user_allowbbcode",                                                   :default => true
    t.boolean "user_allowsmile",                                                    :default => true
    t.boolean "user_allowavatar",                                                   :default => true,        :null => false
    t.boolean "user_allow_pm",                                                      :default => true,        :null => false
    t.boolean "user_allow_viewonline",                                              :default => true,        :null => false
    t.boolean "user_notify",                                                        :default => true,        :null => false
    t.boolean "user_notify_pm",                                                     :default => false,       :null => false
    t.boolean "user_popup_pm",                                                      :default => false,       :null => false
    t.integer "user_rank",                                                          :default => 0
    t.string  "user_avatar",           :limit => 100
    t.integer "user_avatar_type",      :limit => 1,                                 :default => 0,           :null => false
    t.string  "user_email"
    t.string  "user_icq",              :limit => 15
    t.string  "user_website",          :limit => 100
    t.string  "user_from",             :limit => 100
    t.text    "user_sig"
    t.string  "user_sig_bbcode_uid",   :limit => 10
    t.string  "user_aim"
    t.string  "user_yim"
    t.string  "user_msnm"
    t.string  "user_occ",              :limit => 100
    t.string  "user_interests"
    t.string  "user_actkey",           :limit => 32
    t.string  "user_newpasswd",        :limit => 32
  end

  add_index "phpbb_users", ["user_session_time"], :name => "user_session_time"

  create_table "phpbb_vote_desc", :primary_key => "vote_id", :force => true do |t|
    t.integer "topic_id",    :limit => 3, :default => 0, :null => false
    t.text    "vote_text",                               :null => false
    t.integer "vote_start",               :default => 0, :null => false
    t.integer "vote_length",              :default => 0, :null => false
  end

  add_index "phpbb_vote_desc", ["topic_id"], :name => "topic_id"

  create_table "phpbb_vote_results", :id => false, :force => true do |t|
    t.integer "vote_id",          :limit => 3, :default => 0, :null => false
    t.integer "vote_option_id",   :limit => 1, :default => 0, :null => false
    t.string  "vote_option_text",                             :null => false
    t.integer "vote_result",                   :default => 0, :null => false
  end

  add_index "phpbb_vote_results", ["vote_id"], :name => "vote_id"
  add_index "phpbb_vote_results", ["vote_option_id"], :name => "vote_option_id"

  create_table "phpbb_vote_voters", :id => false, :force => true do |t|
    t.integer "vote_id",      :limit => 3, :default => 0, :null => false
    t.integer "vote_user_id", :limit => 3, :default => 0, :null => false
    t.string  "vote_user_ip", :limit => 8,                :null => false
  end

  add_index "phpbb_vote_voters", ["vote_id"], :name => "vote_id"
  add_index "phpbb_vote_voters", ["vote_user_id"], :name => "vote_user_id"
  add_index "phpbb_vote_voters", ["vote_user_ip"], :name => "vote_user_ip"

  create_table "phpbb_words", :primary_key => "word_id", :force => true do |t|
    t.string "word",        :limit => 100, :null => false
    t.string "replacement", :limit => 100, :null => false
  end

  create_table "plz2bl", :primary_key => "loc_id", :force => true do |t|
    t.string  "plz",   :limit => 5,  :null => false
    t.string  "name",                :null => false
    t.string  "bl",    :limit => 30, :null => false
    t.integer "bl_id", :limit => 8,  :null => false
  end

  add_index "plz2bl", ["bl_id"], :name => "bl_id"

  create_table "plz_geodb", :primary_key => "loc_id", :force => true do |t|
    t.string "plz", :limit => 50, :null => false
    t.float  "lat",               :null => false
    t.float  "lon",               :null => false
    t.string "ort",               :null => false
  end

  add_index "plz_geodb", ["loc_id"], :name => "loc_id_2", :unique => true
  add_index "plz_geodb", ["ort"], :name => "ort"
  add_index "plz_geodb", ["plz"], :name => "plz", :unique => true

  create_table "static_template", :primary_key => "uid", :force => true do |t|
    t.integer "pid",                           :default => 0,  :null => false
    t.integer "tstamp",                        :default => 0,  :null => false
    t.integer "crdate",                        :default => 0,  :null => false
    t.string  "title",                         :default => "", :null => false
    t.text    "include_static", :limit => 255
    t.text    "constants"
    t.text    "config"
    t.text    "description"
    t.text    "editorcfg"
  end

  add_index "static_template", ["pid"], :name => "parent"

  create_table "static_tsconfig_help", :primary_key => "uid", :force => true do |t|
    t.integer "guide",                     :default => 0,  :null => false
    t.string  "md5hash",     :limit => 32, :default => "", :null => false
    t.text    "description"
    t.string  "obj_string",                :default => "", :null => false
    t.binary  "appdata"
    t.string  "title",                     :default => "", :null => false
  end

  add_index "static_tsconfig_help", ["guide", "md5hash"], :name => "guide"

  create_table "table_meta_data", :force => true do |t|
    t.string  "table_name",    :limit => 50,  :null => false
    t.string  "field_name",    :limit => 50,  :null => false
    t.integer "type",                         :null => false
    t.string  "label",         :limit => 100, :null => false
    t.string  "mapping_table", :limit => 50,  :null => false
    t.string  "ref_table",     :limit => 50,  :null => false
    t.integer "field_order",   :limit => 1,   :null => false
  end

  create_table "url2cat", :id => false, :force => true do |t|
    t.integer "url_id", :limit => 8, :null => false
    t.integer "cat_id", :limit => 8, :null => false
  end

  add_index "url2cat", ["url_id", "cat_id"], :name => "url_id", :unique => true

  create_table "url_categories", :force => true do |t|
    t.integer "parent",      :limit => 8, :default => 0,     :null => false
    t.boolean "leaf",                     :default => false, :null => false
    t.boolean "hascountry",               :default => false, :null => false
    t.string  "description",              :default => "",    :null => false
  end

  create_table "urls", :force => true do |t|
    t.integer   "category",   :limit => 8,  :default => 0,  :null => false
    t.string    "url",                      :default => "", :null => false
    t.string    "titel",                                    :null => false
    t.string    "descr",                    :default => "", :null => false
    t.string    "sprache",                  :default => "", :null => false
    t.integer   "land",       :limit => 8,  :default => 0,  :null => false
    t.integer   "bland",      :limit => 8,  :default => 0,  :null => false
    t.string    "email",                    :default => "", :null => false
    t.integer   "fk_user",    :limit => 8,  :default => 1,  :null => false
    t.timestamp "lastchange"
    t.datetime  "confirmed",                                :null => false
    t.string    "ip",         :limit => 16,                 :null => false
    t.integer   "visible",                  :default => 0,  :null => false
  end

  add_index "urls", ["bland"], :name => "bland"
  add_index "urls", ["category"], :name => "category"
  add_index "urls", ["fk_user"], :name => "fk_user"
  add_index "urls", ["land"], :name => "land"

  create_table "user", :force => true do |t|
    t.string "username", :null => false
    t.string "passwd",   :null => false
    t.string "email",    :null => false
  end

  add_index "user", ["email"], :name => "email", :unique => true
  add_index "user", ["username"], :name => "username", :unique => true

  create_table "wettbewerbe", :force => true do |t|
    t.date     "startdate",                                    :null => false
    t.date     "enddate",                                      :null => false
    t.text     "titel",                                        :null => false
    t.text     "beschreibung",                                 :null => false
    t.text     "gebuehr",                                      :null => false
    t.text     "preis",                                        :null => false
    t.text     "anmeldung",                                    :null => false
    t.date     "deadline",                                     :null => false
    t.string   "email",        :limit => 50,                   :null => false
    t.datetime "reported",                                     :null => false
    t.datetime "confirmed",                                    :null => false
    t.boolean  "visible",                    :default => true, :null => false
  end

end
