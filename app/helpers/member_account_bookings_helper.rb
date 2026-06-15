module MemberAccountBookingsHelper
  include DownloadsHelper
  def booking_type_options
    MemberAccountBooking.booking_types.map do |type|
      [ t("member_account_bookings.booking_types.#{type}"), type ]
    end
  end

  def entity_check
    member = member_account_booking.member
    if not member.nil?
      is_orchestra = member.member_entity.is_a?(Orchestra)
      is_pm= member.member_entity.is_a?(PersonMember)
      is_lv=member.member_entity.is_a?(RegionalOrganization)
    else
      is_orchestra=false
      is_pm=false
      is_lv=false
    end
  end

  def booking_dl_link(member_account_booking)

    member = member_account_booking.member
    is_orchestra=false
    is_pm=false
    is_lv=false

    if not member.nil?
      is_orchestra = member.member_entity.is_a?(Orchestra)
      is_pm= member.member_entity.is_a?(PersonMember)
      is_lv=member.member_entity.is_a?(RegionalOrganization)
    end

    path = nil

    if member_account_booking.invoice_id.present?
      invoice = CorikaInvoices::Invoice.find(member_account_booking.invoice_id)
      if member_account_booking.booking_type == "L"
        path = invoice_sepa_download_path(invoice)
      else
        path = invoice_pdf_download_path(invoice)
      end
    else
      return unless member_account_booking.filename.present?
      if is_orchestra
        path = download_orchestra_member_account_booking_path(member_account_booking.member,member_account_booking)
      elsif is_pm
        path = download_person_member_member_account_booking_path(member_account_booking.member,member_account_booking)
      end
    end

    if member_account_booking.booking_type == "L"
      link_to "SEPA", path, class: "btn btn-sm btn-primary", data: { turbo: false } 
    else
      link_to path, class: "btn btn-sm btn-primary", data: { turbo: false } do
        concat(my_fa_icon("download"))
      end
    end
  end
end
