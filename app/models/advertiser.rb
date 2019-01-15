require 'iban_validator'

class Advertiser < ApplicationRecord
	#attr_accessible :advert_type

  include Authority::Abilities

  validates :iban, :iban => true
  validates :bic, :bic => true
  validates_uniqueness_of :customer_number
  validates_presence_of :customer_number

  has_one :contact, as: :contact_entity

  accepts_nested_attributes_for :contact


  self.authorizer_name = 'MagazineContextAuthorizer'

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
    c = CorikaInvoices::Customer.new

    c
  end
end
