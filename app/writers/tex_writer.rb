class TexWriter 
	include ApplicationHelper
	include ActionView::Helpers::NumberHelper

  	@@workdir = BDZ_SETTINGS['invoice_workdir']

	def self.workdir
		@@workdir
	end


  def writeInvoice(invoice,contact,year) 
		File.open(TexWriter.workdir+"/variables.tex", 'w') do |f| 
			writeOurData(f,contact)
			writeCommon(f,invoice.customer)
      f.write('\newcommand{\jahr}{'+year.to_s+"}\n")
			f.write('\newcommand{\renummer}{'+invoice.invoice_number+"}\n")
			f.write('\newcommand{\zweck}{'+invoice.invoice_number+"}\n")
		end
		File.open(TexWriter.workdir+"/posten.tex",'w') do |f|
      invoice.items.each do |i|
			  writeInvoiceItem(f,i.count,i.price,i.label)
        Rails.logger.debug("wrote tariff comp: #{i.count}x#{i.price}:#{i.label}")
      end
		end
  end

	def writeInvoiceItem(file, count, tariff, label)
		if (count.nil? or count == 0 )  then
      Rails.logger.info("omitting #{label} item as count was nil or 0")
			return
		end
		amount = '%.2f' % tariff;
		amount = amount.gsub('.',',')

    if tariff < 0 then
		  file.write('\Anzahlung{'+amount+"}\n")
    else
		  file.write('\Artikel{'+String(count)+'}{'+label+'}{'+amount+"}\n")
    end
	end


	def writePersonTariff(person) 
		File.open(TexWriter.workdir+"/posten.tex",'w') do |f|
			writeInvoiceItem(f,1,person.tariff.amount, 'Beitrag '+person.tariff.description)
		end
  end

	def writeReportSheetReminderData(customer)
		File.open(TexWriter.workdir+"/variables.tex", 'w') {|f| 
			writeOurData(f,'gs')
			writeCommon(f,customer)
			intwo= I18n.l(14.days.from_now.to_date , :format => :long)
			f.write('\newcommand{\inTwoWeeks}{'+intwo+"}\n")
		}
  end

	def writeReminderData(customer,bookings)

		File.open(TexWriter.workdir+"/variables.tex", 'w') {|f| 
			writeOurData(f,'treasurer')
			writeCommon(f,customer)
			intwo= I18n.l(14.days.from_now.to_date , :format => :long)
			f.write('\newcommand{\inTwoWeeks}{'+intwo+"}\n")
		}

		File.open(TexWriter.workdir+"/bookings.tex",'w') {|f|
			@last = nil		
			sum=0
			bookings.each do |booking|
				f.write(format_date(booking.booking_date)+ "&"+booking.booking_txt+" &  "+format_currency(booking.amount,'EUR')+"\\\\\n")
				if ( booking.amount != nil ) then
					sum=sum+booking.amount
				end
        	end
			f.write("\\hline\n")
			f.write('\textbf{Summe} & & \textbf{'+format_currency(sum,"EUR")+"}\\\\\n")
		}
  end

	def write(member,year) 
		File.open(TexWriter.workdir+"/variables.tex", 'w') do |f| 
      writeOurData(f,'gs');
      f.write('\newcommand{\jahr}{'+year.to_s+"}\n")
      writeCommon(f,member.to_customer)
    end
	end 

	def writeCommon(f,customer)
		f.write('\newcommand{\mglnr}{'+customer.customer_id.to_s+"}\n")
		if ( customer.is_direct_debit? ) then
			f.write('\newcommand{\directDebit}{1}'+"\n")
			f.write('\newcommand{\iban}{'+customer.iban.to_s+"}\n")
			f.write('\newcommand{\bic}{'+customer.bic.to_s+"}\n")

			f.write('\newcommand{\mandateRef}{'+customer.mandate_id.to_s+"}\n")
			f.write('\newcommand{\glaeubigerId}{'+BDZ_SETTINGS["creditor_id"]+"}\n")
		else
			f.write('\newcommand{\directDebit}{0}'+"\n")
		end
		if ( customer.company.nil?)
			f.write('\newcommand{\firma}{}'+"\n")
		else
			f.write('\newcommand{\firma}{'+breakName(tex_escape(customer.company))+'}'+"\n")
		end
		f.write('\newcommand{\name}{'+"#{customer.fullname}}\n")
		f.write('\newcommand{\strasse}{'+"#{customer.street}}\n")
		full_ort=""
		if ( customer.zip) then 
			full_ort += customer.zip
			full_ort += ' '
		end
		if ( customer.city ) then
			full_ort += customer.city
		end

		f.write('\newcommand{\ort}{'+"#{full_ort}}\n")

    country = ISO3166::Country[customer.country]
    country_en = nil
    if (customer.country == "DE") then
      country_en = ""
    else
      country_en = country.translations['en']
    end

    f.write('\newcommand{\country}{'+country_en+"}\n")

		lastname=""
		if (customer.name) 
				if ( customer.salutation == 'Herr' ) then
					f.write('\newcommand{\anredetxt}{r Herr '+customer.name+"}\n")
				elsif ( customer.salutation == 'Frau' ) then
					f.write('\newcommand{\anredetxt}{ Frau '+customer.name+"}\n")
				else
					f.write('\newcommand{\anredetxt}{ Damen und Herren}'+"\n")
				end
		else 
			f.write('\newcommand{\anredetxt}{ Damen und Herren,}'+"\n")
		end
		#f.write('\newcommand{\myStrasse}{}'+"\n")
		f.write('\newcommand{\redatum}{'+I18n.l(Time.now.to_date , :format => :long)+"}\n")
	end

	def writeOurData(f,contact) 
    our_contact = BDZ_SETTINGS['contacts'][contact]

		f.write('\newcommand{\myFirma}{'+BDZ_SETTINGS['company']+"}\n")
		f.write('\newcommand{\myFirmaShort}{'+BDZ_SETTINGS['companyShort']+"}\n")
		f.write('\newcommand{\myKonto}{'+BDZ_SETTINGS['konto']+"}\n")
		f.write('\newcommand{\myBLZ}{'+BDZ_SETTINGS['blz']+"}\n")
    if ( our_contact['iban'].nil? ) then
		  f.write('\newcommand{\myBank}{'+BDZ_SETTINGS['bank']+"}\n")
		  f.write('\newcommand{\myIBAN}{'+BDZ_SETTINGS['iban']+"}\n")
		  f.write('\newcommand{\myBIC}{'+BDZ_SETTINGS['bic']+"}\n")
    else
		  f.write('\newcommand{\myIBAN}{'+our_contact['iban']+"}\n")
		  f.write('\newcommand{\myBIC}{'+our_contact['bic']+"}\n")
		  f.write('\newcommand{\myBank}{'+our_contact['bank']+"}\n")
    end

		f.write('\newcommand{\myPhone}{'+our_contact['phone']+"}\n")
		f.write('\newcommand{\myFax}{'+our_contact['fax']+"}\n")
		f.write('\newcommand{\myMail}{'+our_contact['mail']+"}\n")
		f.write('\newcommand{\myName}{'+our_contact['name']+"}\n")
		f.write('\newcommand{\myDept}{'+our_contact['dept']+"}\n")
		f.write('\newcommand{\myStreet}{'+our_contact['street']+"}\n")
		f.write('\newcommand{\myPLZ}{'+our_contact['plz']+"}\n")
		f.write('\newcommand{\myOrt}{'+our_contact['ort']+"}\n")
		f.write('\newcommand{\myJob}{'+our_contact['job']+"}\n")
	end


	def breakName(name)
		# if name contains ; use that...
		name.gsub(";","\\\\ ")
	end
	def format_date(date)
		return I18n.l(date.to_date , :format => :long)
	end

	def format_currency(val,currency)
		return number_to_currency(val,:locale => :de)
	end

  def moveGeneratedFiles(datePrefix)
	  workDir = BDZ_SETTINGS['invoice_workdir']
	  archiveDir= BDZ_SETTINGS['invoice_archive_dir']
	  tgtDir= archiveDir +"/"+String(Time.now.year)

	  shortprefix = Time.now.strftime("%Y%m%d-")

	  if ( ! Dir.exists? tgtDir) then
    	FileUtils.mkdir tgtDir
	  end

	  Dir.chdir(workDir)
	  Dir.entries(workDir).each { |file|
		  if file.start_with? datePrefix or file.start_with? shortprefix then
			  FileUtils.mv file, tgtDir+"/"
		  end
	  }
  end


  def gen_pdf(invoice_type, datePrefix, customer_id)
    out_file = "#{datePrefix}-#{customer_id}-#{invoice_type}.pdf"
		system("/opt/bdz-rechnung/bin/rechnung.sh #{invoice_type} #{datePrefix} #{customer_id}")

    out_file
  end

  def tex_escape(text)
    text.gsub(/\"([a-zA-z0-9]+)\"/, '\glqq \1\grqq ')
  end
end
