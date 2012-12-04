require 'tex_writer'
require 'dtaus_writer'
require 'invoice_helper'
require 'fileutils.rb'

class Cron::InvoicesController < AuthenticatedNonResourceController
  #load_and_authorize_resource

 def gen_all
  	authorize! :member, :edit
	if (params[:year]) then
		year = params[:year].to_i
	else
		year = Time.now.year
	end
	orchestraInvoices(year)
	personMemberInvoices(year)
	render :text => "Generation OK."
 end

 def ping
  	authorize! :member, :edit
	render :text => "Pong"
 end
 def gen_orchestras
  	authorize! :member, :edit
	if (params[:year]) then
		year = params[:year].to_i
	else
		year = Time.now.year
	end
	orchestraInvoices(year)
	render :text => "Generation OK."
  end

  def gen_persons
  	authorize! :member, :edit
	if (params[:year]) then
		year = params[:year].to_i
	else
		year = Time.now.year
	end

	personMemberInvoices(year)
	render :text => "Generation OK."
  end

  def test_gen
  	authorize! :member, :edit
	testGen(params[:date])
	render :text => "Generation OK."
  end

  # manual query respecting already invoiced:
  # SELECT m.id, m.strasse, mb.id from person_members m LEFT JOIN member_account_bookings mb ON m.member_id=mb.member_id AND mb.booking_type='B' WHERE mb.id is not null and year(mb.booking_date)=year(now())

  # query for already existing bookings
  # SELECT m.id, m.strasse, mb.id FROM person_members m LEFT JOIN member_account_bookings mb ON m.member_id = mb.member_id AND mb.booking_type = 'B' WHERE mb.id IS NOT NULL AND year( mb.booking_date ) = year( now( ) )
  def personMemberInvoices(year)

    @person_members = PersonMember.includes([:tariff,:member]).joins("LEFT JOIN member_account_bookings mb ON person_members.member_id=mb.member_id AND mb.booking_type='B' and YEAR(mb.booking_date) = YEAR(NOW())").where("mb.id IS NULL").order("members.mglnr")
	
	@tw = TexWriter.new
	@dw = DtausWriter.new
	File.open(@dw.ctlFile,"w") {|dtafile| 
		@dw.outfile(dtafile)
		@dw.writeDtausHeader(true)

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

	@invoice_type = "rechnung-em"
	system("/opt/bdz-rechnung/bin/merge_pdfs.sh "+@invoice_type)
	@dw.genDtaus()
	@tw.moveGeneratedFiles(@dw.datePrefix)
    send_mail(@dw.datePrefix, @invoice_type)
  end


  def orchestraInvoice(orch,year,tw,dw)
		@booking_txt = "BDZ-Beitrag "+String(year)
		tw.write(orch,year)
		@currentSheet = orch.currentReportSheet
		tw.writeOrchestraTariff(@currentSheet)
		system("/opt/bdz-rechnung/bin/rechnung.sh "+String(orch.mglnr))
		@booking = MemberAccountBooking.newInvoice(@booking_txt,-1*@currentSheet.calcInvoice,String(orch.mglnr))
		@booking.member_id = orch.id
		@booking.save

		if ( orch.za =='L' and dw != nil ) then
			dw.writeDtausOrchestraEntry(orch,@booking_txt+" "+String(orch.mglnr),@currentSheet.calcInvoice)
			@booking = MemberAccountBooking.newWithdrawal("Lastschrift "+@booking_txt,@currentSheet.calcInvoice)
			@booking.member_id = orch.id
			@booking.save
		end
  end

  def orchestraInvoices(year)
	@tw = TexWriter.new
	@dw = DtausWriter.new

	@orchestras = Orchestra.includes([:report_sheets,:member]).joins("LEFT JOIN member_account_bookings mb ON orchestras.member_id=mb.member_id AND mb.booking_type='B' and YEAR(mb.booking_date) = YEAR(NOW())").where("mb.id IS NULL and report_sheets.year= ?",year).order("members.mglnr")

#    @reportsheets = ReportSheet.includes([:orchestra]).joins(:member,"LEFT JOIN member_account_bookings mb ON orchestras.member_id=mb.member_id AND mb.booking_type='B' and YEAR(mb.booking_date) = YEAR(NOW())").where("mb.id IS NULL and report_sheets.year= ?",year).order("members.mglnr")


	File.open(@dw.ctlFile,"w") {|dtafile| 
		@dw.outfile(dtafile)
		@dw.writeDtausHeader(true)
		@orchestras.each do |orch|
        	orchestraInvoice(orch,year,@tw,@dw)
		end
	}

	@invoice_type = "rechnung"
	system("/opt/bdz-rechnung/bin/merge_pdfs.sh "+@invoice_type)
	@dw.genDtaus()
	@tw.moveGeneratedFiles(@dw.datePrefix)
    send_mail(@dw.datePrefix, @invoice_type)
  end

  def testGen(datepref)
	@dw = DtausWriter.new
	@dw.overrideDate(datepref)
    @dw.genDtaus()
	@tw.moveGeneratedFiles(@dw.datePrefix)
  end

  def send_mail(dtausPrefix,invoice_type)

	year = Time.now.strftime('%Y')
	pdf_prefix= Time.now.strftime '%Y%m%d'

	@users = User.where("role like ? or role like ?", "%accounting%", "%admin%")
    base_url = cron_downloads_url
	invoices_url = base_url+"?year="+year+"&filename="+pdf_prefix+"-"+invoice_type+"_merge.pdf"
	dtaus_url = base_url+"?year="+year+"&filename="+dtausPrefix+"dtaus.zip"

	@users.each do |user| 
		InvoiceNotifier.newinvoices_notification(user, invoices_url, dtaus_url,@current_user).deliver
   		puts 'sent to %s' % current_user.email
	end
  end

end
