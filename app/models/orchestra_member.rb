class OrchestraMember < ActiveRecord::Base
  belongs_to :orchestra

  def age(year)
	year - date_of_birth.year
  end


  def age_category(year)
	if age(year) <= 14 then
		return "C"
	elsif age(year) <= 19 then 
		return "T"
	elsif age(year) <= 27 then
		return "Y"
	elsif age(year) <= 55 then
		return "A"
	else 
		return "S"
	end
  end
		
	
end
