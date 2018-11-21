require 'blz_validator'
require 'iban_validator'

class Member < ApplicationRecord

  acts_as_paranoid
  #acts_as_superclass
  resourcify
  #include Authority::Abilities

  #attr_encrypted :iban, key: Rails.application.secrets.member_iban_key
  #attr_encrypted :bic, key: Rails.application.secrets.member_bic_key

  belongs_to :member_entity, polymorphic: true

  def self.nested_params
    [ :id, :regional_organization_id, :mglnr, :title, :anrede, :vorname, :name, :strasse, :plz, :ort, :email, :eintritt, :austritt_zum, :za, :konto, :blz, :zahler, :telefon, :fax, :bic, :iban, :country_code, :dsgvo, :dsgvo_date ]
  end

  include CountryHelper

  validates_presence_of :eintritt,:mglnr
  validates :iban, :iban => true
  validates :bic, :bic => true
  validates :email, :email_format => true 
  validates :mglnr, :uniqueness => true

  belongs_to :regional_organization

  has_many :member_account_bookings

  def has_event?(event_type,event_id)
	  if event_type.kind_of?(Array) then
		  MemberEvent.where("member_id = :id and event_type in (:event_type) and event_id = :event_id",:event_id=>event_id,:event_type=>event_type,:id=>id).count > 0
	  else 
		  MemberEvent.where("member_id = :id and event_type = :event_type and event_id = :event_id",:event_id=>event_id,:event_type=>event_type,:id=>id).count > 0
	  end
  end

  def is_direct_debit?
	  za == 'L' and valid?
  end

  def fullname 
     result =''
     if ( title ) 
      result = result + title + ' '
     end
     if ( vorname ) 
      result = result + vorname + ' '
     end
     if (name) 
      result = result + name
     end
     return result
  end

  def letterCountry
	  if country_code == nil 
		  return ""
	  else
		  return country_code.upcase
	  end
  end

  def countryCode 
	  if country_code == nil 
		  return ""
	  else
		  return country_code
	  end
  end

  def iban_calc
    compute_iban(konto,blz)

  end

  def mref
    "BDZBEITRAG"+mglnr.to_s
  end

  def address
    fullname + ", " +strasse + ", "+plz+ " "+ort
  end


  def t_country(locale=country_code)
    translated_country(country_code,locale)
  end

  def address_block
	  fullname+"\n"+
	  strasse+"\n"+
	  plz+" "+ort
  end

  def has_email?
    not email.nil? and email.length > 3
  end

  def event_class
    MemberEvent
  end

  def to_customer
    dd = is_direct_debit? 
    c = CorikaInvoices::Customer.new
    c.customer_id = mglnr
    c.direct_debit = dd
    c.first_name = vorname
    c.last_name = name
    c.entity = self
    c.street = strasse
    c.zip = plz
    c.city = ort
    c.email = email
    c.country = country_code
    c.sig_date = sig_date 
    c.mandate_id =  mandate_id 
    c.account_owner = zahler
    if dd then
      c.iban = iban
      c.bic = bic
    end

    c
  end

  def mandate_id 
    "BDZBEITRAG"+mglnr.to_s
  end

  def sig_date
    Date.new(2014,1,1)
  end

  def get_unbalanced_bookings
      result = Array.new
      bookings = MemberAccountBooking.where("member_id = ?",id).order(:booking_date)
      sum =0 
      bookings.each do |booking|
        result << booking
        sum += booking.amount
        if (sum ==0 ) then
          result.clear
        end
      end
      return result
  end

  def last_invoice
    member_account_bookings.where("booking_type = 'B'").maximum(:booking_date)
  end

  def contact_info
    (telefon && telefon.length >0 ? "Tel: "+ telefon+", " :"" )+
	  (fax && fax.length >0 ? "Fax: "+ fax+", " :"" )+
	  (email ? email+", " : "") 
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

  def self.nomail(type=nil)
    Rails.logger.debug("type: #{type.name}")
    if not type.nil? then 
      where('email IS NULL or LENGTH(email) < 3 and member_entity_type=?', type.name) 
    else
      where('email IS NULL or LENGTH(email) < 3')
    end
  end
  
  def self.mail(type=nil)
    if not type.nil? then
      where('email IS NOT NULL and length(email) >3 and member_entity_type=?', type.name)
    else
      where('email IS NOT NULL and length(email) >3')
    end
  end

  def self.ids_with_non_zero_balance(type=nil,year=nil)

    if year.nil? then
      year = Time.now.year
    end
      
    accounts=nil

    if type.nil? then
      accounts = MemberAccountBooking.where("booking_year < ?", year).group(:member).sum(:amount)
    else 
      accounts = MemberAccountBooking.includes(:member).where("booking_year < ? AND members.member_entity_type = ? ", year,type).group(:member).sum(:amount)
    end

	  ids = Set.new

	  accounts.each do |account|
      if (account[1]<-0.1) then
        ids.add(account[0])
	    end
	  end
    
    return ids
  end

  def to_addressee
    addressee = Addressee.new
    addressee.email        = self.email
    addressee.street       = self.strasse
    addressee.zip          = self.plz
    addressee.city         = self.ort
    addressee.country_code = self.country_code
    addressee.id           = self.mglnr
    addressee.email        = self.email
    addressee.event_entity_id = self.id

    addressee
  end

  def last_payment
    booking = member_account_bookings.where("booking_type = ? or booking_type = ? ","A","L").order("booking_date desc").first

    if booking.nil? then 
      nil
    else
      booking.booking_date
    end
  end

  
  def create_invoice_delta_booking(year, amount, filename, booking_txt)
		booking = MemberAccountBooking.newInvoice(booking_txt,-1*amount,mglnr.to_s)
		booking.member_id = id
    booking.booking_year=year
    booking.filename = filename
		booking.save

    booking
  end
  
  def create_invoice_booking(year, invoice, filename, booking_txt)
		booking = MemberAccountBooking.newInvoice(booking_txt,-1*invoice.sum,mglnr.to_s)
		booking.member_id = id
    booking.booking_year=year
    booking.filename = filename
		booking.save

    booking
  end

  def create_credit_transfer(sepa_writer, year, booking_txt, amount) 
    if amount < 0 
      Rails.logger.warn("Credit transfer amount must not be negative!")
      return false
    end

    customer = member_entity.to_customer

		if (is_direct_debit?) then
			if sepa_writer.add_credit_transfer(customer,booking_txt,amount)
        booking = MemberAccountBooking.newCreditTransfer("Überweisung "+booking_txt,amount)
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

  def create_dd_booking(sepa_writer, invoice, year, delta_amount=nil)
    customer = member_entity.to_customer
    
    booking_txt = "Rechnung Nr. #{invoice.number} #{self.mglnr}"

    if not delta_amount.nil? then
      amount = delta_amount
      booking_txt+=" Nachzahlung"
    else
      amount = invoice.sum
    end

		if (is_direct_debit?) then
			sepa_writer.add_direct_debit(customer,amount,booking_txt,"RCUR")
			booking = MemberAccountBooking.newWithdrawal("Lastschrift "+booking_txt,amount)
			booking.member_id = id
      booking.booking_year = year
			booking.save

      booking
    end
  end

  def zero_member_fee_balance?
    booking_sum = MemberAccountBooking.where("member_id = ? and booking_type in ('B','A','L')",id).sum(:amount)

    return booking_sum >-0.1
  end
end
