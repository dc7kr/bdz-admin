class Url < ActiveRecord::Base
	belongs_to :url_category, :foreign_key => "category";
	belongs_to :state, :foreign_key => "bland"
	belongs_to :country


    scope :public, where('visible=1')
	scope :inactive, where('visible=0')

  def self.search(search)
	if (search)
		where('url like ? or titel like ?',"%#{search}%","%#{search}%");
	else
		scoped
	end
  end
end
