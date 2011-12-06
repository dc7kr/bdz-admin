class Ensemble < ActiveRecord::Base
	belongs_to :user, :foreign_key => "owner"
  def self.search(search)
	if (search)
		where('name like ?',"%#{search}%")
	else
		scoped
	end
  end
end
