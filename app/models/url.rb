class Url < ActiveRecord::Base
	belongs_to :url_category, :foreign_key => "category";
	belongs_to :state, :foreign_key => "bland"
	belongs_to :country


    scope :public, where('visible=1')
	scope :inactive, where('visible=0')

end
