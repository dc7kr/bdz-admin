module ReportSheetInputsHelper
  def birthyear_class(member)
    if member.date_of_birth.nil? || !member.is_birthday_valid?
      'invalid'
    elsif member.is_dummy_birthday?
      'warning'
    else
      ''
    end
  end

  def memberToAgeCategory(dob, year)
    age = if dob.nil?
            30
          else
            year - dob.year
          end

    category = [' ', ' ', ' ', ' ', ' ']

    if age <= 14
      category[0] = 'x'
    elsif age <= 17
      category[1] = 'x'
    elsif age <= 27
      category[2] = 'x'
    elsif age <= 65
      category[3] = 'x'
    else
      category[4] = 'x'
    end

    category
  end
end
