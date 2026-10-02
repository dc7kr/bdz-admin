class Report::RegionalOrganizationPolicy < MemberDataPolicy

  def members?
    permitted?(:national) 
  end

  def orchestras?
    permitted?(:national) 
  end
  
  def person_members?
    permitted?(:national) 
  end


end
