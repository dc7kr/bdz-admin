require 'blz_validator'
require 'iban_validator'

class Member < ActiveRecord::Base
  acts_as_superclass

  validates :blz , :blz => true
  validates :iban, :iban => true
  validates :konto, :konto => true
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
	  if konto == nil or konto == 0 or blz ==nil 
		  return nil
	  end
  	de_suffix = "131400"
  	padded_kto =  "%010d" % konto
  	suffix = blz+ padded_kto+de_suffix
  	check_digits = 98- (suffix.to_i % 97)
  	iban = "DE"+ ("%02d" % check_digits) + blz+padded_kto

    return iban
  end

  def mref
    "BDZBEITRAG"+mglnr.to_s
  end

  def address
    fullname + ", " +strasse + ", "+plz+ " "+ort
  end

  def address_block
	  fullname+"\n"+
	  strasse+"\n"+
	  plz+" "+ort
  end
end
