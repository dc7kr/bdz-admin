require 'tex_writer'
require 'dtaus_writer'
require 'invoice_helper'
class Cron::InvoicesController < ApplicationController

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
	else 
		orchestraInvoices(year)
	end

	render :text => mode +" OK."
  end	

  def personMemberInvoices(year)
    @persons = PersonMember.includes([:tariff,:member]).limit(5)
	ctlfile = "dtaus.ctl"
	File.open(DtausWriter.workdir+"/"+ctlfile,"w") {|dtafile| 
	DtausWriter.writeDtausHeader(dtafile)

		@persons.each do |person|
			TexWriter.write(person,year)
			TexWriter.writePersonTariff(person)
			DtausWriter.writeDtausPersonEntry(dtafile,person,"BDZ-Beitrag "+String(year)+" "+String(person.mglnr))
			system("/srv/httpd/bdz-online.de/bdz-rechnung/rechnung.sh "+String(person.mglnr))
		end
	}

	DtausWriter.genDtaus(ctlfile)
  end

  def orchestraInvoices(year)
    @reportsheets = ReportSheet.includes([:orchestra]).where("year = ?",year)
	ctlfile = "dtaus.ctl"
	File.open(DtausWriter.workdir+"/"+ctlfile,"w") {|dtafile| 
	DtausWriter.writeDtausHeader(dtafile)
	@reportsheets.each do |sheet|
		@booking_txt = "BDZ-Beitrag "+String(year)
		TexWriter.write(sheet.orchestra,year)
		TexWriter.writeOrchestraTariff(sheet)
		DtausWriter.writeDtausOrchestraEntry(dtafile,sheet.orchestra,@booking_txt+" "+String(sheet.orchestra.mglnr),sheet.calcInvoice)
		system("/srv/httpd/bdz-online.de/bdz-rechnung/rechnung.sh "+String(sheet.orchestra.mglnr))
		@booking = MemberAccountBooking.newInvoice(@booking_txt,-1*sheet.calcInvoice)
		@booking.member_id = sheet.orchestra_id
		@booking.save

		if ( sheet.orchestra.za =='L') then
			@booking = MemberAccountBooking.newWithdrawal("Lastschrift "+@booking_txt,sheet.calcInvoice)
			@booking.member_id = sheet.orchestra_id
			@booking.save
		end
		#DtausWriter.writeOrchestraEntry(sheet.orchestra,sum)
	end
	
	}
  end
end
