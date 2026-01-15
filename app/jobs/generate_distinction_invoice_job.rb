class GenerateDistinctionInvoiceJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false



  def perform(distinction_id, user_id)
    distinction = Distinction.find(distinction_id)
    user = User.find(user_id)
    orchestra = distinction.orchestra

    datePrefix = Time.zone.now.strftime "%Y%m%d%H%M%S"

    CorikaInvoices::SepaWriter.new(datePrefix, INVOICE_CONFIG)

    invoice = distinction.gen_invoice
    invoice.save

    pdf = invoice.gen_pdf
    sepa = invoice.gen_sepa_file

    booking_txt = "Ehrungsrechung #{invoice.number}"
    booking = MemberAccountBooking.new_distinction_invoice(booking_txt, -1 * invoice.sum, invoice.customer.customer_id, pdf)
    booking.member_id = orchestra.member.id
    booking.invoice_id = invoice.id.to_s
    booking.save

    if invoice.customer.direct_debit?
      @wdbooking = MemberAccountBooking.new_dd("Lastschrift #{booking_txt}", invoice.sum, sepa.orig_filename)
      @wdbooking.member_id = orchestra.member.id
      @wdbooking.invoice_id = invoice.id
      @wdbooking.save
    end

    distinction.member_account_booking = booking
    distinction.invoice_id = invoice.id.to_s
    distinction.save

    send_mail(user, invoice, sepa)

  end

  def send_mail(triggered_by, invoice, sepa)
    invoice.pdf_filename

    base_url = cron_downloads_url

    "#{base_url}?year=#{invoice.invoice_date.year}&filename=#{sepa.orig_filename}" unless sepa.nil?

    AdminNotifier.new_distinction_notification(triggered_by, invoice, sepa).deliver
  end


end

