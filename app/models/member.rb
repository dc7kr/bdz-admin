require 'blz_validator'

class Member < ActiveRecord::Base
  acts_as_superclass

  validates :blz , :blz => true
  validates :konto, :konto => true
  validates :email, :email_format => true 
  validates :mglnr, :uniqueness => true
  belongs_to :regional_organization
  belongs_to :country

  has_many :member_account_bookings

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
	if country == nil || country.id==81 
		return ""
	else
		return country.name.upcase
	end
  end

  def countryCode 
	if country == nil || country.id==81
		return ""
	else
		return country.ccode.upcase
	end
  end
end


