require 'odf/spreadsheet'
require 'set'
require 'csv'


class OrchestrasController < AuthenticatedController
  # for table sort by column click
  helper_method :sort_column, :sort_direction

  include UploadHelper
  include ReportSheetUploadHelper
  include PDFHelper
  include MagazineReportHelper
  #
  #  JSON ONLY 
  #
  def addresses
    if (params[:nomail]) then
		@orchestras = Orchestra.includes(:member).nomail
	elsif (params[:mailonly]) then
		@orchestras = Orchestra.includes(:member).mail
    else
		@orchestras = Orchestra.includes(:member).all
	end
#where("members.email IS NULL or members.email=''")
	#respond_to do |format|
#		format.json { 
		render :json => @orchestras.to_json(:include => {:member=> {} })
#		}
#	end
  end

  def notyetemailed
		@event  = params[:event]
		@orchestras = Orchestra.mailForEvent(@event)
    	respond_to do |format|
	 		format.js
     		format.html
     		format.json { render :json => @orchestras.to_json(
			{ :member => {:include => :member }}
		)}
    end
  end

  # GET /orchestras
  # GET /orchestras.json
#sample  before_filter :authenticate_user!, :except => [:some_action_without_auth]
  def notinvoiced 
     @orchestras = Orchestra.includes([:member,:report_sheets]).joins("LEFT JOIN member_account_bookings mb ON orchestras.member_id=mb.member_id AND mb.booking_type='B' and YEAR(mb.booking_date) = YEAR(NOW())").where("mb.id IS NULL and report_sheets.year= YEAR(NOW())").search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)


    respond_to do |format|
	 format.js
     format.html
     format.json { render :json => @orchestras.to_json(
		{ :member => {:include => :member }}
	)}
    end
  end


  def magazine 
    @orchestras = Orchestra.with_zero_balance
	  @result = Array.new

	  @orchestras.each do |orchestra|
      last_report = orchestra.lastReportSheet
      if last_report.nil? then
        logger.warn("Last Report sheet is NIL: #{orchestra.mglnr} #{orchestra.orchName}")
      else 
		  if ( last_reportcalcZeitungen > 0) then

			  mag_count=nil
			  if ( orchestra.is_regular? or orchestra.is_lorch? ) then
				  mag_count = orchestra.currentMagazines
			  else
				  mag_count = BDZ_SETTINGS["tariff"]["koopZtgCount"].to_i
			  end
		  @csvrow = {:name=> orchestra.orchName,
			:mglnr=>orchestra.mglnr,
			:fullname=>orchestra.fullname,
			:name2=>'',
			:strasse=>orchestra.strasse ,
			:countryCode=>orchestra.countryCode,
			:plz=>orchestra.plz,
			:ort=>orchestra.ort,
			:land=>orchestra.letterCountry,
			:magazines=>mag_count }
      @result << @csvrow
		  end
	  end
  	filename = "magazine.orch." + Time.now.strftime("%m-%d-%Y") + ".ods"
  
    renderOrchestraMagazineListOds("/tmp/"+filename,@result)
  
    send_file("/tmp/"+filename, :filename => filename, :type => "application/octet-stream")

  	flash[:notice] = "Export complete!"
  end
  def nopayment
	@previousYear = (Time.now.year-1).to_s
	if (params[:lastyear] != nil ) then
		@lastyear= params[:lastyear]
		@accounts = MemberAccountBooking.where("booking_year < ?", @lastyear).sum(:amount,:group=>:member_id)
	else
		@accounts = MemberAccountBooking.sum(:amount,:group=>:member_id)
	end

	@ids = Set.new
	@accounts.each do |account|
      if account[1].round(2) <0 then
        @ids.add(account[0])
	  end
	end
	@orchestras = Orchestra.includes(:member).order("members.mglnr").find(:all, :conditions=> ["member_id in (?)",@ids])

    respond_to do |format|
     format.html 
     format.json { render :json => @orchestras }
		format.csv { render :csv => @orchestras, :style=>:minimal, :filename => "nopayment_"+Time.now.year.to_s } 
		format.ods {
			renderNoPayOds("/tmp/nopayment.ods",@accounts,@orchestras);
    		send_file("/tmp/nopayment.ods", :filename => "orch_nopay_"+Time.now.year.to_s+".ods", :type => "application/octet-stream")
		}
    end

  end

  def gema
    currentYear = String(Time.now.year)
    respond_to do |format|
      @orchestras = Orchestra.includes(:member,:report_sheets).where("report_sheets.year = ? and members.mglnr < 20000 and orchestras.orch_type <>'K'",currentYear).order("members.mglnr")
      format.csv { render :csv => @orchestras, :style=>:gema, :filename => "gema"+Time.now.year.to_s }
		format.json { render :json => @orchestras }
    end
  end

  def index
	if @namespace == "mgl" then
		Rails.logger.info("MEMBER NAMESPACE DETECTED");
		@orchestra = Orchestra.includes(:member).where("members.mglnr = ?",user.username)
		respond_to do |format|
			format.html {
				redirect_to @orchestra
			}
		end
		return
  	end

	@previousYear = (Time.now.year-1).to_s
    @orchestras = Orchestra.includes(:member).search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

    respond_to do |format|
      format.html {
			if  ( @orchestras.length == 1 ) then
				redirect_to @orchestras[0]
			end
		}
			# index.html.erb
      format.json { render :json => @orchestras }
	  format.js
    end
  end

  def noreport
	@orchestras = Orchestra.includes([:member]).joins('LEFT JOIN report_sheets ON report_sheets.orchestra_id = orchestras.member_id AND report_sheets.year='+String(Time.now.year)).page(params[:page]).per(10).where(['report_sheets.id IS NULL']).search(params[:search]).order(sort_column+ " "+ sort_direction)


	respond_to do |format|
		format.html 
		format.json {render :json => @orchestras }
	end
  end

  # GET /orchestras/1
  # GET /orchestras/1.json
  def show
    @orchestra = Orchestra.includes(:report_sheets).find(params[:id])
    @report_sheets = @orchestra.report_sheets 


    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @orchestra }
    end
  end

  # GET /orchestras/new
  # GET /orchestras/new.json
  def new
    @orchestra = Orchestra.new
    @orchestra.country_code = "de"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @orchestra }
    end
  end

  # GET /orchestras/1/edit
  def edit
    @orchestra = Orchestra.find(params[:id])
  end


  # POST /orchestras
  # POST /orchestras.json
  def create
    @orchestra = Orchestra.new(params[:orchestra])
    respond_to do |format|
      if @orchestra.save
        format.html { redirect_to @orchestra, :notice => t('orchestra.create_success') }
        format.json { render :json => @orchestra, :status => :created, :location => @orchestra }
      else
        format.html { render :action => "new" }
        format.json { render :json => @orchestra.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orchestras/1
  # PUT /orchestras/1.json
  def update
    @orchestra = Orchestra.find(params[:id])

    respond_to do |format|
      if @orchestra.update_attributes(params[:orchestra])
        format.html { redirect_to @orchestra, :notice => t('orchestra.update_success') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @orchestra.errors, :status => :unprocessable_entity }
      end
    end
  end

  def rsi_login
	@orchestra = Orchestra.find(params[:id])

  cur_year = Time.now.year
  last_year = cur_year -1 
	@rsi = ReportSheetInput.for_orchestra_and_year(@orchestra, cur_year)	

	
	if ( @rsi != nil ) then

		session[:report_sheet_input_id]=@rsi.id
		session[:report_sheet_input_token]=@rsi.token
		redirect_to polymorphic_url([:mgl, @rsi],:action=>:step1)
	end
  end

  def gen_rsi
    @orchestra = Orchestra.includes(:member).find(params[:id])

	  year = Time.now.year
    anrede = t('common.salutation_d.'+@orchestra.anrede)
	  Rails.logger.info(anrede)
	  dateprefix = Time.now.strftime '%Y%m%d%H%M%S_'
	  @rsi = ReportSheetInput.includes(:report_sheet).where('report_sheet_inputs.orchestra_id = :orchestra_id and report_sheets.year = :year',:orchestra_id=>@orchestra.id, :year=>year+1).first

	  if ( @rsi == nil ) then
		  @rsi = ReportSheetInput.new_for_orchestra(@orchestra,year)
	  end

	  @rsi.save

    url = "http://www.bdz-online.de/meldebogen/"

	  target = BDZ_SETTINGS['invoice_archive_dir']+"/"+year.to_s+"/"+dateprefix+"_"+@orchestra.mglnr.to_s+"_meldebogen_anschreiben.pdf"

	  gen_anschreiben(@orchestra,@rsi,url,target,year);
    send_file(target, :filename => target, :type => "application/octet-stream")
  end

  # DELETE /orchestras/1
  # DELETE /orchestras/1.json
  def destroy
    @orchestra = Orchestra.find(params[:id])
    @orchestra.destroy

    respond_to do |format|
      format.html { redirect_to orchestras_url }
      format.json { head :ok }
    end
  end

	
  private 
  def sort_column
    Member.column_names.include?(params[:sort]) ? "members."+params[:sort] :
    Orchestra.column_names.include?(params[:sort]) ? params[:sort] : "members.mglnr"
  end

  private
  def renderNoPayOds(filename,accounts,orchestras)
			ODF::Spreadsheet.file(filename) do
				table "Nopayment" do
	    			orchestras.each do |o|
						row {
							cell o.mglnr.to_s
							cell o.orchName
							cell o.email
							cell accounts[o.member_id].round(2),:type=>:float
						}
					end
      end
    end
  end
end
