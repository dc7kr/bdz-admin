class CreateClassifieds < ActiveRecord::Migration[4.2]
  def change
    create_table "classifieds" do |t|
      t.integer  "adv_type",                  :default => 0,     :null => false
      t.string   "name",                      :default => "",    :null => false
      t.string   "email",                     :default => "",    :null => false
      t.string   "url",                       :default => "",    :null => false
      t.string   "object",                    :default => "",    :null => false
      t.text     "description",                                  :null => false
      t.date     "validuntil",                                   :null => false
      t.datetime "entrydate",                                    :null => false
      t.datetime "confirmed"
      t.string   "ip",          :limit => 20,                    :null => false
      t.boolean  "visible",                   :default => false, :null => false
    end
  end
end
