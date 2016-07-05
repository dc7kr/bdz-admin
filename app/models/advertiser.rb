class Advertiser < ActiveRecord::Base
	#attr_accessible :advert_type

  has_one :contact, as: :contact_entity

  accepts_nested_attributes_for :contact

	def adv_id
		self.id
	end

  def customer_name
    if contact.company.nil? then
      contact.fullname
    else
      contact.company
    end
  end

  def fullname
   contact.fullname
  end
end
