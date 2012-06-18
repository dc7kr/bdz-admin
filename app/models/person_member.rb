class PersonMember < ActiveRecord::Base
  inherits_from :member
  belongs_to :tariff

  def self.search(search)
	if (search)
		where('members.mglnr = ? or members.name like ?',"#{search}","%#{search}%")
	else
		scoped
	end
  end

  def fullname
	member.fullname
  end
  def address
    fullname + ", " +strasse + ", "+plz+ " "+ort
  end

  def letterCountry
	member.letterCountry
  end

  def countryCode
	member.countryCode
  end

  def currentMagazines
		zeitungen+zusatzzeitung
  end

  comma :magazine do
	mglnr
	fullname
    strasse
    plz
    ort
	letterCountry
	currentMagazines 'Zeitungen'
  end

  def lvPart
	tariff.amount*0.15
  end

end
