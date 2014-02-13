require 'tex_writer'
require 'sepa_writer'
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
    OrchestraInvoicesWorker.perform_async(year,@current_user.id)  

    respond_to do |format|
        format.html { redirect_to home_cron_path, :notice => t('cron.invoice_orchestras_success') }
    end
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

    @direct_debits = Array.new

	  @tw = TexWriter.new

    dtaFile = nil

    datePrefix = Time.now.strftime '%Y%m%d%H%M%S'
    @sw = SEPAWriter.new(datePrefix)

	  @person_members.each do |person|
      next if ( person.tariff.amount == 0 )

		  @cur_year = Time.now.year
		  @booking_txt = 'Beitrag '+person.tariff.description+' '+String(@cur_year)
		  @booking =  MemberAccountBooking.newInvoice(@booking_txt,-1*person.tariff.amount,String(person.mglnr))
		  @booking.member_id = person.id
      @booking.save

      @tw.write(person,year)
		  @tw.writePersonTariff(person)
		  system("/opt/bdz-rechnung/bin/rechnung.sh "+String(person.mglnr))
			
		  if (person.is_direct_debit?) then
        remittance_txt = "BDZ-Beitrag "+year.to_s+" "+person.mglnr.to_s
        @sw.addBooking(person, person.tariff.amount, remittance_txt)

			  @booking = MemberAccountBooking.newWithdrawal("Lastschrift "+@booking_txt,person.tariff.amount)
			  @booking.member_id = person.id
			  @booking.save
		  end
    end

	  @invoice_type = "rechnung-em"
    system("/opt/bdz-rechnung/bin/merge_pdfs.sh rechnung "+@invoice_type)

    @ddFile = @sw.generateFile
    @date_prefix=@sw.datePrefix

	  @tw.moveGeneratedFiles(@date_prefix)
    send_mail(@ddFile, @invoice_type)
  end

  def testGen(datepref)
	  @dw = DtausWriter.new
	  @dw.overrideDate(datepref)
    @dw.genDtaus()
	  @tw.moveGeneratedFiles(@sw.datePrefix)
  end
end
