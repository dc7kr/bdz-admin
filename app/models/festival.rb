class Festival < ActiveRecord::Base
	belongs_to :state, :foreign_key => "bland"
	belongs_to :country, :foreign_key => "land"


  def self.search(search)
	if (search)
		where('titel like ?',"%#{search}%");
	else
		scoped
	end
  end
end
