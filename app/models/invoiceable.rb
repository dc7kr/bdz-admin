class Invoiceable < ApplicationRecord
  self.abstract_class = true

  def invoice
    if has_invoice?
      CorikaInvoices::Invoice.find(invoice_id)
    else
      nil
    end
  end

  def has_invoice?
    invoice_id.present?
  end

  def storno_invoice
    if not storno_invoice_id.present?
      return nil
    end

    i = CorikaInvoices::Invoice.find(storno_invoice_id)

    i
  end
end
