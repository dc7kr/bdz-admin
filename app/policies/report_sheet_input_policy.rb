class ReportSheetInputPolicy < MemberDataPolicy
  allow :metadata?, :lockdown?, :generate?, to: :national

  # invoiced report sheet inputs must be kept
  def destroy?
    super && (record.is_a?(Class) || !record.locked?)
  end
end
