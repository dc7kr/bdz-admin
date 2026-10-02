class MemberEventPolicy < MemberDataPolicy

  def download?
    permitted?(:national)
  end
end
