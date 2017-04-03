require 'iban_validator'

class Advertiser < ActiveRecord::Base
	#attr_accessible :advert_type

  validates :iban, :iban => true
  validates :bic, :bic => true
  validates_uniqueness_of :customer_number

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

  def to_customer
    c = InvoiceCustomer.new

    c
  end
end
