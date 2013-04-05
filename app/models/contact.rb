class Contact < ActiveRecord::Base

  acts_as_superclass

  belongs_to :country


  def to_s
    vorname+" "+name
  end

end
