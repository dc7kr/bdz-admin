class ReportSheetPolicy < MemberDataPolicy
  allow :invoice_preview?, to: %i[national accounting]
  allow :update_invoice?, to: :accounting
  allow :copy_from_last_year?, to: :national
end
