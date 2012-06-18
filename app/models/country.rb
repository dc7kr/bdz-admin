class Country < ActiveRecord::Base
	set_table_name "country"
	has_many :states

    comma do 
      name
    end
end
