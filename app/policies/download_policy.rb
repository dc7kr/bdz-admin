class DownloadPolicy < MemberDataPolicy

  def index?
    permitted?(:national)
  end

  def combined_letters_pdf?
    permitted?(:accounting)
  end
  
  def combined_sepa_pdf?
    permitted?(:accounting)
  end
  
  
  def combined_invoice_pdf?
    permitted?(:accounting)
  end
  
  def combined_sepa?
    permitted?(:accounting)
  end
end
