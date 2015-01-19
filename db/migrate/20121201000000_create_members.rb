class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string   "subtype",                  :limit => 50,                  :null => false
      t.integer  "regional_organization_id", :limit => 8,                   :null => false
      t.integer  "mglnr",                    :limit => 8,                   :null => false
      t.string   "anrede",                   :limit => 20,                  :null => false
      t.string   "vorname",                  :limit => 100,                 :null => false
      t.string   "name",                     :limit => 100,                 :null => false
      t.string   "strasse",                  :limit => 50,                  :null => false
      t.string   "plz",                      :limit => 20,                  :null => false
      t.string   "ort",                      :limit => 50,                  :null => false
      t.integer  "country_id",               :limit => 8,   :default => 81, :null => false
      t.string   "email",                    :limit => 100
      t.date     "eintritt",                                                :null => false
      t.date     "austritt_zum"
      t.string   "za",                       :limit => 1,                   :null => false
      t.integer  "konto",                    :limit => 8
      t.string   "blz",                      :limit => 8
      t.string   "zahler",                   :limit => 100
      t.timestamps 
    end

    add_index "members", ["mglnr"], :name => "mglnr", :unique => true
  end
end
