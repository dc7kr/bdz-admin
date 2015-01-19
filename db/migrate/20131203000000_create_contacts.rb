class CreateContacts <  ActiveRecord::Migration

  def change
    create_table "contacts", :force => true do |t|
      t.string "subtype",      :limit => 50,  :null => false
      t.string "company",      :limit => 100
      t.string "department",   :limit => 100
      t.string "salutation",   :limit => 10,  :null => false
      t.string "title",        :limit => 50
      t.string "first_name",   :limit => 50,  :null => false
      t.string "last_name",    :limit => 50,  :null => false
      t.string "street",       :limit => 50,  :null => false
      t.string "zip",          :limit => 10,  :null => false
      t.string "city",         :limit => 50,  :null => false
      t.string "phone",        :limit => 50
      t.string "office_phone", :limit => 100
      t.string "mobile",       :limit => 50
      t.string "fax",          :limit => 50
      t.string "email",        :limit => 50
    end

  end

end
