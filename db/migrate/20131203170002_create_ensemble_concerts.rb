class CreateEnsembleConcerts < ActiveRecord::Migration[4.2]
  def change

    create_table "ensemble_concerts" do |t|
      t.datetime "datum",                                                                                       :null => false
      t.time     "zeit",                                                     :default => '2000-01-01 00:00:00', :null => false
      t.datetime "reported",                                                                                    :null => false
      t.datetime "confirmed"
      t.string   "stadt",                                                    :default => "",                    :null => false
      t.string   "ort",                                                      :default => "",                    :null => false
      t.integer  "festival_id",  :limit => 8,                                :default => 0,                     :null => false
      t.integer  "ensemble_id",  :limit => 8,                                :default => 0,                     :null => false
      t.text     "titel",                                                                                       :null => false
      t.string   "comment",                                                  :default => "",                    :null => false
      t.decimal  "eintritt",                  :precision => 10, :scale => 0,                                    :null => false
      t.integer  "state_id",     :limit => 8,                                                                   :null => false
      t.integer  "country_id",   :limit => 8,                                :default => 0,                     :null => false
      t.string   "email",                                                    :default => "",                    :null => false
      t.integer  "fk_owner",     :limit => 8,                                :default => 1,                     :null => false
      t.integer  "visible",      :limit => 2,                                :default => 0,                     :null => false
      t.text     "url",                                                                                         :null => false
    end

    add_index "ensemble_concerts", ["country_id"], :name => "land"
    add_index "ensemble_concerts", ["datum", "zeit", "ensemble_id"], :name => "unique_event", :unique => true
    add_index "ensemble_concerts", ["ensemble_id"], :name => "ensemble_id"
    add_index "ensemble_concerts", ["fk_owner"], :name => "fk_owner"
    add_index "ensemble_concerts", ["state_id"], :name => "bundesland"

  end
end
