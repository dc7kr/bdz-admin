class Advertiser < ApplicationRecord
  # attr_accessible :advert_type

  include Authority::Abilities

  validates :iban, iban: true
  validates :bic, bic: true
  validates :customer_number, uniqueness: true
  validates :customer_number, presence: true

  has_one :contact, as: :contact_entity

  accepts_nested_attributes_for :contact

  scope :active, lambda {
    joins(:contact).where('active=1')
  }

  self.authorizer_name = 'MagazineContextAuthorizer'

  def adv_id
    id
  end

  def customer_name
    if contact.company.nil?
      contact.fullname
    else
      contact.company
    end
  end

  delegate :fullname, to: :contact

  def to_customer
    CorikaInvoices::Customer.new
  end

  def current_count
    if active
      magazines
    else
      0
    end
  end

  def magazine_address_list_row
    return unless current_count > 0

    {
      company: contact.company,
      identifier: customer_number,
      department: contact.department,
      fullname: contact.fullname,
      street: contact.street,
      countryCode: contact.country_code,
      zip: contact.zip,
      city: contact.city,
      country: contact.letter_country,
      magazines: magazines
    }
  end
end
