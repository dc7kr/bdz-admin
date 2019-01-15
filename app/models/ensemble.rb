class Ensemble < ApplicationRecord
	belongs_to :user, :foreign_key => "owner"
	has_many :ensemble_concerts



  def self.search(search)
	if (search)
		where('name like ?',"%#{search}%")
	else
		where(1)
	end
  end

  def self.inactive
	where('visible=0')
  end
  def self.active
	where('visible=1')
  end
end
