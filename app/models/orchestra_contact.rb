class OrchestraContact < ActiveRecord::Base
  belongs_to :orchestra

  validates :email, :email_format => true 
	@@roles = [ "V", "S", "G", "D", "J", "O" ]


	def self.roles
		@@roles
	end
end
