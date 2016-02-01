class PersonMember < ActiveRecord::Base
  inherits_from :member
  belongs_to :tariff

  validates_presence_of :tariff

  scope :cancelled, includes(:member).where("members.austritt_zum is not null and members.austritt_zum != '0000-00-00' and austritt_zum < ?", Time.now)
  scope :nomail,includes(:member).where('members.email IS NULL')


  def self.for_user(user)
    if (not user.is_restricted_role?) then
      return scoped
    end

    restr = user.restricting_entity

    if restr.nil? then
      Rails.logger.warning("User "+current_user.email+" has no restriction entity configured - SAFETY NET!")
      return where ("1=0") 
      # safety net
    end

    if restr.class == RegionalOrganization then
      where("members.regional_organization_id = ?",restr.id)
    elsif restr.class == Orchestra then
      where("id = ?", restr.id)
    elsif restr.class == PersonMember then
      where("1=0")
    end
  end

  def self.mailForEvent(event,via_paper)
    if ( via_paper ) then
      includes([:member]).joins("LEFT JOIN member_events e ON person_members.member_id=e.member_id AND e.event_id='"+event+"'").where("e.id IS NULL").order("members.mglnr")
    else
		  includes([:member]).joins("LEFT JOIN member_events e ON person_members.member_id=e.member_id AND e.event_type='E' and e.event_id='"+event+"'").where("members.email IS NOT NULL and length(members.email) >3 and e.id IS NULL").order("members.mglnr")
    end
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
	  email
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

  def is_direct_debit?
    member.is_direct_debit?
  end

  def contact_info
	  (telefon && telefon.length >0 ? "Tel: "+ telefon+", " :"" )+
	  (fax && fax.length >0 ? "Fax: "+ fax+", " :"" )+
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

  def mandate_id
    member.mandate_id
  end

  def sig_date
    member.sig_date
  end

  def account_owner
    return fullname
  end

  def has_email? 
    member.has_email?
  end

  def self.with_zero_balance(include_this_year=false)
    accounts=nil
    if include_this_year then
	    accounts = MemberAccountBooking.where("booking_year < ?",Time.now.year).sum(:amount,:group=>:member_id)
    else
	    accounts = MemberAccountBooking.where("booking_year < ?",Time.now.year).sum(:amount,:group=>:member_id)
    end

	  ids = Set.new
	  accounts.each do |account|
      if (account[1]<0) then
        ids.add(account[0])
	    end
	  end
	
	  person_members = PersonMember.includes([:member]).where("NOT (member_id  in (?) )",ids)
  end

  # address interface
  def company
    ""
  end

  def street
    member.strasse
  end

  def zip 
    member.plz
  end

  def city
    member.ort
  end

  def get_unbalanced_bookings
    member.get_unbalanced_bookings
  end

  # for event handling
  def event_class
    MemberEvent
  end

  def to_customer
    cust = member.to_customer
    cust.entity = self

    cust.name= fullname
    cust.account_owner = fullname

    cust
  end

  def gen_invoice(year)
    invoice = Invoice.new("Beitragsrechnung #{year}")
    invoice.customer = to_customer

    invoice << InvoiceItem.new(1,tariff.amount, 'Beitrag'+ tariff.description)

    invoice
  end
end
