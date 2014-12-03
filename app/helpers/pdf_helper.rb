require 'prawn' 

module PDFHelper

	def gen_anschreiben(orchestra,rsi)
		year = rsi.report_sheet.year
    url = BDZ_SETTINGS['meldebogen_url']
		dateprefix = Time.now.strftime '%Y%m%d%H%M%S'

    filename = dateprefix+"_"+orchestra.mglnr.to_s+"_meldebogen_anschreiben.pdf"
    file = MailingFile.new("meldebogen_anschreiben.pdf", filename, Time.now.strftime("%Y"))

		template_file = BDZ_SETTINGS['template_dir']+"/meldebogen_anschreiben."+year.to_s+".template.pdf"

		if ( orchestra.anrede != nil and orchestra.anrede.length > 0 ) then
			anrede = t('common.salutation_d.'+orchestra.anrede)
		else
			anrede =""
		end
  
    Prawn::Document.generate(file.full_path, :template => template_file) do
      bounding_box([21,360],:width=>500,:height => 50) do
        font "Times-Roman"
        font_size 11
        text "Bitte melden Sie sich dazu unter #{url} mit Ihrer Mitgliedsnummer #{orchestra.mglnr} und dem Passwort #{rsi.token} an.", :align => :left
      end
 
      bounding_box([40,650],:width=>250,:height=>100) do
        text orchestra.orchName
        text anrede+" "+orchestra.vorname+" "+orchestra.name
        text orchestra.strasse
        text " "
        text "#{orchestra.plz} #{orchestra.ort}"
        if ( orchestra.country_code != 'de' ) then
          text orchestra.t_country
        end
      end

		  from = BDZ_SETTINGS['contacts']['gs']
		  l_date = I18n.l Time.now.to_date, :format=>:long
		  bounding_box([388,510],:width=>200,:height=>50) do
			  text from['ort']+", "+l_date
		  end
      
      if (orchestra.is_direct_debit?) then 
        bounding_box([21,330],:width=>500,:height=>50) do
          text I18n.t('report_sheet_input.dd_to_sepa_valid', iban:orchestra.iban, bic:orchestra.bic, mref:orchestra.mref)
        end

      end
    end

	  # return filename
    return file
 end
end
