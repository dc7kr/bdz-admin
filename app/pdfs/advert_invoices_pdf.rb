require 'prawn'
class AdvertInvoicesPdf < CompanyPaperDocument
  def initialize(adverts, templateFile)
    super(templateFile)
    @adverts = adverts

    font 'Helvetica', size: 10
    advert_invoices
  end

  def advert_invoices
    @adverts.each do |a|
      print_address(a.advertiser)
      print_headline('Rechnung')
      print_date('Mainz', Time.now)
      print_item_table a
      start_new_page(template: @templateFile, template_page: 1) if a != @adverts.last
    end
  end

  def print_item_table(_advert)
    move_down 30
  end
end
