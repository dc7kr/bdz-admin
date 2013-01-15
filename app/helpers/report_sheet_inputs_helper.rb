module ReportSheetInputsHelper

def memberToAgeCategory(dob,year)

	age = nil
	if ( dob != nil) then
		age = year-dob.year 
	else
		age = 30
	end

	category = [ " "," "," "," "," "]

	if age <= 14 then
		category[0]="x"
	elsif age <= 18 then
		category[1]="x"
	elsif age <= 27 then
		category[2]="x"
	elsif age <= 55 then 
		category[3]="x"
	else
		category[4]="x"
	end

	return category
end

end
