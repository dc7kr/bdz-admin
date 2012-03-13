require 'blz_validator'

class Member < ActiveRecord::Base
  acts_as_superclass

  validates :blz , :blz => true
  validates :konto, :konto => true
  belongs_to :regional_organization
  belongs_to :country

  has_many :member_account_bookings

end


