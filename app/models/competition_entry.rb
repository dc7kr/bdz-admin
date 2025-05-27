class CompetitionEntry < ApplicationRecord
  # attr_accessible :contact, :date_of_birth, :response1, :response2, :response3, :response4, :first_name, :last_name, :street, :zip, :city, :country_code, :email, :like, :missing, :improve, :winner

  validates :first_name, :last_name, :date_of_birth, :response1, :response2, :response3, :response4, presence: true
  validates :last_name, uniqueness: { scope: %i[first_name date_of_birth] }

  def self.drawable
    where("winner = false and correct=true")
  end

  def fullname
    result = ""
    result = "#{result}#{first_name} " if first_name
    result += last_name if last_name
    result
  end

  def check_responses
    resp1 = response1.strip
    resp2 = response2.strip
    resp3 = response3.strip
    resp4 = response4.strip

    correct = true

    correct = false if "Thomas Kronenberger".casecmp(resp1) != 0

    correct = false if "Nikolaus Neuroth".casecmp(resp2) != 0

    correct = false if "Marcel Wirtz".casecmp(resp3) != 0

    correct = false if "Steffen Trekel".casecmp(resp4) != 0
    self.correct = correct

    correct
  end
end
