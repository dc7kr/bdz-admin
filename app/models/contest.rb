class Contest < ActiveRecord::Base
	self.table_name="wettbewerbe"
  
  def self.inactive()
	where('visible=0')
  end
  def self.active()
	where('visible=1')
  end
  def self.public()
    where('visible=1 and startDate >= now()')
  end
end
