class OrchestraContact < ApplicationRecord
  belongs_to :orchestra

  validates :email, :email_format => true 
	@@roles = [ "V", "S", "G", "D", "J", "O","Z" ]

  def self.permitted_params 
    [:role,:salutation,:first_name,:last_name,:street,:zip,:city,:country_code,:email,:phone]
  end

	def self.roles
		@@roles
	end

  def to_s
    data = [ "#{first_name} #{last_name}" , street, "#{zip} #{city}", phone, email ]
    data.join("\n")
  end
end
