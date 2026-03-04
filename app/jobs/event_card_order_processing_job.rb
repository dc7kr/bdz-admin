class EventCardOrderProcessingJob < BaseInvoicesJob
  include BulkMailHelper
  include Rails.application.routes.url_helpers

  def perform(checkout_reference)

    event_card = EventCard.find_by(checkout_reference: checkout_reference)
    invoice = event_card.to_invoice

    if event_card.payment_method == "credit_card"
      checkout = CorikaSumup::Checkout.find_by(checkout_reference: checkout_reference)

      if checkout.nil?
        Rails.logger.error("Could not find checkout for reference #{checkout_reference}")
        return
      end

      if checkout.status == "PAID"
        invoice.paid=true
        invoice.transaction_code = checkout.transaction_code
        invoice.save
      else
        # wait for PAID status
        EventCardOrderProcessingJob.wait(30.second).perform_later(checkout_reference)
      end
    end

    # generate invoice PDF
    invoice_obj = event_card.to_invoice
    pdf_file = invoice_obj.gen_pdf

    # send invoice pdf to customer
    EventCardOrderConfirm.notification(checkout_reference).deliver()

    if invoice_obj.payment_method == "direct_debit"
      EventCardOrderConfirm.treasurer(checkout_reference).deliver()
    end
  end
end

