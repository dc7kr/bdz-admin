class MemberEventPolicy < MemberDataPolicy

  def download?
    national_permission?
  end
end
