class Member < ActiveRecord::Base
  acts_as_superclass
  belongs_to :regional_organization
  belongs_to :country

  has_many :member_account_bookings

end


