class DownloadPolicy < MemberDataPolicy

  def index?
    national_permission?
  end

  def combined_letters_pdf?
    user.has_role? :accounting or user.has_role? :admin
  end
  
  def combined_sepa_pdf?
    user.has_role? :accounting or user.has_role? :admin
  end
  
  
  def combined_invoice_pdf?
    user.has_role? :accounting or user.has_role? :admin
  end
  
  def combined_sepa?
    user.has_role? :accounting or user.has_role? :admin
  end
end
