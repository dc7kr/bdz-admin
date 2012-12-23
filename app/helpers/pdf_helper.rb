require 'prawn' 

module PDFHelper
	def gen_anschreiben(orchestra,rsi)
		year = rsi.report_sheet.year
    	url = BDZ_SETTINGS['meldebogen_url']
		dateprefix = Time.now.strftime '%Y%m%d%H%M%S_'
		target = BDZ_SETTINGS['invoice_archive_dir']+"/"+year.to_s+"/"+dateprefix+"_"+orchestra.mglnr.to_s+"_meldebogen_anschreiben.pdf"
		template_file = BDZ_SETTINGS['invoice_archive_dir']+"/"+year.to_s+"/meldebogen_anschreiben.template.pdf"
		year = rsi.report_sheet.year
		anrede = t('common.salutation_d.'+orchestra.anrede)
  
      Prawn::Document.generate(target, :template => template_file) do
        bounding_box([20,370],:width=>500,:height => 50) do
          font "Times-Roman"
          font_size 11
          text "Bitte melden Sie sich dazu unter #{url} mit Ihrer Mitgliedsnummer #{orchestra.mglnr} und dem Passwort #{rsi.token} an.", :align => :left
        end
  
        bounding_box([30,620],:width=>250,:height=>100) do
          text orchestra.orchName
          text anrede+" "+orchestra.vorname+" "+orchestra.name
          text orchestra.strasse
          text " "
          text "#{orchestra.plz} #{orchestra.ort}"
          if ( orchestra.country_id != 81) then
			text orchestra.country.name
		  end
        end
      end
	  # return filename
	  target
    end
end
