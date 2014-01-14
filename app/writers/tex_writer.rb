class TexWriter 
	include ApplicationHelper
	include ActionView::Helpers::NumberHelper

  	@@workdir = BDZ_SETTINGS['invoice_workdir']

	def self.workdir
		@@workdir
	end


  def writeInvoice(invoice,contact) 
		File.open(TexWriter.workdir+"/variables.tex", 'w') do |f| 
			writeOurData(f,contact)
			writeCommon(f,invoice.member)
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
		file.write('\Artikel{'+String(count)+'}{'+label+'}{'+amount+"}\n")
	end


	def writePersonTariff(person) 
		File.open(TexWriter.workdir+"/posten.tex",'w') do |f|
			writeInvoiceItem(f,1,person.tariff.amount, 'Beitrag '+person.tariff.description)
		end
  end

	def writeReportSheetReminderData(member)
		File.open(TexWriter.workdir+"/variables.tex", 'w') {|f| 
			writeOurData(f,'gs')
			writeCommon(f,member)
			intwo= I18n.l(14.days.from_now.to_date , :format => :long)
			f.write('\newcommand{\inTwoWeeks}{'+intwo+"}\n")
		}
    end

	def writeReminderData(member)

		File.open(TexWriter.workdir+"/variables.tex", 'w') {|f| 
			writeOurData(f,'treasurer')
			writeCommon(f,member)
			intwo= I18n.l(14.days.from_now.to_date , :format => :long)
			f.write('\newcommand{\inTwoWeeks}{'+intwo+"}\n")
		}

		@bookings = MemberAccountBooking.where("member_id = ?",member.member_id).order(:booking_date)
		File.open(TexWriter.workdir+"/bookings.tex",'w') {|f|
			@last = nil		
			sum=0
			@bookings.each do |booking|
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
      writeCommon(f,member)
      if ( year ) then 
        f.write('\newcommand{\jahr}{'+String(year)+"}\n")
      end
    end
	end 

	def writeCommon(f,member)
		f.write('\newcommand{\mglnr}{'+member.mglnr.to_s+"}\n")
		if ( member.is_direct_debit? ) then
			f.write('\newcommand{\konto}{'+member.iban.to_s+"}\n")
			f.write('\newcommand{\blz}{'+member.bic.to_s+"}\n")
		else
			f.write('\newcommand{\konto}{0}'+"\n")
			f.write('\newcommand{\blz}{0}'+"\n")
		end
		if ( member.instance_of?(Orchestra)) 
			f.write('\newcommand{\firma}{'+breakName(member.orchName)+'}'+"\n")
		else
			f.write('\newcommand{\firma}{}'+"\n")
		end
		f.write('\newcommand{\name}{'+member.fullname+"}\n")
		f.write('\newcommand{\strasse}{'+member.strasse+"}\n")
		full_ort=""
		if ( member.plz ) then 
			full_ort += member.plz 
			full_ort += ' '
		end
		if ( member.ort ) then
			full_ort += member.ort
		end

		f.write('\newcommand{\ort}{'+full_ort+"}\n")

		lastname=""
		if (member.name) 
				if ( member.anrede == 'Herr' ) then
					f.write('\newcommand{\anredetxt}{r Herr '+member.name+"}\n")
				elsif ( member.anrede == 'Frau' ) then
					f.write('\newcommand{\anredetxt}{ Frau '+member.name+"}\n")
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
		f.write('\newcommand{\myFirma}{'+BDZ_SETTINGS['company']+"}\n")
		f.write('\newcommand{\myFirmaShort}{'+BDZ_SETTINGS['companyShort']+"}\n")
		f.write('\newcommand{\myKonto}{'+BDZ_SETTINGS['konto']+"}\n")
		f.write('\newcommand{\myBLZ}{'+BDZ_SETTINGS['blz']+"}\n")
		f.write('\newcommand{\myBank}{'+BDZ_SETTINGS['bank']+"}\n")
		f.write('\newcommand{\myIBAN}{'+BDZ_SETTINGS['iban']+"}\n")
		f.write('\newcommand{\myBIC}{'+BDZ_SETTINGS['bic']+"}\n")
		f.write('\newcommand{\myPhone}{'+BDZ_SETTINGS['contacts'][contact]['phone']+"}\n")
		f.write('\newcommand{\myFax}{'+BDZ_SETTINGS['contacts'][contact]['fax']+"}\n")
		f.write('\newcommand{\myMail}{'+BDZ_SETTINGS['contacts'][contact]['mail']+"}\n")
		f.write('\newcommand{\myName}{'+BDZ_SETTINGS['contacts'][contact]['name']+"}\n")
		f.write('\newcommand{\myDept}{'+BDZ_SETTINGS['contacts'][contact]['dept']+"}\n")
		f.write('\newcommand{\myStreet}{'+BDZ_SETTINGS['contacts'][contact]['street']+"}\n")
		f.write('\newcommand{\myPLZ}{'+BDZ_SETTINGS['contacts'][contact]['plz']+"}\n")
		f.write('\newcommand{\myOrt}{'+BDZ_SETTINGS['contacts'][contact]['ort']+"}\n")
		f.write('\newcommand{\myJob}{'+BDZ_SETTINGS['contacts'][contact]['job']+"}\n")
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
end
