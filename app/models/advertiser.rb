class Advertiser < ApplicationRecord
	#attr_accessible :advert_type

  include Authority::Abilities

  validates :iban, :iban => true
  validates :bic, :bic => true
  validates_uniqueness_of :customer_number
  validates_presence_of :customer_number

  has_one :contact, as: :contact_entity

  accepts_nested_attributes_for :contact

  scope :active, -> {
    joins(:contact).where("active=1")
  }



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


  def current_count
    if active
      magazines
    else  
      0
    end
  end

  def magazine_address_list_row
    if ( current_count >0) then
      csvrow = {
        :company=> contact.company,
        :identifier => customer_number,
        :department=>contact.department,
        :fullname=>contact.fullname,
        :street=>contact.street,
        :countryCode=>contact.country_code,
        :zip=>contact.zip,
        :city=>contact.city,
        :country=>contact.letter_country,
        :magazines=>magazines
      }
      return csvrow
    else
      nil
    end
  end

end
