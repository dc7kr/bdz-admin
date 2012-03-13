class DtausWriter 
  @@workdir = "/srv/httpd/bdz-online.de/tmp"

	def self.workdir
		@@workdir
	end

	def self.writeDtausPersonEntry(f,member,zweck)

		if (member.konto > 0) then
			amount = "%.2f" % member.tariff.amount
			f.write( "{\n")
			f.write( "Transaktion Einzug\n")
			f.write( "Name "+member.vorname+" "+member.nachname+"\n")
			f.write( "Konto "+String(member.konto)+"\n")
			f.write( "BLZ "+member.blz+"\n")
			f.write( "Betrag "+amount+"\n")
			f.write( "Zweck "+zweck+"\n")
			f.write( "}\n")
		end
	end

	def self.writeDtausOrchestraEntry(f,member,zweck,sum)

		if (member.konto > 0) then
			amount = "%.2f" % sum
			f.write( "{\n")
			f.write( "Transaktion Einzug\n")
			f.write( "Name "+String(member.cleanOrchName)+"\n")
			f.write( "Konto "+String(member.konto)+"\n")
			f.write( "BLZ "+member.blz+"\n")
			f.write( "Betrag "+amount+"\n")
			f.write( "Zweck "+zweck+"\n")
			f.write( "}\n")
		end
	end
	def self.writeDtausHeader(f)
		datum = I18n.l(Time.now, :format => :short)
		f.write("BEGIN {\n")
		f.write("Art LK\n")
		f.write("Name "+BDZ_SETTINGS['company']+"\n")
		f.write("Konto "+BDZ_SETTINGS['konto']+"\n")
		f.write("BLZ "+BDZ_SETTINGS['blz']+"\n")
		f.write("Datum "+datum+"\n")
		f.write("}\n")
	end

	def self.genDtaus(ctlfile)
		system("dtaus -d "+workdir+"/dtaus0.txt -c "+workdir+"/"+ctlfile+" -begleit "+workdir+"/dtaus0.doc -o "+workdir+"/dtaus.kontroll.txt -dtaus")
	end

end
