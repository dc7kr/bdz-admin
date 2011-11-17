class Festival < ActiveRecord::Base
	belongs_to :state, :foreign_key => "bland"
	belongs_to :country, :foreign_key => "land"
end
