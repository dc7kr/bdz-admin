require 'prawn' 
require 'pdf/toolkit'

module PDFHelper

	def gen_anschreiben(orchestra,rsi)
		year = rsi.report_sheet.year
    url = BDZ_SETTINGS['meldebogen_url']

    mglnr = orchestra.member.mglnr
    anrede = orchestra.member.anrede

    member = orchestra.member

		dateprefix = Time.now.strftime '%Y%m%d%H%M%S'

    filename = dateprefix+"_"+mglnr.to_s+"_meldebogen_anschreiben.pdf"

    tmpfile = Tempfile.new('mb_anschr')

    file = MailingFile.new("meldebogen_anschreiben.pdf", filename, Time.now.strftime("%Y"))

		template_file = BDZ_SETTINGS['template_dir']+"/meldebogen_anschreiben."+year.to_s+".template.pdf"

		if ( anrede != nil and anrede.length > 0 ) then
			anrede = t('common.salutation_d.'+anrede)
		else
			anrede =""
		end

  
    Prawn::Document.generate(tmpfile.path,:page_size=>"A4") do
      bounding_box([21,340],:width=>500,:height => 50) do
        font "Times-Roman"
        font_size 11
        text "Bitte melden Sie sich dazu unter #{url} mit Ihrer Mitgliedsnummer #{mglnr} und dem Passwort #{rsi.token} an.", :align => :left
      end
 
      bounding_box([40,650],:width=>250,:height=>100) do
        text orchestra.orchName
        text anrede+" "+member.vorname+" "+member.name
        text member.strasse
        text " "
        text "#{member.plz} #{member.ort}"
        if ( member.country_code != 'DE' ) then
          text member.t_country
        end
      end

		  from = BDZ_SETTINGS['contacts']['gs']
		  l_date = I18n.l Time.now.to_date, :format=>:long
		  bounding_box([370,510],:width=>200,:height=>50) do
			  text from['ort']+", "+l_date
		  end
      
      if (orchestra.is_direct_debit?) then 
        bounding_box([21,310],:width=>500,:height=>50) do
          text I18n.t('report_sheet_input.dd_to_sepa_valid', iban:member.iban, bic:member.bic, mref:member.mref)
        end

      end
    end

    tmpfile2 = Tempfile.new('mb_stamped').path

    PDF::Toolkit.pdftk(tmpfile.path, "background", template_file, "output", tmpfile2)
    PDF::Toolkit.pdftk("A="+tmpfile2, "B="+template_file, "cat", "A1", "B2-2", "output", file.full_path)

	  # return filename
    return file
 end
end
