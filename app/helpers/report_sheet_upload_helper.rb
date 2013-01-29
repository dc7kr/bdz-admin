require 'rubygems'
require 'roo'

module ReportSheetUploadHelper

ROLES = ['','','V','S','G','D','J','O' ]

def read_report(doc,orchestra)
	#read_contacts(doc,orchestra)
	read_members(doc,orchestra)
end

	
def open_report_spreadsheet(filename,uploaded_file)
	if filename.end_with?(".ods") then
		Openoffice.new(uploaded_file)
	elsif filename.end_with?(".xls") then	
		Excel.new(uploaded_file)
	else
		nil
	end
end	

def float_to_int(val)
  if ( val.kind_of? Float ) then
    val.to_i
  else
    val
  end
end

def read_members(doc,orchestra)
  doc.default_sheet='Mitglieder'
  i=0
  @error_count=0
  @success_count=0

  2.upto(doc.last_row) do |line|
    if (doc.cell(line,'A') != nil ) then
      i=i+1
      first_name = doc.cell(line,'A')
      last_name = doc.cell(line,'B')
      
      member_id = doc.cell(line,'C')

	  dob_celltype = doc.celltype(line,'D')
	  date_of_birth=nil
	  if ( dob_celltype == :date ) then 
        date_of_birth =doc.cell(line,'D')
	  elsif (dob_celltype == :string ) then 
		year_of_birth = doc.cell(line,'D').to_i
		date_of_birth = Date.new(year_of_birth,1,1)
	  else 
      	year_of_birth = float_to_int(doc.cell(line,'D'))
		if (year_of_birth != nil ) then
			date_of_birth = Date.new(year_of_birth,1,1)
		else 
			year_of_birth = 1960
			date_of_birth= Date.new(year_of_birth,2,1)
		end
	  end
      instrument = doc.cell(line,'E')

      if instrument == nil then
			instrument = ''
      end

      Rails.logger.info i.to_s+":"+first_name+" "+last_name+"###"+date_of_birth.to_s+"###"+instrument
	  c = OrchestraMember.new
	  c.first_name = first_name
	  c.last_name = last_name
	  c.date_of_birth = date_of_birth
      if member_id != nil then
		c.mglnr = member_id
      end
	  c.instrument = instrument
	  c.orchestra = orchestra

      begin 
      	c.save
       	@success_count=@success_count+1
	  rescue
		Rails.logger.warn("Database Exception")
		@error_count=@error_count+1
 	  end
    end
  end
end

def read_contacts(doc,orchestra)
  doc.default_sheet = 'Kontakte'
  2.upto(6) do |line|
    role = ROLES[line]
    salutation = doc.cell(line,'B')
    first_name = doc.cell(line,'C')
    last_name = doc.cell(line,'D')
    street = doc.cell(line,'E')
    zip = float_to_int(doc.cell(line,'F'))
    city = doc.cell(line,'G')
    country=''
    phone = doc.cell(line,'H')
    email = doc.cell(line,'I')

	if ( salutation != nil and salutation[0] != '-') then
		contact = OrchestraContact.find_by_orchestra_id_and_role(orchestra.id,role)

		if ( contact == nil ) then
			contact = OrchestraContact.new
			contact.orchestra = orchestra
		end

		contact.role = role
		contact.salutation = salutation == 'Herr' ? "M" : "W"
		contact.first_name = first_name
		contact.last_name = last_name
		contact.street = street
		contact.zip = zip.to_s
		contact.city = city
		contact.country =''
		contact.phone = phone
		contact.email = email

		contact.save
	end
  end
end
end
