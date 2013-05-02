class Advertiser < ActiveRecord::Base
	#attr_accessible :advert_type
	inherits_from :contact

	def adv_id
		self.id
	end
end
