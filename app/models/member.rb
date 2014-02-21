require 'blz_validator'
require 'iban_validator'

class Member < ActiveRecord::Base
  acts_as_superclass

  include CountryHelper

  validates :iban, :iban => true
  validates :bic, :bic => true
  validates :email, :email_format => true 
  validates :mglnr, :uniqueness => true

  belongs_to :regional_organization

  has_many :member_account_bookings

  def has_event?(event_type,event_id)
	  if event_type.kind_of?(Array) then
		  MemberEvent.where("member_id = :id and event_type in (:event_type) and event_id = :event_id",:event_id=>event_id,:event_type=>event_type,:id=>id).count > 0
	  else 
		  MemberEvent.where("member_id = :id and event_type = :event_type and event_id = :event_id",:event_id=>event_id,:event_type=>event_type,:id=>id).count > 0
	  end
  end

  def is_direct_debit?
	  za == 'L'
  end
  def fullname 
     result =''
     if ( vorname ) 
      result = result + vorname + ' '
     end
     if (name) 
      result = result + name
     end
     return result
  end

  def letterCountry
	  if country_code == nil 
		  return ""
	  else
		  return country_code.upcase
	  end
  end

  def countryCode 
	  if country_code == nil 
		  return ""
	  else
		  return country_code
	  end
  end

  def iban_calc
    compute_iban(konto,blz)

  end

  def mref
    "BDZBEITRAG"+mglnr.to_s
  end

  def address
    fullname + ", " +strasse + ", "+plz+ " "+ort
  end


  def t_country(locale=country_code)
    translated_country(country_code,locale)
  end

  def address_block
	  fullname+"\n"+
	  strasse+"\n"+
	  plz+" "+ort
  end

  def has_email?
    not email.nil? and email.length > 3
  end

  def mandate_id
    "BDZBEITRAG"+mglnr.to_s
  end

  def sig_date
    # TODO
    return Date.new(2014,1,1)
  end

  def event_class
    MemberEvent
  end
end
