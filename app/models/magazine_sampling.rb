class MagazineSampling < ActiveRecord::Base
  #attr_accessible :count

  inherits_from :contact
  def fullname
    contact.fullname
  end
end
