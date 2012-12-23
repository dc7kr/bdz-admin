require 'prawn' 

module PDFHelper

	def merge_pdfs(dir,to_merge,out_file)
		Dir.chdir(dir)
		cmd = "/usr/bin/pdftk "+to_merge.join(" ")+" output "+out_file
		system(cmd)
	end

	def gen_anschreiben(orchestra,rsi)
		year = rsi.report_sheet.year
    	url = BDZ_SETTINGS['meldebogen_url']
		dateprefix = Time.now.strftime '%Y%m%d%H%M%S_'
		target = BDZ_SETTINGS['invoice_archive_dir']+"/"+year.to_s+"/"+dateprefix+"_"+orchestra.mglnr.to_s+"_meldebogen_anschreiben.pdf"
		template_file = BDZ_SETTINGS['invoice_archive_dir']+"/"+year.to_s+"/meldebogen_anschreiben.template.pdf"
		year = rsi.report_sheet.year
		anrede = t('common.salutation_d.'+orchestra.anrede)
  
      Prawn::Document.generate(target, :template => template_file) do
        bounding_box([35,400],:width=>500,:height => 50) do
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
          if ( orchestra.country_id != 81) then
			text orchestra.country.name
		  end
        end

		from = BDZ_SETTINGS['contacts']['gs']
		l_date = I18n.l Time.now.to_date, :format=>:long
		bounding_box([393,540],:width=>200,:height=>50) do
			text from['ort']+", "+l_date
		end
      end
	  # return filename
	  target
    end
end
