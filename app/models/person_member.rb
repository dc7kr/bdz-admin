class PersonMember < ApplicationRecord
  belongs_to :tariff

  validates_presence_of :tariff
  
  has_one :member, as: :member_entity
  accepts_nested_attributes_for :member


  scope :nomail, -> {
    joins(:member).where("members.email is null or members.email=''").order("members.mglnr")
  }

  scope :mail, -> {
    joins(:member).where("members.email is not null and members.email <>''")
  }

  def self.cancelled 
    PersonMember.joins(:member).where("members.austritt_zum is not null and members.austritt_zum != '0000-00-00' and austritt_zum < ?", Time.now) 
  end

  def self.no_payment(before=nil,lv=nil)
    data = MemberAccountBooking.unbalanced_before_year(before,lv)

    ids = data[:ids]
    accounts = data[:accounts]

    members = Member.includes(:member_entity).where("member_entity_type='PersonMember' and id in (?)",ids.to_a).order(:mglnr)

    h = Hash.new

    h[:members]=members
    h[:accounts]=accounts

    h
  end

  def self.notinvoiced(year)
    joins(:member,:tariff).joins("LEFT JOIN member_account_bookings mb ON members.id=mb.member_id AND mb.booking_type='B' and mb.booking_year = #{year}" ).where("mb.id IS NULL and tariffs.amount >0").order("members.mglnr")
  end

  def self.for_user(user)
    if (not user.is_restricted_role?) then
      return where(1)
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
			joins([:member]).joins("LEFT JOIN member_events e ON members.id=e.member_id AND members.member_entity_id = person_members.id AND members.member_entity_type='PersonMember' AND e.event_id='"+event+"'").where("e.id IS NULL").order("members.mglnr")
    else
			joins([:member]).joins("LEFT JOIN member_events e ON members.id=e.member_id AND members.member_entity_id = person_members.id AND members.member_entity_type='PersonMember' AND e.event_type='E' and e.event_id='"+event+"'").where("members.email IS NOT NULL and length(members.email) >3 and e.id IS NULL")
    end
  end

  def self.search(search)
	  if (search)
		  where('members.mglnr = ? or members.name like ? or members.email like ?',"#{search}","%#{search}%","%#{search}%")
	  else
		  where("1")
	  end
  end

  def fullname
    if member.nil? then
      "---"
    else
	    member.fullname
    end
  end

  def letter_country
	  member.letter_country
  end

  def countryCode
	  member.countryCode
  end

  def currentMagazines(override=true)
    if member.magazines > 0 and override 
  		member.magazines
    elsif member.magazines < 0
      1
    else 
      0
    end
  end

  comma :minimal do
	  mglnr
	  vorname
	  name
	  strasse
	  plz
  	ort
	  letter_country
  end

  comma :magazine do
	  mglnr
	  vorname
	  name
    strasse
    plz
    ort
	  letter_country
	  currentMagazines 'Zeitungen'
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
	  member.contact_info
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

  def self.with_zero_balance(year=nil)
    ids = Member.ids_with_non_zero_balance(PersonMember)

	  person_members = PersonMember.joins(:member).where("NOT (members.id  in (?) )",ids)
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

    cust.account_owner = fullname

    cust
  end

  def gen_invoice(year)
    if ( self.tariff.amount == 0 )
      Rails.logger.warning("Requested invoice generation with 0 amount: #{mglnr}")
      return
    end

    if (year.nil?) then 
      year = Time.now.year
    end

    invoice = CorikaInvoices::Invoice.new
    invoice.invoice_date = Time.now
    invoice.invoice_type = "beitragsrechnung"

    # taxfree
    invoice.tax_type = "X"

    invoice.number = "#{member.mglnr}-BEITRAG#{year}"
    invoice.customer = to_customer

    invoice.addItem(1,tariff.amount, 'Beitrag '+ tariff.description)

    invoice
  end

  def to_addressee
    addressee = member.to_addressee
    addressee.company      = self.company
    addressee.name         = self.fullname
    addressee.entity       = self
    addressee.event_class = self.event_class

    addressee
  end

  def magazine_address_list_row
    if ( currentMagazines >0) then
      csvrow = {
        :identifier=>member.mglnr,
        :company=> '',
        :department=>'',
        :fullname=>member.fullname,
        :street=>member.strasse ,
        :countryCode=>member.countryCode,
        :zip=>member.plz,
        :city=>member.ort,
        :country=>member.letter_country,
        :magazines=>currentMagazines
      }
      return csvrow
    else
      nil
    end
  end

end
