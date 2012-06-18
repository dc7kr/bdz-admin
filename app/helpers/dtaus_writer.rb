require 'zip/zip'

class DtausWriter 


	def outfile(pFile)
		@file = pFile
	end

	def initialize
		@dateprefix=Time.now.strftime '%Y%m%d%H%M%S_'
	end

	def overrideDate(pref)
		@dateprefix=pref+"_"
	end

	def datePrefix
		@dateprefix
	end

	def ctlFile
		DtausWriter.workdir+@dateprefix+"dta.ctl"
	end

	def self.workdir
		BDZ_SETTINGS['invoice_workdir']+"/"
	end

	def writeDtausPersonEntry(member,zweck)

		if (member.konto > 0) then
			amount = "%.2f" % member.tariff.amount
			@file.write( "{\n")
			@file.write( "Transaktion Einzug\n")
			@file.write( "Name "+member.fullname+"\n")
			@file.write( "Konto "+String(member.konto)+"\n")
			@file.write( "BLZ "+member.blz+"\n")
			@file.write( "Betrag "+amount+"\n")
			@file.write( "Zweck "+zweck+"\n")
			@file.write( "}\n")
		end
	end

	def writeDtausOrchestraEntry(member,zweck,sum)

		if (member.konto > 0) then
			amount = "%.2f" % sum
			@file.write( "{\n")
			@file.write( "Transaktion Einzug\n")
			@file.write( "Name "+String(member.cleanOrchName)+"\n")
			@file.write( "Konto "+String(member.konto)+"\n")
			@file.write( "BLZ "+member.blz+"\n")
			@file.write( "Betrag "+amount+"\n")
			@file.write( "Zweck "+zweck+"\n")
			@file.write( "}\n")
		end
	end
	def writeDtausHeader()
		datum = I18n.l(Time.now, :format => :short)
		@file.write("BEGIN {\n")
		@file.write("Art LK\n")
		@file.write("Name "+BDZ_SETTINGS['company']+"\n")
		@file.write("Konto "+BDZ_SETTINGS['konto']+"\n")
		@file.write("BLZ "+BDZ_SETTINGS['blz']+"\n")
		@file.write("Datum "+datum+"\n")
		@file.write("}\n")
	end

	def genDtaus()
		workdir = BDZ_SETTINGS['invoice_workdir']+"/"
		dtaFName = workdir+@dateprefix+"dtaus0.txt"
		bglFName = workdir+@dateprefix+"dta_zettel.txt"
		sumFName = workdir+@dateprefix+"dta_summen.txt"

		system("/usr/bin/dtaus -d "+dtaFName+" -c "+ctlFile+" -b "+bglFName+" -o "+sumFName+" -dtaus")

		zipfileName = workdir+@dateprefix+"dtaus.zip"
		Zip::ZipOutputStream.open(zipfileName) do |zos|
  		  [dtaFName, ctlFile, bglFName, sumFName].each do |fileName|
			cleanFile = fileName.gsub(workdir,"")
			if cleanFile.start_with? "/" then
				cleanFile = cleanFile.gsub("#^/+#","")
			end
    		zos.put_next_entry(cleanFile)
   			zos.print IO.read(fileName)
  		  end
		end
		return DtausWriter.workdir+@dateprefix+"_dtaus.zip"
	end
end
