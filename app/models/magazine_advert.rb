class MagazineAdvert < ApplicationRecord

  belongs_to :advertiser
  belongs_to :magazine_issue

  def gen_invoice
    invoice = CorikaInvoices::Invoice.new
    invoice_date = Time.now
    invoice.number = invoice_number
    invoice.invoice_type="werberechnung"

    invoice.customer = advertiser.to_customer

    invoice.addItem(1,get_advert_price, "Werbebuchung Ausgabe #{magazine_issue.full_number} #{advert_type}")

    invoice
  end

  def get_advert_price
    BDZ_SETTINGS["advert_prices"][advert_type].to_f
  end

  def invoice_number
    "ADV#{magazine_issue.year}#{magazine_issue.number}#{advertiser.customer_number}"
  end
end
