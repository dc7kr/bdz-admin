class Report::RegionalOrganizationPolicy < MemberDataPolicy

  def members?
    national_permission? 
  end

  def orchestras?
    national_permission? 
  end
  
  def person_members?
    national_permission? 
  end


end
