class CreateCourses < ActiveRecord::Migration 
  def change
   create_table "courses" do |t|
      t.datetime "startdate",                                 :null => false
      t.datetime "enddate",                                   :null => false
      t.datetime "reported",                                  :null => false
      t.datetime "confirmed"
      t.integer  "bland",        :limit => 8,                 :null => false
      t.integer  "fk_festival",  :limit => 8,  :default => 0
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
      t.string   "token",        :limit => 40
      t.integer  "visible",                    :default => 0, :null => false
    end
  end
end
