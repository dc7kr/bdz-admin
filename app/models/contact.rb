class Contact < ActiveRecord::Base

  include CountryHelper

  acts_as_superclass

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
end
