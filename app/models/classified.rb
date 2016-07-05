class Classified < ActiveRecord::Base
  include Authority::Abilities
	scope :inactive, -> { where('visible=0')}

end
