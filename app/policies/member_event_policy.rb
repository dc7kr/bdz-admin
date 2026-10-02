class MemberEventPolicy < MemberDataPolicy
  allow :download?, to: :national
end
