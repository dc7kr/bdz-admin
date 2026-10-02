# headless policy for the download pages: authorize :download
class DownloadPolicy < MemberDataPolicy
  allow :combined_letters_pdf?, :combined_sepa_pdf?, :combined_invoice_pdf?, :combined_sepa?, to: :accounting
end
