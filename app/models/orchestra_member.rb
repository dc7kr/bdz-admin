class OrchestraMember < ApplicationRecord
  belongs_to :orchestra

  validates :date_of_birth, presence: true

  def age(year)
    year - date_of_birth.year
  end

  def is_birthday_valid?
    if date_of_birth.nil?
      false
    else
      date_of_birth.year <= Time.zone.now.year
    end
  end

  def is_dummy_birthday?
    if date_of_birth.nil?
      true
    else
      (date_of_birth.day == 1) && (date_of_birth.month == 2) && (date_of_birth.year == 1960)
    end
  end

  def year_of_birth
    if date_of_birth.nil?
      "N/A"
    else
      date_of_birth.year
    end
  end

  def age_category(year)
    if age(year) <= 14
      "C"
    elsif age(year) <= 18
      "T"
    elsif age(year) <= 27
      "Y"
    elsif age(year) <= 65
      "A"
    else
      "S"
    end
  end

  def exchange_first_and_lastname
    name = last_name
    first = first_name

    self.last_name = first
    self.first_name = name
  end
end
