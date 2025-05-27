class MagazineSampling < ApplicationRecord
  # attr_accessible :count
  has_one :contact, as: :contact_entity, dependent: :destroy
  accepts_nested_attributes_for :contact

  scope :active, lambda {
    joins(:contact).where("inactive=0")
  }

  delegate :fullname, to: :contact

  def magazine_address_list_row
    return unless current_count.positive?

    {
      identifier: "B_#{id}",
      company: contact.company,
      department: contact.department,
      fullname: contact.fullname,
      street: contact.street,
      countryCode: contact.country_code,
      zip: contact.zip,
      city: contact.city,
      country: contact.letter_country,
      magazines: count
    }
  end

  def t_country
    if country_code == "DE"
      ""
    else
      contact.t_country("en")
    end
  end

  def current_count
    if inactive
      0
    else
      count
    end
  end

  delegate :one_line_addr, to: :contact
end
