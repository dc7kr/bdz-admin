class Contest < ActiveRecord::Base
  include Authority::Abilities
  
  def self.inactive
	where('visible=0')
  end
  def self.active
	where('visible=1')
  end
  def self.published
    where('visible=1 and startDate >= now()')
  end
end
