require 'rubygems'
require 'roo'

module ReportSheetUploadHelper
  ROLES = ['', '', 'V', 'S', 'G', 'D', 'J', 'O'].freeze

  def read_report(doc, orchestra)
    # read_contacts(doc,orchestra)
    read_members(doc, orchestra)
  end

  def open_report_spreadsheet(filename, uploaded_file)
    if filename.end_with?('.ods')
      Roo::OpenOffice.new(uploaded_file)
    elsif filename.end_with?('.xls')
      Roo::Excel.new(uploaded_file)
    end
  end

  def float_to_int(val)
    if val.is_a? Float
      val.to_i
    else
      val
    end
  end

  def read_members(doc, orchestra)
    doc.default_sheet = 'Mitglieder'
    i = 0
    @error_count = 0
    @success_count = 0

    2.upto(doc.last_row) do |line|
      next if doc.cell(line, 'A').nil?

      i += 1
      first_name = doc.cell(line, 'A')
      last_name = doc.cell(line, 'B')

      dob_celltype = doc.celltype(line, 'C')
      date_of_birth = nil

      if dob_celltype == :date
        date_of_birth = doc.cell(line, 'C')
      elsif dob_celltype == :string
        year_of_birth = doc.cell(line, 'C').to_i
        date_of_birth = Date.new(year_of_birth, 1, 1)
      else
        year_of_birth = float_to_int(doc.cell(line, 'C'))

        if year_of_birth.nil?
          year_of_birth = 1960
          date_of_birth = Date.new(year_of_birth, 2, 1)
        else
          date_of_birth = Date.new(year_of_birth, 1, 1)
        end
      end

      instrument = doc.cell(line, 'D')

      instrument = '' if instrument.nil?

      Rails.logger.info "#{i}:#{first_name} #{last_name}####{date_of_birth}####{instrument}"
      c = OrchestraMember.new
      c.first_name = first_name
      c.last_name = last_name
      c.date_of_birth = date_of_birth

      # DEPRECATED
      # if member_id != nil then
      #  c.mglnr = member_id
      # end

      c.instrument = instrument
      c.orchestra = orchestra

      begin
        c.save
        @success_count += 1
      rescue StandardError
        Rails.logger.warn('Database Exception')
        @error_count += 1
      end
    end
  end

  def read_contacts(doc, orchestra)
    doc.default_sheet = 'Kontakte'
    2.upto(6) do |line|
      role = ROLES[line]
      salutation = doc.cell(line, 'B')
      first_name = doc.cell(line, 'C')
      last_name = doc.cell(line, 'D')
      street = doc.cell(line, 'E')
      zip = float_to_int(doc.cell(line, 'F'))
      city = doc.cell(line, 'G')
      phone = doc.cell(line, 'H')
      email = doc.cell(line, 'I')

      next unless !salutation.nil? && (salutation[0] != '-')

      contact = OrchestraContact.find_by(orchestra_id: orchestra.id, role: role)

      if contact.nil?
        contact = OrchestraContact.new
        contact.orchestra = orchestra
      end

      contact.role = role
      contact.salutation = salutation == 'Herr' ? 'M' : 'W'
      contact.first_name = first_name
      contact.last_name = last_name
      contact.street = street
      contact.zip = zip.to_s
      contact.city = city
      contact.country = ''
      contact.phone = phone
      contact.email = email

      contact.save
    end
  end

  def verify_report(doc)
    doc.sheets.include? 'Mitglieder'
  end
end
