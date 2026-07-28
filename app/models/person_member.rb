class PersonMember < ApplicationRecord
  acts_as_paranoid

  belongs_to :tariff

  has_one :member, as: :member_entity
  accepts_nested_attributes_for :member

  scope :nomail, lambda {
    joins(:member).where("members.email is null or members.email=''").order("members.mglnr")
  }

  scope :mail, lambda {
    joins(:member).where("members.email is not null and members.email <>''")
  }

  def self.cancelled
    PersonMember.joins(:member).where(
      "members.austritt_zum is not null and members.austritt_zum != '0000-00-00' and austritt_zum < ?", Time.zone.now
    )
  end

  def self.no_payment(before = nil, lv = nil)
    data = MemberAccountBooking.unbalanced_before_year(before, lv)

    ids = data[:ids]
    accounts = data[:accounts]

    members = Member.includes(:member_entity).where("member_entity_type='PersonMember' and id in (?)",
                                                    ids.to_a).order(:mglnr)

    h = {}

    h[:members] = members
    h[:accounts] = accounts

    h
  end

  def self.notinvoiced(year)
    joins(:member,
          :tariff).joins("LEFT JOIN member_account_bookings mb ON members.id=mb.member_id AND mb.booking_type='B' and mb.booking_year = #{year}").where("mb.id IS NULL and tariffs.amount >0 and members.eintritt < now()").order("members.mglnr")
  end

  def self.for_user(user)
    return where(1) unless user.is_restricted_role?

    restr = user.restricting_entity

    if restr.nil?
      Rails.logger.warning("User #{current_user.email} has no restriction entity configured - SAFETY NET!")
      return where("1=0")
      # safety net
    end

    if restr.instance_of?(RegionalOrganization)
      where(members: { regional_organization_id: restr.id })
    elsif restr.instance_of?(Orchestra)
      where(id: restr.id)
    elsif restr.instance_of?(PersonMember)
      where("1=0")
    end
  end

  def self.mailForEvent(event, via_paper)
    if via_paper
      joins([ :member ]).joins("LEFT JOIN member_events e ON members.id=e.member_id AND members.member_entity_id = person_members.id AND members.member_entity_type='PersonMember' AND e.event_id=?",event).where(e: { id: nil }).order("members.mglnr")
    else
      joins([ :member ]).joins("LEFT JOIN member_events e ON members.id=e.member_id AND members.member_entity_id = person_members.id AND members.member_entity_type='PersonMember' AND e.event_type='E' and e.event_id=?",event).where("members.email IS NOT NULL and length(members.email) >3 and e.id IS NULL")
    end
  end

  def self.search(search)
    if search
      where("members.mglnr = ? or members.name like ? or members.email like ?", search.to_s, "%#{search}%",
            "%#{search}%")
    else
      where("1")
    end
  end

  def fullname
    if member.nil?
      "---"
    else
      member.fullname
    end
  end

  delegate :letter_country, to: :member

  delegate :countryCode, to: :member

  def current_magazines(override = true)
    if member.magazines == -1
      return 0
    end

    return member.magazines
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
    current_magazines "Zeitungen"
  end

  def lvPart
    tariff.amount * 0.15
  end

  def address
    "#{member.address}, #{contact_info}"
  end

  def address_block
    "#{member.address_block}\n#{contact_info_block}"
  end

  delegate :direct_debit?, to: :member

  delegate :contact_info, to: :member

  def contact_info_block
    (telefonPrivat&.length&.positive? ? "Tel: #{telefonPrivat}, " : "") +
      (telefax&.length&.positive? ? "Fax: #{telefax}, " : "") +
      (member.email ? "#{member.email}, " : "")
  end

  delegate :iban, to: :member

  delegate :mandate_id, to: :member

  delegate :sig_date, to: :member

  def account_owner
    fullname
  end

  delegate :has_email?, to: :member

  def self.with_zero_balance(_year = nil)
    ids = Member.ids_with_non_zero_balance(PersonMember)

    pms = PersonMember.joins(:member)
    if not ids.empty?
      pms = pms.where("NOT (members.id  in (?) )", ids)
    end

    pms
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

  delegate :get_unbalanced_bookings, to: :member

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
    if tariff.amount.zero?
      Rails.logger.warning("Requested invoice generation with 0 amount: #{mglnr}")
      return
    end

    year = Time.zone.now.year if year.nil?

    invoice = CorikaInvoices::Invoice.new
    invoice.invoice_date = Time.zone.now
    invoice.booking_year = year
    invoice.template_subdir = "bdz"
    invoice.template = "beitragsrechnung"
    invoice.paid = false

    # taxfree
    invoice.tax_mode = "E"

    invoice.number = "#{member.mglnr}-BEITRAG#{year}"
    invoice.customer = to_customer

    c_hash = INVOICE_CONTACT_HASH["gs"]
    contact = CorikaInvoices::Contact.new(c_hash)
    invoice.contact = contact

    invoice.add_item(1, tariff.amount, "Beitrag #{tariff.description}", tax_rate: 0)

    invoice
  end

  def to_addressee
    addressee = member.to_addressee
    addressee.company      = company
    addressee.name         = fullname
    addressee.entity       = self
    addressee.event_class = event_class

    addressee
  end

  def magazine_address_list_row
    return if current_magazines.zero?

    {
      identifier: member.mglnr,
      company: "",
      department: "",
      fullname: member.fullname,
      street: member.strasse,
      countryCode: member.countryCode,
      zip: member.plz,
      city: member.ort,
      country: member.letter_country,
      magazines: current_magazines
    }
  end
end
