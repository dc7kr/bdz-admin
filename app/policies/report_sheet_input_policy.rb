class ReportSheetInputPolicy < MemberDataPolicy

  def metadata?
    permitted?(:national)
  end
end
