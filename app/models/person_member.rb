class PersonMember < ActiveRecord::Base
	belongs_to :regional_organization
	belongs_to :country
end
