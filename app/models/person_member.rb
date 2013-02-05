class PersonMember < ActiveRecord::Base
  inherits_from :member
  belongs_to :tariff

  scope :cancelled, includes(:member).where("members.austritt_zum is not null and members.austritt_zum != '0000-00-00' and austritt_zum < now()")
  scope :nomail,includes(:member).where('members.email IS NULL')

  def self.mailForEvent(event)
		includes([:member]).joins("LEFT JOIN member_events e ON person_members.member_id=e.member_id AND e.event_type='E' and e.event_id='"+event+"'").where("members.email IS NOT NULL and length(members.email) >3 and e.id IS NULL")
  end

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
  def letterCountry
	member.letterCountry
  end

  def countryCode
	member.countryCode
  end

  def currentMagazines
		zeitungen+zusatzzeitung
  end

  comma :minimal do
	mglnr
	vorname
	name
	strasse
	plz
	ort
	letterCountry
  end
  comma :magazine do
	mglnr
	vorname
	name
    strasse
    plz
    ort
	letterCountry
	currentMagazines 'Zeitungen'
  end

  comma :lv do
	mglnr
	anrede
	vorname
	name
	strasse
	plz
	ort
  end

  def lvPart
	tariff.amount*0.15
  end

  def address
    member.address+", "+contact_info
  end

  def address_block
	member.address_block+"\n"+
	contact_info_block
	
  end


  def contact_info
	(telefonPrivat && telefonPrivat.length >0 ? "Tel: "+ telefonPrivat+", " :"" )+
	(telefax && telefax.length >0 ? "Fax: "+ telefax+", " :"" )+
	(member.email ? member.email+", " : "") 
  end
  def contact_info_block 
	(telefonPrivat && telefonPrivat.length >0 ? "Tel: "+ telefonPrivat+", " :"" )+
	(telefax && telefax.length >0 ? "Fax: "+ telefax+", " :"" )+
	(member.email ? member.email+", " : "") 
  end

  def iban
	member.iban
  end

end
