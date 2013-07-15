class ContactPerson < ActiveRecord::Base
  attr_accessible :city, :country, :email, :first_name, :last_name, :phone, :salutation, :street, :zip,:country_id

  belongs_to :country

  validates :last_name, :first_name, :email, :phone, :presence => true
  validates :email, :email_format => true 

end
