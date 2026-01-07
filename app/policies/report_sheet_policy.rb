class ReportSheetPolicy < MemberDataPolicy

  def invoice_preview?
    national_permission? or accounting_permission?
  end

end
