class MagazineIssue < ApplicationRecord
  
  # attr_accessible :number, :year

  has_many :magazine_adverts

  def full_number
    "#{number}-#{year}"
  end
end
