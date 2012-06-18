require 'tex_writer'
require 'dtaus_writer'
require 'invoice_helper'
require 'fileutils.rb'

class Cron::InvoicesController < ApplicationController
  load_and_authorize_resource

 def index

	mode =""
	year=0
	if (params[:year]) then
		year = params[:year].to_i
	else
		year = Time.now.year
	end
	if ( params[:mode] ) then
		mode = params[:mode]
	else 
		mode ="em"
	end
	if ( mode == 'em' ) then
		personMemberInvoices(year)
	elsif ( mode == 'gendta') then
		testGen(params[:date])
	else 
		orchestraInvoices(year)
	end

	render :text => mode +" OK."
  end	

  # manual query respecting already invoiced:
  # SELECT m.id, m.strasse, mb.id from person_members m LEFT JOIN member_acct_booking mb ON m.member_id=mb.member_id AND mb.booking_type='B' WHERE mb.id is not null and year(mb.booking_date)=year(now())

  # query for already existing bookings
  # SELECT m.id, m.strasse, mb.id FROM person_members m LEFT JOIN member_acct_booking mb ON m.member_id = mb.member_id AND mb.booking_type = 'B' WHERE mb.id IS NOT NULL AND year( mb.booking_date ) = year( now( ) )
  def personMemberInvoices(year)

    @person_members = PersonMember.includes([:tariff,:member]).joins("LEFT JOIN member_acct_booking mb ON person_members.member_id=mb.member_id AND mb.booking_type='B' and YEAR(mb.booking_date) = YEAR(NOW())").where("mb.id IS NULL").order("members.mglnr")
	
	ctlfile = "dtaus.ctl"
	@tw = TexWriter.new
	@dw = DtausWriter.new
	File.open(@dw.ctlFile,"w") {|dtafile| 
		@dw.outfile(dtafile)
		@dw.writeDtausHeader()

		@person_members.each do |person|
			@tw.write(person,year)
			@tw.writePersonTariff(person)
			@cur_year = Time.now.year
			@booking_txt = 'Beitrag '+person.tariff.description+' '+String(@cur_year)
			@booking =  MemberAccountBooking.newInvoice(@booking_txt,-1*person.tariff.amount,String(person.mglnr))
			@booking.member_id = person.id
        	@booking.save


			system("/opt/bdz-rechnung/bin/rechnung.sh "+String(person.mglnr))
			
			if (person.za =='L') then
				@dw.writeDtausPersonEntry(person,"BDZ-Beitrag "+String(year)+" "+String(person.mglnr))
				@booking = MemberAccountBooking.newWithdrawal("Lastschrift "+@booking_txt,person.tariff.amount)
				@booking.member_id = person.id
				@booking.save
			end
		end
	}

	system("/opt/bdz-rechnung/bin/merge_pdfs.sh rechnung")
	@dw.genDtaus()
	moveGeneratedFiles(@dw.datePrefix)
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

  def orchestraInvoices(year)
	@tw = TexWriter.new

	@orchestras = Orchestra.includes([:report_sheets,:member]).joins("LEFT JOIN member_acct_booking mb ON orchestras.member_id=mb.member_id AND mb.booking_type='B' and YEAR(mb.booking_date) = YEAR(NOW())").where("mb.id IS NULL and report_sheets.year= ?",year).order("members.mglnr")

#    @reportsheets = ReportSheet.includes([:orchestra]).joins(:member,"LEFT JOIN member_acct_booking mb ON orchestras.member_id=mb.member_id AND mb.booking_type='B' and YEAR(mb.booking_date) = YEAR(NOW())").where("mb.id IS NULL and report_sheets.year= ?",year).order("members.mglnr")

	@dw = DtausWriter.new

	File.open(@dw.ctlFile,"w") {|dtafile| 
		@dw.outfile(dtafile)
		@dw.writeDtausHeader()
	@orchestras.each do |orch|
		@booking_txt = "BDZ-Beitrag "+String(year)
		@tw.write(orch,year)
		@currentSheet = orch.currentReportSheet
		@tw.writeOrchestraTariff(@currentSheet)
		system("/opt/bdz-rechnung/bin/rechnung.sh "+String(orch.mglnr))
		@booking = MemberAccountBooking.newInvoice(@booking_txt,-1*@currentSheet.calcInvoice,String(orch.mglnr))
		@booking.member_id = orch.id
		@booking.save

		if ( orch.za =='L') then
			@dw.writeDtausOrchestraEntry(orch,@booking_txt+" "+String(orch.mglnr),@currentSheet.calcInvoice)
			@booking = MemberAccountBooking.newWithdrawal("Lastschrift "+@booking_txt,@currentSheet.calcInvoice)
			@booking.member_id = orch.id
			@booking.save
		end
		#DtausWriter.writeOrchestraEntry(@currentSheet.orchestra,sum)
	end
	
	}
	system("/opt/bdz-rechnung/bin/merge_pdfs.sh rechnung")
	@dw.genDtaus()
	moveGeneratedFiles(@dw.datePrefix)
    send_mail(@dw.datePrefix)
  end

  def testGen(datepref)
	@dw = DtausWriter.new
	@dw.overrideDate(datepref)
    @dw.genDtaus()
	moveGeneratedFiles(@dw.datePrefix)
  end

  def send_mail(dtausPrefix)

	year = Time.now.strftime('%Y')
	pdf_prefix= Time.now.strftime '%Y%m%d'

	@users = User.where("role like ?", "%admin%")
    base_url = cron_downloads_url
	invoices_url = base_url+"?year="+year+"&filename="+pdf_prefix+"-rechnung_merge.pdf"
	dtaus_url = base_url+"?year="+year+"&filename="+dtausPrefix+"dtaus.zip"

	@users.each do |user| 
		InvoiceNotifier.newinvoices_notification(user, invoices_url, dtaus_url).deliver
   		puts 'sent to %s' % current_user.email
	end
  end

end
