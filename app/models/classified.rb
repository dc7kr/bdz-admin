class Classified < ActiveRecord::Base
	scope :inactive, where('visible=0')

end
