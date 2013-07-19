class ContactPerson < ActiveRecord::Base

  attr_accessible :city, :country, :email, :first_name, :last_name, :phone, :salutation, :street, :zip,:country_id

  belongs_to :country

  validates :last_name, :first_name, :email, :phone, :presence => true
  validates :email, :email_format => true 

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
end
