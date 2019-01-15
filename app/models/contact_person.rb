class ContactPerson < ApplicationRecord

  belongs_to :festival_application
  include CountryHelper

  def self.nested_params
    [ :salutation, :first_name, :last_name, :street, :zip, :city, :country_code, :email, :phone ]
  end

  validates :last_name, :first_name, :email, :phone, :presence => true
  validates :email, :email_format => true 

  has_many :contact_events

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

  def t_country(locale="de")
    translated_country(country_code,locale)
  end

  def has_email? 
    not email.nil?
  end


  def event_class
    ContactEvent
  end

  def to_addressee
    addressee = Addressee.new
    addressee.email        = self.email
    addressee.street       = self.street
    addressee.zip          = self.zip
    addressee.city         = self.city
    addressee.country_code = self.country_code
    addressee.id           = self.id
    addressee.email        = self.email
    addressee.event_entity_id = self.id
    addressee.event_class = self.event_class
    addressee.entity = self

    addressee
  end
end
