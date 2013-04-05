class Function < ActiveRecord::Base
	inherits_from :contact
	belongs_to :regional_organization
end
