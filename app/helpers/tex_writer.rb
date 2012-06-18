
class TexWriter 
	include ApplicationHelper
	include ActionView::Helpers::NumberHelper

  	@@workdir = BDZ_SETTINGS['invoice_workdir']

	def self.workdir
		@@workdir
	end

	def writePersonTariff(person) 
		File.open(TexWriter.workdir+"/posten.tex",'w') {|f|
			writeTariffComponent(f,1,person.tariff.amount, 'Beitrag '+person.tariff.description)
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
		File.open(TexWriter.workdir+"/variables.tex", 'w') {|f| 
		writeOurData(f,'gs');
		writeCommon(f,member)
		if ( year ) then 
			f.write('\newcommand{\jahr}{'+String(year)+"}\n")
		end
		

	}
	end 

	def writeCommon(f,member)
		f.write('\newcommand{\mglnr}{'+String(member.mglnr)+"}\n")
		if ( member.za == 'L' ) then
			f.write('\newcommand{\konto}{'+String(member.konto)+"}\n")
			f.write('\newcommand{\blz}{'+member.blz+"}\n")
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
		f.write('\newcommand{\myPhone}{'+BDZ_SETTINGS[contact]['phone']+"}\n")
		f.write('\newcommand{\myFax}{'+BDZ_SETTINGS[contact]['fax']+"}\n")
		f.write('\newcommand{\myMail}{'+BDZ_SETTINGS[contact]['mail']+"}\n")
		f.write('\newcommand{\myName}{'+BDZ_SETTINGS[contact]['name']+"}\n")
		f.write('\newcommand{\myDept}{'+BDZ_SETTINGS[contact]['dept']+"}\n")
		f.write('\newcommand{\myStreet}{'+BDZ_SETTINGS[contact]['street']+"}\n")
		f.write('\newcommand{\myPLZ}{'+BDZ_SETTINGS[contact]['plz']+"}\n")
		f.write('\newcommand{\myOrt}{'+BDZ_SETTINGS[contact]['ort']+"}\n")
		f.write('\newcommand{\myJob}{'+BDZ_SETTINGS[contact]['job']+"}\n")

	end

	def writeOrchestraTariff(reportsheet)
		File.open(TexWriter.workdir+"/posten.tex",'w') {|f|
			if ( reportsheet.orchestra.orch_type == 'K' )
			then
				writeTariffComponent(f,1,Prices.lvOrchRate,'Beitrag kooperativ')
			elsif (reportsheet.orchestra.orch_type == 'L')
			then
				writeTariffComponent(f,1,Prices.lvOrchRate,'Landesorchesterbeitrag')
				count = reportsheet.calcGemaCount-reportsheet.azubi
				if ( count > 0 ) then
					writeTariffComponent(f,count,Prices.lvMember,'GEMA+Haftpflichtbeitrag je Mitglied')
				end
			else
				if ( reportsheet.isMinTariff? or reportsheet.isMaxTariff? ) then
					writeTariffComponent(f,reportsheet.children,0, 'Beitrag Kinder')
					writeTariffComponent(f,reportsheet.teens,0, 'Beitrag Jugendliche 15-18')
					writeTariffComponent(f,reportsheet.youth,0, 'Beitrag Erwachsene 19-27')
					writeTariffComponent(f,reportsheet.adult,0, 'Beitrag Erwachsene')
					writeTariffComponent(f,reportsheet.senior,0, 'Beitrag Erwachsene 55+')
				else
					writeTariffComponent(f,reportsheet.children,Prices.childrenRate, 'Beitrag Kinder')
					writeTariffComponent(f,reportsheet.teens,Prices.teensRate, 'Beitrag Jugendliche 15-18')
					writeTariffComponent(f,reportsheet.youth,Prices.youthRate, 'Beitrag Erwachsene 19-27')
					writeTariffComponent(f,reportsheet.adult,Prices.adultRate, 'Beitrag Erwachsene')
					writeTariffComponent(f,reportsheet.senior,Prices.seniorRate, 'Beitrag Erwachsene 55+')
				end
				if ( reportsheet.isMinTariff? ) then
					writeTariffComponent(f,1,Prices.minTariff,'Mindestbeitrag')
				elsif ( reportsheet.isMaxTariff? ) 
					writeTariffComponent(f,1,Prices.maxTariff,'H{"o}chstbeitrag')
				end

			end
			if ( reportsheet.uv ) then
				writeTariffComponent(f,reportsheet.calcUvCount,Prices.uvRate, 'Unfallversicherung')
			end
		}
	end

	def writeTariffComponent(file, count, tariff, label)	
		amount = '%.2f' % tariff;
		amount = amount.gsub('.',',')
		file.write('\Artikel{'+String(count)+'}{'+label+'}{'+amount+"}\n")
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
end
