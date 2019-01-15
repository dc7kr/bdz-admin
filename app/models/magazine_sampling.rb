class MagazineSampling < ApplicationRecord
  #attr_accessible :count
  has_one :contact, as: :contact_entity
  accepts_nested_attributes_for :contact

  def fullname
    contact.fullname
  end

  def t_country
    if country_code != "DE" then 
      contact.t_country("en")
    else
      ""
    end
  end
end
