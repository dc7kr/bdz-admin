class FestivalApplication < ActiveRecord::Base

  include CountryHelper

  attr_accessible :conductor, :contact_person, :equipment, :country_code, :num_players, :orch_name, :orchestra, :special_cast, :group_type,:permission,:festival_concert_id, :visitor_type, :rehearsal_time, :stage_time, :payment_status, :tickets, :tickets_red, :bdz_tickets_red, :bdz_tickets, :amount, :soloist_tickets
  has_many :festival_pieces
  has_many :festival_application_attachments
  has_one :event_meal, :foreign_key => 'participant_id'

  accepts_nested_attributes_for :festival_pieces, :allow_destroy => :true


  belongs_to :contact_person
  belongs_to :orchestra
  belongs_to :festival_concert

  def t_country(locale="de")
    translated_country(country_code,locale) 
  end

  def self.search(search)
    if (search)
      where('orch_name like ? or id = ?',"%#{search}%",search);
    else
      scoped
    end
  end



  def to_customer
    cust = Customer.new(id, contact_person.fullname)
    cust.id = id
    cust.entity = self

    # currently no DD
    cust.mandate_id = nil
    cust.iban = nil
    cust.bic=nil
    cust.sig_date = nil

    cust.salutation = contact_person.salutation

    cust.company = orch_name
    cust.name = contact_person.fullname
    cust.street = contact_person.street
    cust.zip = contact_person.zip
    cust.city = contact_person.city
    cust.country = contact_person.country_code

    cust
  end

  def invoice
    prices = BDZ_SETTINGS["festival_prices"]
    ts = Time.now.strftime "%Y%m%d"

    renr = ts+"-TLN#{id}"
    if (contact_person.country_code == 'de' or country_code == 'at') then 
      locale = :de
    else 
      locale = :en
    end

    inv = Invoice.new(renr)
    inv.customer = to_customer
    inv.considerItem(tickets,prices["fest"],I18n.t("event_card.fest", :locale=>locale))
    inv.considerItem(tickets_red,prices["fest_erm"],I18n.t("event_card.fest_erm",:locale=>locale))
    inv.considerItem(bdz_tickets,prices["fest_bdz"],I18n.t("event_card.fest_bdz",:locale=>locale))
    inv.considerItem(bdz_tickets_red,prices["fest_bdz_erm"],I18n.t("event_card.fest_bdz_erm",:locale=>locale))
    inv.addItem(InvoiceItem.new(1, -1*amount, I18n.t("common.advance_payment",:locale=>locale)))

    inv
  end
end
