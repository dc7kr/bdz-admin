class MagazineIssue < ActiveRecord::Base
  attr_accessible :number, :year
	

  has_many :magazine_adverts

  def full_number
    number.to_s+"-"+year.to_s
  end
end
