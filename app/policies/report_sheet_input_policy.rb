class ReportSheetInputPolicy < MemberDataPolicy
  allow :metadata?, :lockdown?, to: :national

  # invoiced report sheet inputs must be kept
  def destroy?
    super && (record.is_a?(Class) || !record.locked?)
  end
end
