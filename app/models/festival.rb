class Festival < ActiveRecord::Base
	belongs_to :state, :foreign_key => "bland"

  scope :public, where('visible=1 and startdate >= now()')

  def self.search(search)
	if (search)
		where('titel like ?',"%#{search}%");
	else
		scoped
	end
  end
end
