class Country < ActiveRecord::Base
	set_table_name "country"
	has_many :states
end
