class Subscriber < ActiveRecord::Base
  #attr_accessible :account, :bic, :contact_id

  inherits_from :contact

  def fullname
    contact.fullname
  end
end
