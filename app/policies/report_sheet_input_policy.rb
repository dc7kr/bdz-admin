class ReportSheetInputPolicy < MemberDataPolicy

  def metadata?
    national_permission?
  end
end
