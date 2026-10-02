class Report::RegionalOrganizationPolicy < MemberDataPolicy
  allow :members?, :orchestras?, :person_members?, to: :national
end
