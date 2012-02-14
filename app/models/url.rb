class Url < ActiveRecord::Base
	belongs_to :url_category, :foreign_key => "category";
	belongs_to :state, :foreign_key => "bland"
	belongs_to :country
end
