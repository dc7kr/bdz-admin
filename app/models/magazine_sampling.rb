class MagazineSampling < ApplicationRecord
  #attr_accessible :count
  has_one :contact, as: :contact_entity, dependent: :destroy
  accepts_nested_attributes_for :contact

  def fullname
    contact.fullname
  end

  def magazine_address_list_row
    if ( current_count >0) then
      csvrow = {
        :mglnr=>member.mglnr,
        :name=> contact.company,
        :name2=>contact.department,
        :fullname=>contact.fullname,
        :strasse=>contact.street,
        :countryCode=>contact.countryCode,
        :plz=>contact.zip,
        :ort=>contact.city,
        :land=>contact.letterCountry,
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
end
