class University < ActiveRecord::Base
	self.table_name = "hochschulen"

	belongs_to :country	
	
end
