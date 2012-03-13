class Ensemble < ActiveRecord::Base
	belongs_to :user, :foreign_key => "owner"


  def self.search(search)
	if (search)
		where('name like ?',"%#{search}%")
	else
		scoped
	end
  end

  def self.inactive()
	where('visible=0')
  end
  def self.active()
	where('visible=1')
  end
end
