require 'prawn'
class MagazineSubscriberInvoicesPdf < CompanyPaperDocument 
  def initialize(subscribers,templateFile)
    super(templateFile)
    @subscribers= subscribers

    subscriber_invoices
  end

  def subscriber_invoices
    @subscribers.each do |s|
      print_address(s)
      print_headline("Rechnung")
      print_date("Mainz",Time.now)
      if ( s != @subscribers.last ) then
        start_new_page(:template => @templateFile, :template_page => 1)
      end
    end
  end
end
