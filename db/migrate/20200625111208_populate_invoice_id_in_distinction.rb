class PopulateInvoiceIdInDistinction < ActiveRecord::Migration[4.2]
  def self.up

    Distinction.all.each do |d|

      d_date= d.dist_date.strftime("%Y%m%d")

      p d_date

      if d.orchestra.nil?
        next
      end

     inv_nr = "E-"+d_date+"-"+d.orchestra.member.mglnr.to_s

     re = Regexp.new inv_nr
     mongo_inv = CorikaInvoices::Invoice.where(number: re).first

     if not mongo_inv.nil?
      d.invoice_id=mongo_inv.id
      d.save
     end
    end
  end
end
