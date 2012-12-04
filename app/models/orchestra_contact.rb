class OrchestraContact < ActiveRecord::Base
  belongs_to :orchestra

	@@roles = [ "V", "S", "G", "D", "J", "O" ]


	def self.roles
		@@roles
	end
end
