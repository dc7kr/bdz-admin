class MagazineSampling < ActiveRecord::Base
  #attr_accessible :count

  inherits_from :contact
  def fullname
    contact.fullname
  end

  def t_country
    if country_code != "de" then 
      contact.t_country("en")
    else
      ""
    end
  end
end
