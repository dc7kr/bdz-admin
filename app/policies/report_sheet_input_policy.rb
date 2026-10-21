class ReportSheetInputPolicy < MemberDataPolicy
  allow :metadata?, :lockdown?, to: :national

  # invoiced report sheet inputs must be kept
  def destroy?
    super && !record.locked?
  end
end
