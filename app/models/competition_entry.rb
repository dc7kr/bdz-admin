class CompetitionEntry < ActiveRecord::Base
  attr_accessible :contact, :date_of_birth, :response1, :response2, :response3, :response4, :first_name, :last_name, :street, :zip, :city, :country_code, :email, :like, :missing, :improve, :winner

  validates_presence_of :first_name,:last_name,:response1,:response2,:response3,:response4

  def self.drawable
    where("winner = false and correct=true")
  end

  def fullname
     result =''
     if ( first_name ) 
      result = result + first_name + ' '
     end
     if (last_name) 
      result = result + last_name
     end
     return result
  end

  def check_responses
    resp1 = response1.strip
    resp2 = response2.strip
    resp3 = response3.strip
    resp4 = response4.strip

    correct=true

    if "Thomas Kronenberger".casecmp(resp1) != 0 then
      correct =false
    end

    if "Dominik Hackner".casecmp(resp2) != 0  then
      correct=false
    end

    if "Marcel Wirtz".casecmp(resp3) != 0  then
      correct=false
    end

    if "Steffen Trekel".casecmp(resp4) != 0  then
      correct=false
    end 
    self.correct=correct

    return correct
  end

end
