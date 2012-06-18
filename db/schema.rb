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

ActiveRecord::Schema.define(:version => 20111122165156) do

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

  create_table "blacklist", :force => true do |t|
    t.string   "ip",          :limit => 16, :null => false
    t.datetime "blacklisted",               :null => false
  end

  add_index "blacklist", ["ip"], :name => "ip", :unique => true

  create_table "bundeslaender", :force => true do |t|
    t.integer  "land",       :limit => 8, :default => 0, :null => false
    t.string   "name",                                   :null => false
    t.date     "created_on",                             :null => false
    t.datetime "created_at",                             :null => false
    t.date     "updated_on",                             :null => false
    t.datetime "updated_at",                             :null => false
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
    t.string   "name",                    :default => "", :null => false
    t.string   "ccode",      :limit => 5, :default => "", :null => false
    t.date     "created_on",                              :null => false
    t.datetime "created_at",                              :null => false
    t.date     "updated_on",                              :null => false
    t.datetime "updated_at",                              :null => false
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
    t.integer  "nummer",                   :null => false
    t.string   "name",       :limit => 40, :null => false
    t.string   "subname",    :limit => 50, :null => false
    t.string   "homepage",   :limit => 50, :null => false
    t.string   "jugend_url", :limit => 50, :null => false
    t.bigint "konto"
    t.bigint "blz"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at"
  end

  create_table "member_account", :force => true do |t|
    t.integer "member_id", :limit => 8, :null => false
    t.string  "type",      :limit => 0, :null => false
  end

  create_table "orchestras", :force => true do |t|
    t.integer "mglnr",                :limit => 8
    t.string  "orchName",             :limit => 200
    t.string  "anrede",               :limit => 100
    t.string  "vorname",              :limit => 100
    t.string  "nachname",             :limit => 100
    t.string  "strasse",              :limit => 510
    t.string  "land",                 :limit => 510
    t.string  "plz",                  :limit => 100
    t.string  "ort",                  :limit => 510
    t.string  "telefon",              :limit => 510
    t.string  "fax",                  :limit => 510
    t.date    "gruendung"
    t.date    "eintritt"
    t.string  "za",                   :limit => 2
    t.integer "konto",                :limit => 8
    t.integer "blz",                  :limit => 8
    t.integer "lv",                   :limit => 2
    t.string  "zw",                   :limit => 510
    t.integer "zeitungen",            :limit => 8
    t.integer "gema",                 :limit => 8
    t.integer "numBis14"
    t.integer "num15bis18"
    t.integer "num19bis27"
    t.integer "numUeber27"
    t.integer "sumMitglieder",        :limit => 8
    t.integer "azubi",                :limit => 8
    t.integer "passive",              :limit => 8
    t.float   "beitrag"
    t.boolean "unfallversicherung"
    t.boolean "meldebogen"
    t.boolean "rechnungsDruck"
    t.string  "orch_type",            :limit => 2
    t.boolean "koopMitglied"
    t.boolean "landes_orch"
    t.date    "austrittZum"
    t.date    "schreibenVom"
    t.float   "uvBetrag"
    t.float   "rechnungsbetrag"
    t.boolean "versaeumniszuschlag"
    t.float   "vZuschlag"
    t.boolean "mahngebuehr1"
    t.boolean "mahngebuehr2"
    t.float   "mGebuehr1"
    t.float   "mGebuehr2"
    t.string  "bemerkung",            :limit => 510
    t.string  "url",                  :limit => 100
    t.boolean "lastschriftErfasst"
    t.boolean "kuendigungErfasst"
    t.string  "zweitanschrift",       :limit => 100
    t.string  "name2",                :limit => 100
    t.integer "dageVER",              :limit => 8
    t.integer "haftpflichtVers",      :limit => 8
    t.float   "haftpflichtGebuehrLV"
    t.float   "lvGebuehr"
    t.integer "uvZusatzzahl",         :limit => 8
    t.integer "uvZahl",               :limit => 8
    t.integer "jahreszahl",           :limit => 8
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

  create_table "person_members", :force => true do |t|
    t.integer  "mitgliedsnummer",    :limit => 8
    t.string   "anrede",             :limit => 40
    t.string   "strasse",            :limit => 100
    t.string   "plz",                :limit => 100
    t.string   "ort",                :limit => 100
    t.date     "geburtstag"
    t.string   "telefonPrivat",      :limit => 60
    t.string   "telefonDienstl",     :limit => 60
    t.string   "telefax",            :limit => 60
    t.date     "eintritt"
    t.string   "za",                 :limit => 4
    t.integer  "konto",              :limit => 8
    t.integer  "blz",                :limit => 8
    t.string   "zahler",             :limit => 510
    t.integer  "lv",                 :limit => 8
    t.references "tariff_id"
    t.string   "bemerkung",          :limit => 510
    t.integer  "zeitungen",          :limit => 2
    t.date     "austrittZum"
    t.date     "kuendigungVom"
    t.float    "beitrag"
    t.integer  "zusatzzeitung",      :limit => 8
    t.string   "eMail",              :limit => 100
    t.boolean  "lastschriftErfasst"
    t.boolean  "rechnungsDruck"
    t.integer  "jahreszahl",         :limit => 8
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false

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

  create_table "report_sheets", :force => true do |t|
    t.integer "year",                      :null => false
    t.integer "orchestra_id", :limit => 8, :null => false
    t.integer "children",                  :null => false
    t.integer "teens",                     :null => false
    t.integer "youth",                     :null => false
    t.integer "adult",                     :null => false
    t.integer "doppel_mgl",                :null => false
    t.boolean "uv",                        :null => false
    t.integer "zeitungen",                 :null => false
    t.integer "gema",                      :null => false
    t.integer "azubi",                     :null => false
    t.integer "passive",                   :null => false
  end

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

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                 :default => "", :null => false
    t.string   "name",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

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

  create_table "honor_members", :force => true do |t|
    t.integer "nr"
    t.string  "vorname"
    t.string  "name"
    t.string  "ort"
    t.string  "honorType"
    t.date    "honorDate"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false

  create_table "members", :force => true do |t|
    t.string "subtype"
    t.references "regional_organization_id"
    t.references "country_id"
    t.integer "mglnr"
    t.string  "vorname",                :limit => 100
    t.string  "name",                :limit => 100
    t.string  "email",                :limit => 100
    t.date "eintritt"
    t.date "austritt_zum"
    t.string "za"
    t.bigint "konto"
    t.bigint "blz"
    t.string "zahler"
    t.datetime "created_at"
    t.datetime "update_at"

  create_table "member_acct_booking", :force => true do |t|
    t.integer "booking_year"
    t.string  "booking_type"
    t.references "member_id"
   	t.string     "booking_type"
    t.integer "booking_year"
    t.string "booking_mode"
    t.date "booking_date"
 	t.string "booking_txt"
	t.string "filename"
    t.double "amount"
end
