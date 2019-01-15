class Contact < ApplicationRecord

  include CountryHelper

  def self.nested_attributes
    [:id, :company, :first_name, :last_name, :street, :zip, :city, :country_code, :salutation, :phone, :fax, :office_phone, :email ]
  end

  belongs_to :contact_entity, polymorphic: true

  def to_s
    first_name+" "+last_name
  end

  def fullname
     result =''
     if ( first_name ) 
      result = result + first_name + ' '
     end
     if (last_name) 
      result = result + last_name
     end
     return result
  end

  def t_country(locale=country_code)
    translated_country(country_code,locale)
  end

  def to_customer
    c = CorikaInvoices::Customer.new
    c.salutation  = salutation
    c.first_name = vorname
    c.last_name = name
    c.entity = self
    c.street = strasse
    c.zip = plz
    c.city = ort
    c.email = email
    c.country = country_code

    c
  end
end
