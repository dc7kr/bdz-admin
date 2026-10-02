class ReportSheetPolicy < MemberDataPolicy

  def invoice_preview?
    permitted?(:national, :accounting)
  end

  def update_invoice?
    permitted?(:accounting)
  end

  def copy_from_last_year?
    permitted?(:national)
  end
end
