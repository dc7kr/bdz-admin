inv_to_id = Hash.new

CorikaInvoices::Invoice.all.each do |iv|
   inv_to_id[iv.pdf_filename] = iv.id unless iv.pdf_filename.nil?  
end

MemberAccountBooking.all.each do |mb|
   if mb.invoice_id.nil?
     id = inv_to_id[mb.filename]
     if id.present?
       mb.invoice_id = id
       mb.save
     end
   end
end



 orchestras.each do |o|
   mb = o.member.member_account_bookings.find_by(booking_year: 2026, booking_type: 'B')
   if mb.invoice_id.present?
     invoice = CorikaInvoices::Invoice.find(mb.invoice_id)
     if invoice.net_sum != invoice.total
       p "Needs update: #{o.member.mglnr}"
     else
       p "Invoice ok"
     end
   else
     p "Invoice ID missing: #{o.member.mglnr}, #{mb.id}"
     if mb.filename.present?
       p mb.filename
       seq = mb.filename.gsub(/^.*_(\d+)-.*$/,'\1').to_i
       inv = CorikaInvoices::Invoice.find_by(seq_nr: seq)
       if inv.present?
         if not inv.pdf_filename.present?
           inv.pdf_filename = mb.filename
           inv.save
         end
         mb.invoice_id = inv.id
         mb.save
       else
         p "Invoice not found at all!"
       end
     end
   end
 end
