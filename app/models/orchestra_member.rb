class OrchestraMember < ActiveRecord::Base
  belongs_to :orchestra

  def age(year)
	year - date_of_birth.year
  end

  def is_dummy_birthday?
	if ( date_of_birth == nil ) then
		false
	elsif ( date_of_birth.day == 1 and date_of_birth.month == 2 and date_of_birth.year == 1960 ) then
		true
	else
		false
	end

  end
  def year_of_birth
	if (date_of_birth != nil ) then
		date_of_birth.year
	else
		"N/A"
	end
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
