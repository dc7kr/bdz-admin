class OrchestraMember < ActiveRecord::Base
  belongs_to :orchestra

  def age(year)
	year - date_of_birth.year
  end
	
end
