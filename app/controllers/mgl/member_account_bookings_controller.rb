module Mgl
  # read only
  class MemberAccountBookingsController < BaseController
    def index
      bookings = policy_scope(MemberAccountBooking)
      @bookings = bookings.order(booking_date: :desc).page(params[:page]).per(30)
      # unfiltered total of every booking type, matching the list shown
      @balance = bookings.sum(:amount)
    end

    def show
      set_booking
    end

    def download
      set_booking
      path, filename = booking_file

      if path.present? && File.file?(path)
        send_file(path, filename: filename, type: "application/octet-stream")
      else
        Rails.logger.warn("Booking #{@booking.id}: file not found #{path}")
        redirect_to mgl_member_account_bookings_path, flash: { error: t("mgl.member_account_bookings.file_missing") }
      end
    end

    private

    def set_booking
      @booking = policy_scope(MemberAccountBooking).find(params[:id])
      authorize @booking
    end

    def booking_file
      if @booking.invoice_id.present?
        invoice = CorikaInvoices::Invoice.find_by(id: @booking.invoice_id)
        return [ nil, nil ] if invoice.nil? || invoice.pdf_filename.blank?

        [ invoice.get_invoice_file.full_path, invoice.pdf_filename ]
      else
        filename = File.basename(@booking.filename.to_s)
        [ File.join(INVOICE_CONFIG.archive_dir, @booking.booking_year.to_s, filename), filename ]
      end
    end
  end
end
