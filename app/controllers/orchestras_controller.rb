require 'odf/spreadsheet'
require 'set'
require 'csv'


class OrchestrasController < AuthenticatedController
  # for table sort by column click
  helper_method :sort_column, :sort_direction

  authority_actions :lorch=> 'read'



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
    year = params[:year]

    if year.nil? then
     year = Time.now.year
    end

    @orchestras = Orchestra.notinvoiced(year).search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

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
        logger.warn("Last Report sheet is NIL: #{orchestra.member.mglnr} #{orchestra.orchName}")
      elsif ( last_report.calcZeitungen > 0) then
			  mag_count=nil
			  if ( orchestra.is_regular? or orchestra.is_lorch? ) then
				  mag_count = orchestra.currentMagazines
			  else
				  mag_count = BDZ_SETTINGS["tariff"]["koopZtgCount"].to_i
			  end
		  @csvrow = {:name=> orchestra.orchName,
			:mglnr=>orchestra.member.mglnr,
			:fullname=>orchestra.fullname,
			:name2=>'',
			:strasse=>orchestra.member.strasse ,
			:countryCode=>orchestra.member.countryCode,
			:plz=>orchestra.member.plz,
			:ort=>orchestra.member.ort,
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
    data = MemberAccountBooking.unbalanced_before(params[:before])

    @accounts = data[:accounts]
    @ids = data[:ids]

    @members = Member.includes(:member_entity).where("member_entity_type='Orchestra' and id in (?)",@ids.to_a).order(:mglnr)

    respond_to do |format|
     format.html 
     format.json { render :json => @members}
		format.csv { render :csv => @members, :style=>:minimal, :filename => "nopayment_"+Time.now.year.to_s } 
		format.ods {
			renderNoPayOds("/tmp/nopayment.ods",@accounts,@members);
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

  def lorch
    @orchestras = @orchestras.includes(:member).where("orch_type='L'").order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

  #authorize_action_for @orchestras
  

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

  def index

    @orchestras = @orchestras.includes(:member).search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

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
	@orchestras = Orchestra.includes([:member]).joins('LEFT JOIN report_sheets ON report_sheets.orchestra_id = orchestras.id AND report_sheets.year='+String(Time.now.year)).page(params[:page]).per(10).where(['report_sheets.id IS NULL']).search(params[:search]).order(sort_column+ " "+ sort_direction)


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
    @orchestra.build_member
    @orchestra.member.country_code = ISO3166::Country['DE'].alpha2
    @orchestra.member.eintritt = Time.now

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @orchestra }
    end
  end

  # GET /orchestras/1/edit
  def edit
    @orchestra = Orchestra.find(params[:id])
    authorize_action_for @orchestra
  end


  # POST /orchestras
  # POST /orchestras.json
  def create
    @orchestra = Orchestra.new(orchestra_params)
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
      if @orchestra.update_attributes!(orchestra_params)
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

    url = "http://www.bdz-online.de/meldebogen/"

	  target = BDZ_SETTINGS['invoice_archive_dir']+"/"+year.to_s+"/"+dateprefix+@orchestra.mglnr.to_s+"_meldebogen_anschreiben.pdf"

	  gen_anschreiben(@orchestra,@rsi);
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

  def pro_musica
    @age = 90
    Logger.debug("AGE: #{@age}")
    year = Time.now.year - @age
    @orchestras = Orchestra.includes(:member).where("YEAR(gruendung) <= ? and gruendung != '0000-00-00' and gruendung IS NOT NULL ",year).order("members.mglnr")
  end

  private
  def renderNoPayOds(filename,accounts,members)
			ODF::Spreadsheet.file(filename) do
				table "Nopayment" do
	    			members.each do |m|
						row {
							cell m.mglnr.to_s
							cell m.member_entity.orchName
							cell m.email
							cell accounts[m.id].round(2),:type=>:float
						}
					end
      end
    end
  end
  def orchestra_params
    params.require(:orchestra).permit( :orchName, :url, :gruendung, :orch_type, :bemerkung, :zweitanschrift, :name2, :kuendigungErfasst ,member_attributes: Member.nested_params) 
  end
end
