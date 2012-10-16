class Country < ActiveRecord::Base
	self.table_name = 'country'
	has_many :states

    comma do 
      name
    end
end
