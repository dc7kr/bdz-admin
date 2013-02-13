class ContactPerson < ActiveRecord::Base
  attr_accessible :city, :country, :email, :first_name, :last_name, :phone, :salutation, :street, :zip

  belongs_to :country
end
