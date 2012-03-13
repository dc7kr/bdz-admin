class TexWriter 
  @@workdir = BDZ_SETTINGS['invoice_workdir']

	def self.workdir
		@@workdir
	end

	def self.writePersonTariff(person) 
		File.open(TexWriter.workdir+"/posten.tex",'w') {|f|
			writeTariffComponent(f,1,person.tariff.amount,'Beitrag'+person.tariff.description)
		}
	end

	def self.write(member,year) 
		File.open(TexWriter.workdir+"/variables.tex", 'w') {|f| 
		writeOurData(f);

		f.write('\newcommand{\jahr}{'+String(year)+"}\n")
		f.write('\newcommand{\mglnr}{'+String(member.mglnr)+"}\n")
		f.write('\newcommand{\konto}{'+String(member.konto)+"}\n")
		f.write('\newcommand{\blz}{'+member.blz+"}\n")
		if ( member.instance_of?(Orchestra)) 
			f.write('\newcommand{\firma}{'+member.orchName+'}'+"\n")
		else
			f.write('\newcommand{\firma}{}'+"\n")
		end
		f.write('\newcommand{\name}{'+member.vorname+' '+member.nachname+"}\n")
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

		if ( member.anrede == 'Herr' ) then
			f.write('\newcommand{\anredetxt}{r Herr '+member.nachname+"}\n")
		else
			f.write('\newcommand{\anredetxt}{ Frau '+member.nachname+"}\n")
		end
		#f.write('\newcommand{\myStrasse}{}'+"\n")
		
		f.write('\newcommand{\redatum}{'+I18n.l(Time.now , :format => :long)+"}\n")
	}
	end 

	def self.writeOurData(f) 
		f.write('\newcommand{\myName}{'+BDZ_SETTINGS['name']+"}\n")
		f.write('\newcommand{\myFirma}{'+BDZ_SETTINGS['company']+"}\n")
		f.write('\newcommand{\myFirmaShort}{'+BDZ_SETTINGS['companyShort']+"}\n")
		f.write('\newcommand{\myDept}{'+BDZ_SETTINGS['dept']+"}\n")
		f.write('\newcommand{\myStreet}{'+BDZ_SETTINGS['street']+"}\n")
		f.write('\newcommand{\myPLZ}{'+BDZ_SETTINGS['plz']+"}\n")
		f.write('\newcommand{\myOrt}{'+BDZ_SETTINGS['ort']+"}\n")
		f.write('\newcommand{\myKonto}{'+BDZ_SETTINGS['konto']+"}\n")
		f.write('\newcommand{\myBLZ}{'+BDZ_SETTINGS['blz']+"}\n")
		f.write('\newcommand{\myBank}{'+BDZ_SETTINGS['bank']+"}\n")
		f.write('\newcommand{\myIBAN}{'+BDZ_SETTINGS['iban']+"}\n")
		f.write('\newcommand{\myBIC}{'+BDZ_SETTINGS['bic']+"}\n")
		f.write('\newcommand{\myPhone}{'+BDZ_SETTINGS['phone']+"}\n")
		f.write('\newcommand{\myFax}{'+BDZ_SETTINGS['fax']+"}\n")
		f.write('\newcommand{\myMail}{'+BDZ_SETTINGS['mail']+"}\n")
	end

	def self.writeOrchestraTariff(reportsheet)
		File.open(TexWriter.workdir+"/posten.tex",'w') {|f|
			if ( reportsheet.orchestra.orch_type == 'K' )
			then
				writeTariffComponent(f,1,Prices.lvOrchRate,'Beitrag kooperativ')
			elsif (reportsheet.orchestra.orch_type == 'L')
			then
				writeTariffComponent(f,1,Prices.lvOrchRate,'Landesorchesterbeitrag')
				count = reportsheet.teens+reportsheet.youth+reportsheet.adult-reportsheet.azubi
				if ( count > 0 ) then
					writeTariffComponent(f,count,Prices.lvMember,'Haftpflichtbeitrag je Mitglied')
				end
			else 
				writeTariffComponent(f,reportsheet.children,Prices.childrenRate, 'Beitrag Kinder')
				writeTariffComponent(f,reportsheet.teens,Prices.teensRate, 'Beitrag Jugendliche 15-18')
				writeTariffComponent(f,reportsheet.youth,Prices.youthRate, 'Beitrag Erwachsene 19-27')
				writeTariffComponent(f,reportsheet.adult,Prices.adultRate, 'Beitrag Erwachsene')
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

	def self.writeTariffComponent(file, count, tariff, label)	
		amount = '%.2f' % tariff;
		amount = amount.gsub('.',',')
		file.write('\Artikel{'+String(count)+'}{'+label+'}{'+amount+"}\n")
	end
end
