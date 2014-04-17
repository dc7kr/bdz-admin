class FestivalApplication < ActiveRecord::Base

  include CountryHelper

  attr_accessible :conductor, :contact_person, :equipment, :country_code, :num_players, :orch_name, :orchestra, :special_cast, :group_type,:permission,:festival_concert_id, :visitor_type, :rehearsal_time, :payment_status, :tickets, :tickets_red, :bdz_tickets_red, :bdz_tickets, :amount
  has_many :festival_pieces
  has_many :festival_application_attachments

  accepts_nested_attributes_for :festival_pieces, :allow_destroy => :true


  belongs_to :contact_person
  belongs_to :orchestra
  belongs_to :festival_concert

  def t_country(locale="de")
    translated_country(country_code,locale) 
  end


  def invoice
    prices = BDZ_SETTINGS["festival_prices"]
    ts = Time.now.strftime "%Y%m%d"

    renr = ts+"-TLN#{id}"

    inv = Invoice.new(renr)

    inv.considerItem(tickets,prices["fest"],"Festivalticket")
    inv.considerItem(tickets_red,prices["fest_erm"],"Festivalticket ermaessigt")
    inv.considerItem(bdz_tickets,prices["fest_bdz"],"Festivalticket BDZ")
    inv.considerItem(bdz_tickets_red,prices["fest_bdz_erm"],"Festivalticket BDZ ermaessigt")
    inv.addItem(InvoiceItem.new(1, -1*amount, "erhaltene Anzahlung"))

    inv
  end
end
