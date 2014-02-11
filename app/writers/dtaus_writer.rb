require 'zip/zip'

class DtausWriter  < DirectDebitWriter 

  def initialize(datePrefix=nil)
    super(datePrefix)
  end

	def ctlFile
		DtausWriter.workdir+@datePrefix+"dta.ctl"
	end

	def self.workdir
		BDZ_SETTINGS['invoice_workdir']+"/"
	end

	def writeDtausPersonEntry(member,zweck)
		if (member.konto > 0) then
			amount = "%.2f" % member.tariff.amount
			writeDtausEntry(member.fullname,String(member.konto),member.blz,amount,zweck)	
		end
	end

    def writeDtausEntry(name,konto,blz,amount,zweck,withdraw=true)
			@file.write( "{\n")
			if (withdraw) then
				@file.write( "Transaktion Einzug\n")
			else
				@file.write( "Transaktion Gutschrift\n")
			end
			@file.write( "Name "+name+"\n")
			@file.write( "Konto "+konto+"\n")
			@file.write( "BLZ "+blz+"\n")
			@file.write( "Betrag "+amount+"\n")
			@file.write( "Zweck "+zweck+"\n")
			@file.write( "}\n")
	end
	def writeLvEntry(regorg,txt,sum)
		if (regorg != nil and regorg.konto > 0) then
			amount = "%.2f" % sum
			writeDtausEntry("BDZ "+String(regorg.name),String(regorg.konto),String(regorg.blz),amount,txt,false)
		end
	end

	def writeDtausOrchestraEntry(member,zweck,sum)
		if (member.konto > 0) then
			amount = "%.2f" % sum
			writeDtausEntry(String(member.cleanOrchName),String(member.konto),member.blz,amount,zweck)
		end
	end

	def writeDtausHeader(withdraw=true)
		datum = I18n.l(Time.now, :format => :short)
		@file.write("BEGIN {\n")
		if (withdraw) then
			@file.write("Art LK\n")
		else
			@file.write("Art GK\n")
		end
		@file.write("Name "+BDZ_SETTINGS['company']+"\n")
		@file.write("Konto "+BDZ_SETTINGS['konto']+"\n")
		@file.write("BLZ "+BDZ_SETTINGS['blz']+"\n")
		@file.write("Datum "+datum+"\n")
		@file.write("}\n")
	end

  private
	def genDtaus()
		workdir = BDZ_SETTINGS['invoice_workdir']+"/"
		dtaFName = workdir+@datePrefix+"dtaus0.txt"
		bglFName = workdir+@datePrefix+"dta_zettel.txt"
		sumFName = workdir+@datePrefix+"dta_summen.txt"

		system("/usr/bin/dtaus -d "+dtaFName+" -c "+ctlFile+" -b "+bglFName+" -o "+sumFName+" -dtaus")

		zipfileName = workdir+@datePrefix+"dtaus.zip"
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
		return DtausWriter.workdir+@datePrefix+"_dtaus.zip"
	end

  def moveGeneratedFiles()
	  workDir = BDZ_SETTINGS['invoice_workdir']
	  archiveDir= BDZ_SETTINGS['invoice_archive_dir']
	  tgtDir= archiveDir +"/"+String(Time.now.year)

	  if ( ! Dir.exists? tgtDir) then
      	FileUtils.mkdir tgtDir
	  end

	  Dir.chdir(workDir)
	  Dir.entries(workDir).each { |file|
		  if file.start_with? @datePrefix then
			  FileUtils.mv file, tgtDir+"/"
		  end
	  }
  end

  def generateFile
    genDtaus
    moveGeneratedFiles
  end
end
