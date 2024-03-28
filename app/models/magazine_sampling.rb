class MagazineSampling < ApplicationRecord
  #attr_accessible :count
  has_one :contact, as: :contact_entity, dependent: :destroy
  accepts_nested_attributes_for :contact

  scope :active, -> {
    joins(:contact).where("inactive=0")
  }


  def fullname
    contact.fullname
  end

  def magazine_address_list_row
    if ( current_count >0) then
      csvrow = {
        :identifier=> "B_"+id.to_s,
        :company=> contact.company,
        :department=>contact.department,
        :fullname=>contact.fullname,
        :street=>contact.street,
        :countryCode=>contact.country_code,
        :zip=>contact.zip,
        :city=>contact.city,
        :country=>contact.letter_country,
        :magazines=>count
      }
      return csvrow
    else
      nil
    end
  end

  def t_country
    if country_code != "DE" then 
      contact.t_country("en")
    else
      ""
    end
  end

  def current_count
    if not inactive
      count
    else
      0
    end
  end

  def one_line_addr
    contact.one_line_addr
  end
end
