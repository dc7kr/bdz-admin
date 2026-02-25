require "valid_email"
class Orchestra < ApplicationRecord


  acts_as_paranoid

  has_one :member, as: :member_entity
  has_many :report_sheets
  has_many :orchestra_contacts
  has_many :orchestra_members

  accepts_nested_attributes_for :member

  validates :orchName, presence: true

  scope :cancelled, lambda {
    joins(:member).where("members.austritt_zum is not null and members.austritt_zum != '0000-00-00' and austritt_zum < now()")
  }

  scope :this_year, lambda {
    joins(:member)
  }

  scope :member_next_year, lambda {
    joins(:member).where("members.austritt_zum is null or members.austritt_zum = '0000-00-00' or year(members.austritt_zum) > year(now())")
  }

  scope :nomail, lambda {
    joins(:member).where("members.email is null or members.email=''").order("members.mglnr")
  }

  scope :mail, lambda {
    joins(:member).where("members.email is not null and members.email <>''")
  }

  scope :regular, -> { where("orch_type <> ? ", "X") }
  scope :regional, -> { where("orch_type = 'L' ") }

  scope :no_report_sheet, lambda { |year|
    includes([ :member ]).joins("LEFT JOIN report_sheets ON report_sheets.orchestra_id = orchestras.id AND report_sheets.year=#{String(year)}").where([ 'report_sheets.id IS NULL AND orchestras.orch_type in ( "L","O")' ])
  }

  def self.no_payment(before = nil, lv = nil)
    data = MemberAccountBooking.unbalanced_before_year(before, lv)

    ids = data[:ids]
    accounts = data[:accounts]

    members = Member.includes(:member_entity).where("member_entity_type='Orchestra' and id in (?)",
                                                    ids.to_a).order(:mglnr)

    h = {}

    h[:members] = members
    h[:accounts] = accounts

    h
  end

  def self.for_mglnr(mglnr)
    member = Member.find_by("mglnr = ?", mglnr)

    if member.nil? || !member.member_entity.is_a?(Orchestra)
      nil
    else
      member.member_entity
    end
  end

  # inherits_from :member

  # validates :mglnr, :orch_mglnr => true

  def self.notinvoiced(year)
    normal = joins(:member).joins("LEFT JOIN member_account_bookings mb ON members.id=mb.member_id AND mb.booking_type='B' and mb.booking_year = #{year}").where("mb.id IS NULL AND orchestras.orch_type <> 'X'").order("members.mglnr")
    joins(:member).joins("LEFT JOIN member_account_bookings mb ON members.id=mb.member_id AND mb.booking_type='B' and mb.booking_year = #{year}").where("mb.id IS NULL AND orch_type='K'")

    normal
  end

  def self.mailForEvent(event, via_paper)
    if via_paper
      joins([ :member ]).joins("LEFT JOIN member_events e ON members.id=e.member_id AND members.member_entity_id = orchestras.id AND members.member_entity_type='Orchestra' AND e.event_id='#{event}'").where(e: { id: nil })
    else
      joins([ :member ]).joins("LEFT JOIN member_events e ON members.id=e.member_id AND members.member_entity_id = orchestras.id AND members.member_entity_type='Orchestra' AND e.event_type='E' and e.event_id='#{event}'").where("members.email IS NOT NULL and length(members.email) >3 and e.id IS NULL")
    end
  end

  def self.mail
    Member.mail(Orchestra)
  end

  def self.search(search)
    if search
      where("members.mglnr = ? or orchestras.orchName like ? or members.email like ?", search.to_s, "%#{search}%",
            "%#{search}%")
    else
      where("1")
    end
  end

  def cleanOrchName
    orchName.gsub("'", "").gsub(";", '\n')
  end

  def inlineFullAddress
    "#{fullname}, #{inlineAddress}"
  end

  def inlineAddress
    "#{member.strasse}, #{member.plz} #{member.ort}"
  end

  def lastReportSheet
    @reportSheets = ReportSheet.where(orchestra_id: id).order("year desc")
    @reportSheets[0]
  end

  def report_sheet_for_year(year)
    year = Time.zone.now.year if year.nil?

    rs = report_sheets.where(year: year)

    return unless rs

    rs.first
  end

  def currentMagazines(override = true)
    return BDZ_SETTINGS["tariff"]["koopZtgCount"].to_i if is_coop?

    return member.magazines if (member.magazines >= 0) && override

    if currentReportSheet
      currentReportSheet.calcZeitungen
    elsif lastReportSheet.nil?
      Rails.logger.info("No reportsheet for orchestra : #{member.mglnr}")
      0
    else
      lastReportSheet.calcZeitungen
    end
  end

  def gema(year = nil)
    rs = report_sheet_for_year(year)
    return unless rs

    rs.calcGemaCount
  end

  def total(year = nil)
    rs = report_sheet_for_year(year)

    return unless rs

    rs.totalActiveMembers
  end

  def lv_share(year = nil)
    rs = report_sheet_for_year(year)
    return unless rs

    rs.calcLvPart
  end

  def age_key_str(year)
    rs = report_sheet_for_year(year)
    if rs
      rs.ageKeyStr
    else
      " kein Meldebogen"
    end
  end

  def currentLvRate
    return unless currentReportSheet

    currentReportSheet.lvRate
  end

  def sheet_for_year(year)
    report_sheets.each do |sheet|
      return sheet if sheet.year == year
    end
    nil
  end

  def gen_invoice(year)
    invoice = CorikaInvoices::Invoice.new
    invoice.invoice_date = Time.zone.now
    invoice.booking_year = year
    invoice.template_subdir = "bdz"
    invoice.template = "beitragsrechnung"
    invoice.paid = false

    invoice.number_suffix = "#{member.mglnr}-BEITRAG#{year}"
    invoice.number_format = "%d-%s"

    # this ensures that the invoice number is unique (generates -XX suffix)
    invoice.make_distinct

    # taxfree
    invoice.tax_mode = "E"

    cust = to_customer

    invoice.customer = cust


    c_hash = INVOICE_CONTACT_HASH["gs"]
    contact = CorikaInvoices::Contact.new(c_hash)
    invoice.contact = contact

    if is_coop?
      invoice.add_item(1, Prices.coopRate, "Beitrag kooperativ")
    elsif is_foreign_coop?
      invoice.add_item(1, Prices.foreignCoopRate, "Auslandsorchesterbeitrag")
    else
      sheet = sheet_for_year(year)

      if sheet.nil? && !is_coop?
        Rails.logger.info("No Sheet for orchestra #{self} and year#{year}")
        return nil
      end

      sheet.add_invoice_items(invoice)
    end

    invoice
  end

  def currentReportSheet
    #	ReportSheet.scoped(:conditions=> { :year => @currentYear })
    # TODO:
    currentYear = Time.zone.now.year
    report_sheets.each do |sheet|
      return sheet if sheet.year == currentYear
    end
    nil
  end

  comma :minimal do
    mglnr "Mitgliedsnummer"
    orchName "Orchestername"
    inlineFullAddress "Adresse"
  end

  # CSV
  comma :gema do
    member.mglnr "Mitgliedsnummer"
    orchName "Orchestername"
    inlineFullAddress "Adresse"
    gema "Mitglieder"
  end

  comma :magazine do
    currentMagazines "Zeitungen"
    cleanOrchName
    fullname
    strasse
    plz
    ort
    letter_country
  end

  comma :lv do
    member.mglnr
    cleanOrchName
    fullname
    member.strasse
    member.plz
    member.ort
    member.email
  end

  def letter_country(delivery = nil)
    if !delivery.nil? && delivery_contact.present?
      delivery_contact.letter_country
    else
      member.letter_country
    end
  end

  def countryCode(delivery = nil)
    if !delivery.nil? && delivery_contact.present?
      delivery_contact.country_code
    else
      member.countryCode
    end
  end

  def fullname(delivery = nil)
    if !delivery.nil? && !delivery_contact.nil?
      delivery_contact.fullname
    elsif !member.anrede.nil? && member.anrede.length.positive?
      "#{I18n.t("common.salutation_d.#{member.anrede}")} #{member.fullname}"
    else
      member.fullname
    end
  end

  def address
    "#{orchName}, #{member.address}"
  end

  def address_block
    "#{orchName}\n#{member.address_block}"
  end

  def is_coop?
    orch_type == "K"
  end

  def is_foreign_coop?
    orch_type == "A"
  end

  def is_lorch?
    orch_type == "L"
  end

  def is_regular?
    orch_type == "O"
  end

  delegate :direct_debit?, to: :member

  def has_notify_event?(event_id)
    member.has_event?(%w[E L], event_id)
  end

  delegate :iban, to: :member

  delegate :mref, to: :member

  delegate :has_event?, to: :member

  def self.with_zero_balance(year = nil)
    ids = Member.ids_with_non_zero_balance(Orchestra, year)

    # nasty workaround for ActiveRecord bug (KR 24.2.20)
    if ids.empty?
      Orchestra.includes(:report_sheets).joins(:member)
    else
      Orchestra.includes(:report_sheets).joins(:member).where("NOT (members.id  in (?) )", ids)
    end
  end

  # for address interface
  def company
    orchName
  end

  def street(delivery = nil)
    if !delivery.nil? && !delivery_contact.nil?
      delivery_contact.street
    else
      member.strasse
    end
  end

  def zip(delivery = nil)
    if !delivery.nil? && !delivery_contact.nil?
      delivery_contact.zip
    else
      member.plz
    end
  end

  def city(delivery = nil)
    if !delivery.nil? && !delivery_contact.nil?
      delivery_contact.city
    else
      member.ort
    end
  end

  delegate :mandate_id, to: :member

  def account_owner
    orchName
  end

  delegate :has_email?, to: :member

  delegate :sig_date, to: :member

  def to_addressee
    addressee = member.to_addressee

    addressee.name         = fullname
    addressee.company      = orchName
    addressee.entity       = self
    addressee.event_class = event_class

    addressee
  end

  def to_customer
    cust = member.to_customer
    cust.entity = self

    cust.company = orchName
    cust.account_owner = orchName

    orch_inv_contact = invoice_contact

    if orch_inv_contact.present?
      hash = orch_inv_contact.to_hash
      cust.overwrite_with(hash)
   end

    cust
  end

  # for member event handling

  delegate :get_unbalanced_bookings, to: :member

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

  def contacts_by_role
    result = {}
    orchestra_contacts.each do |oc|
      result[oc.role] = oc
    end
    result
  end

  def event_class
    MemberEvent
  end

  delegate :contact_info, to: :member

  delegate :last_invoice, to: :member

  def to_s
    orchName
  end

  def full_url
    if url.start_with?("http")
      url
    else
      "http://#{url}"
    end
  end

  def get_member_fee_booking(_year)
    MemberAccountBooking.where("member_id = :member_id AND booking_type='B' AND mb.booking_year = :booking_year",
                               member_id: member.id, booking_year: :year)
  end

  def check_double
    result = {}

    result[:faulty] = []
    result[:verified] = []
    result[:neutral] = []

    orchestra_members.each do |o|
      if !o.mglnr.nil? && (o.mglnr != 0) && (o.mglnr != member.mglnr)
        orch = Orchestra.joins(:member).where(members: { mglnr: o.mglnr })

        if !orch.nil? && !orch[0].nil?
          Rails.logger.info("Found orchestra")
          matching = OrchestraMember.where("orchestra_id = ? and first_name like ? and last_name like ?", orch[0].id,
                                           o.first_name, o.last_name).first

          if matching.nil?
            result[:faulty] << o
          else
            other_orch = matching.orchestra

            if other_orch.is_coop? || other_orch.is_lorch?
              result[:faulty] << o
            else
              result[:verified] << o
            end
          end
        else
          Rails.logger.info("Invalid mglnr: #{o.mglnr}")
          result[:faulty] << o
        end
      else
        result[:neutral] << o
      end
    end

    result
  end

  def report_sheet_required?
    # foreign orchestras and special members
    orch_type != "X" and orch_type != "A"
  end

  def has_faulty_double_members?
    result = check_double

    result[:faulty].count != 0
  end

  def current_rsi
    year = Time.zone.now.year
    ReportSheetInput.for_orchestra_and_year(self, year)
  end

  def has_rsi?
    !current_rsi.nil?
  end

  def gen_rsi(rs_year)
    rsi = ReportSheetInput.for_orchestra_and_year(self, rs_year)

    unless rsi.nil?
      logger.warn("Report sheet already exists for %s", rs_year.to_s)
      return rsi
    end

    rsi = ReportSheetInput.new_for_orchestra(self, rs_year)

    if rsi.report_sheet.save
      rsi.save
    else
      logger.warn(rsi.report_sheet.errors.full_messages.join("\n"))
      logger.warn("Something went wrong during save of report sheet!")
    end
  end

  def magazine_address_list_row
    mag_count = currentMagazines
    return unless mag_count.positive?

    {
      identifier: member.mglnr,
      company: orchName,
      fullname: fullname(:delivery),
      department: "",
      street: street(:delivery),
      countryCode: countryCode(:delivery),
      zip: zip(:delivery),
      city: city(:delivery),
      country: letter_country,
      magazines: currentMagazines
    }
  end

  def find_contact(role: )
    orchestra_contacts.find_by(role: role)
  end

  def invoice_contact
    find_contact(role: "R")
  end

  def delivery_contact
    find_contact(role: "Z")
  end

  def age(year = Time.now.year)
    if gruendung.present?
      year-gruendung.year
    else
      nil
    end
  end
end
