class ContactPerson < ActiveRecord::Base
  include CountryHelper

  attr_accessible :city, :country_code, :email, :first_name, :last_name, :phone, :salutation, :street, :zip,:country_code

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
end
