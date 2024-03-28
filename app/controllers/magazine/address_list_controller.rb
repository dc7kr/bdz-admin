class Magazine::AddressListController < AuthenticatedNonResourceController
  
  # render_magazine_address_list
  include MagazineReportHelper

  def index
  	authorize! :index, Orchestra
    de_result = Array.new
    ext_result = Array.new

    person_members = PersonMember.with_zero_balance

    person_members.each do |person_member|
      csvrow = person_member.magazine_address_list_row
      _add_csv_row(csvrow, de_result, ext_result)
    end

    orchestras = Orchestra.with_zero_balance

    orchestras.each do |orchestra|
      csvrow = orchestra.magazine_address_list_row
      _add_csv_row(csvrow, de_result, ext_result) or Rails.logger.warn("Magazine count is zero: "+orchestra.member.mglnr.to_s)
    end

    RegionalOrganization.all.each do |lv|
      csvrow = lv.magazine_address_list_row
      _add_csv_row(csvrow, de_result, ext_result) or Rails.logger.error("LV CSV row was null: #{lv.name}")
    end
    
    magazine_samplings = MagazineSampling.active
    
    magazine_samplings.each do |ms|
      csvrow = ms.magazine_address_list_row
      _add_csv_row(csvrow, de_result, ext_result) or Rails.logger.error("Sampling CSV row was null: #{ms.name}")
    end
    
    magazine_advertisers = Advertiser.active
    
    magazine_advertisers.each do |ma|
      csvrow = ma.magazine_address_list_row
      _add_csv_row(csvrow, de_result, ext_result) or Rails.logger.error("Sampling CSV row was null: #{ma.name}")
    end


    filename = Time.now.strftime("%Y%m%d%H%M%S") + "_auftakt_adressen.ods"
    render_magazine_address_list("/tmp/"+filename,de_result,ext_result)
  
    send_file("/tmp/"+filename, :filename => filename, :type => "application/octet-stream")

    flash[:notice] = "Export complete!"
  end

  private
  def _add_csv_row(csvrow,de_result,ext_result)
      if not csvrow.nil? then
        if csvrow[:countryCode] == "DE"
          de_result << csvrow
        else
          ext_result << csvrow
        end
        return true
      else
        return false
      end
  end


end
