class Address < ActiveRecord::Base


  def to_s
    vorname+" "+name
  end

end
