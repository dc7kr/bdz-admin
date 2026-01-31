class Member < ApplicationRecord
  acts_as_paranoid
  # acts_as_superclass
  resourcify
  # 

  # attr_encrypted :iban, key: Rails.application.secrets.member_iban_key
  # attr_encrypted :bic, key: Rails.application.secrets.member_bic_key

  belongs_to :member_entity, polymorphic: true

  def self.nested_params
    %i[id regional_organization_id mglnr title anrede vorname name strasse plz ort email
       eintritt austritt_zum za konto blz zahler telefon fax bic iban country_code dsgvo dsgvo_date sepa_date sepa_mandate_nr magazines]
  end

  include CountryHelper

  validates :eintritt, :mglnr, presence: true
  validates :iban, iban: true
  validates :bic, bic: true
  validates :email, email_format: true
  validates :mglnr, uniqueness: true

  belongs_to :regional_organization

  has_many :member_account_bookings

  def has_event?(event_type, event_id)
    if event_type.is_a?(Array)
      MemberEvent.where("member_id = :id and event_type in (:event_type) and event_id = :event_id", event_id: event_id,
                                                                                                    event_type: event_type, id: id).count.positive?
    else
      MemberEvent.where("member_id = :id and event_type = :event_type and event_id = :event_id", event_id: event_id,
                                                                                                 event_type: event_type, id: id).count.positive?
    end
  end

  def direct_debit?
    za == "L" and valid?
  end

  def fullname
    result = ""
    result = "#{result}#{title} " if title
    result = "#{result}#{vorname} " if vorname
    result += name if name
    result
  end

  def letter_country
    return "" if country_code.nil?

    country_code.upcase
  end

  def countryCode
    return "" if country_code.nil?

    country_code
  end

  def iban_calc
    compute_iban(konto, blz)
  end

  def mref
    "BDZBEITRAG#{mglnr}"
  end

  def address
    "#{fullname}, #{strasse}, #{plz} #{ort}"
  end

  def t_country(locale = country_code)
    translated_country(country_code, locale)
  end

  def address_block
    "#{fullname}\n#{strasse}\n#{plz} #{ort}"
  end

  def has_email?
    !email.nil? and email.length > 3
  end

  def event_class
    MemberEvent
  end

  def to_customer
    dd = direct_debit?
    c = CorikaInvoices::Customer.new
    c.customer_id = mglnr
    c.direct_debit = dd
    c.salutation = anrede
    c.first_name = vorname
    c.last_name = name
    c.entity = self
    c.street = strasse
    c.zip = plz
    c.city = ort
    c.email = email
    c.country_code = country_code
    c.sig_date = sig_date
    c.mandate_id =  mandate_id
    c.account_owner = zahler
    c.company = ""


    if dd
      c.iban = iban
      c.bic = bic
    end

    c
  end

  def mandate_id
    sepa_mandate_nr.presence || "BDZBEITRAG#{mglnr}"
  end

  def sig_date
    Date.new(2014, 1, 1)
  end

  def get_unbalanced_bookings
    result = []
    bookings = MemberAccountBooking.where(member_id: id).order(:booking_date)
    sum = 0
    bookings.each do |booking|
      result << booking
      sum += booking.amount
      result.clear if sum.zero?
    end
    result
  end

  def last_invoice
    member_account_bookings.where("booking_type = 'B'").maximum(:booking_date)
  end

  def contact_info
    (telefon&.length&.positive? ? "Tel: #{telefon}, " : "") +
      (fax&.length&.positive? ? "Fax: #{fax}, " : "") +
      (email ? "#{email}, " : "")
  end

  def member_type
    logger.debug("Member class: #{member_entity.class}")
    if member_entity.is_a? Orchestra
      "O"
    elsif member_entity.is_a? PersonMember
      "EM"
    else
      "--"
    end
  end

  def self.nomail(type = nil)
    Rails.logger.debug { "type: #{type.name}" }
    if type.nil?
      where("email IS NULL or LENGTH(email) < 3")
    else
      where("email IS NULL or LENGTH(email) < 3 and member_entity_type=?", type.name)
    end
  end

  def self.mail(type = nil)
    if type.nil?
      where("email IS NOT NULL and length(email) >3")
    else
      where("email IS NOT NULL and length(email) >3 and member_entity_type=?", type.name)
    end
  end

  def self.ids_with_non_zero_balance(type = nil, year = nil)
    year = Time.zone.now.year if year.nil?

    accounts = if type.nil?
                 MemberAccountBooking.where(booking_year: ...year).group(:member).sum(:amount)
    else
                 MemberAccountBooking.includes(:member).where("booking_year < ? AND members.member_entity_type = ? ",
                                                              year, type).group(:member).sum(:amount)
    end

    ids = Set.new

    accounts.each do |account|
      ids.add(account[0]) if account[1] < -0.1
    end

    ids
  end

  def to_addressee
    addressee = Addressee.new
    addressee.email        = email
    addressee.street       = strasse
    addressee.zip          = plz
    addressee.city         = ort
    addressee.country_code = country_code
    addressee.id           = mglnr
    addressee.email        = email
    addressee.event_entity_id = id

    addressee
  end

  def last_payment
    booking = member_account_bookings.where("booking_type = ? or booking_type = ? ", "A",
                                            "L").order("booking_date desc").first

    if booking.nil?
      nil
    else
      booking.booking_date
    end
  end

  def create_invoice_delta_booking(year, amount, filename, booking_txt)
    booking = MemberAccountBooking.new_invoice(booking_txt, -1 * amount, mglnr.to_s)
    booking.member_id = id
    booking.booking_year = year
    booking.filename = filename
    booking.save

    booking
  end

  def create_invoice_booking(year, invoice, filename, booking_txt)
    booking = MemberAccountBooking.new_invoice(booking_txt, -1 * invoice.sum, mglnr.to_s)
    booking.member_id = id
    booking.booking_year = year
    booking.filename = filename
    booking.save

    booking
  end

  def create_credit_transfer(sepa_writer, year, booking_txt, amount)
    if amount.negative?
      Rails.logger.warn("Credit transfer amount must not be negative!")
      return false
    end

    customer = member_entity.to_customer

    if direct_debit?
      if sepa_writer.add_credit_transfer(customer, booking_txt, amount)
        booking = MemberAccountBooking.new_credit_transfer("Überweisung #{booking_txt}", amount)
        booking.member_id = id
        booking.booking_year = year
        booking.save

        booking
      else
        Rails.logger.warn("Could not create credit transfer")
        false
      end
    else
      false
    end
  end

  def create_dd_booking(sepa_writer, invoice, year, delta_amount = nil)
    customer = member_entity.to_customer

    booking_txt = "Rechnung Nr. #{invoice.number} #{mglnr}"

    if delta_amount.nil?
      amount = invoice.sum
    else
      amount = delta_amount
      booking_txt += " Nachzahlung"
    end

    return unless direct_debit?

    sepa_writer.add_direct_debit(customer, amount, booking_txt, "RCUR")
    booking = MemberAccountBooking.new_dd("Lastschrift #{booking_txt}", amount)
    booking.member_id = id
    booking.booking_year = year
    booking.invoice_id = invoice.id
    booking.save

    booking
  end

  def is_bic_valid?
    return false if bic.nil? || (bic.length < 8)

    country = bic[4..5]

    if country != "DE"
      # we can only verify german BICs
      return true
    end

    BIC_FINDER.exist?(bic)
  end

  def zero_member_fee_balance?
    booking_sum = MemberAccountBooking.where("member_id = ? and booking_type in ('B','A','L','Z','R')", id).sum(:amount)
    booking_sum > -0.1
  end
end
