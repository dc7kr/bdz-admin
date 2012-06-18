require 'set'
require 'csv'
class OrchestrasController < AuthenticatedController
  # for table sort by column click
  helper_method :sort_column, :sort_direction

  # GET /orchestras
  # GET /orchestras.json
#sample  before_filter :authenticate_user!, :except => [:some_action_without_auth]
  def notinvoiced 
     @orchestras = Orchestras.includes([:orchestra,:members]).joins("LEFT JOIN member_acct_booking mb ON orchestras.member_id=mb.member_id AND mb.booking_type='B' and YEAR(mb.booking_date) = YEAR(NOW())").where("mb.id IS NULL and report_sheets.year= YEAR(NOW())").search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)


    respond_to do |format|
	 format.js
     format.html
     format.json { render :json => @orchestras}
    end

	 
  end

  def magazine 

	@accounts = MemberAccountBooking.where("booking_year < year(now())").sum(:amount,:group=>:member_id)

	@ids = Set.new
	@accounts.each do |account|
      if (account[1]<0) then
        @ids.add(account[0])
	  end
	end
	
	@orchestras = Orchestra.includes([:member]).where("NOT (member_id  in (?) )",@ids)

	@result = Array.new
	@orchestras.each do |orchestra|
		if ( 'L' != orchestra.orch_type && ! @ids.include?(orchestra.id) && orchestra.lastReportSheet.calcZeitungen > 0) then
		  @csvrow = {:name=> orchestra.orchName,
			:mglnr=>orchestra.mglnr,
			:fullname=>orchestra.fullname,
			:name2=>'',
			:strasse=>orchestra.strasse ,
			:countryCode=>orchestra.countryCode,
			:plz=>orchestra.plz,
			:ort=>orchestra.ort,
			:land=>orchestra.letterCountry,
			:magazines=>orchestra.currentMagazines

		  }
		  @result << @csvrow
		end
	end
  	@outfile = "concertino.orchester." + Time.now.strftime("%m-%d-%Y") + ".csv"
  
  csv_data = CSV.generate do |csv|
    csv << [
    "Lfd Nr",
    "Mglnr",
    "Orchester",
    "Orchester2",
    "Name",
    "Strasse",
	"Laendercode",
    "PLZ",
    "Ort",
    "Land",
    "Zeitungen"
    ]
	@nr=1
    @result.sort_by { |item| item[:magazines]}.each do |data|
		csv << [
			@nr,
            data[:mglnr],
            data[:name],
            data[:name2],
            data[:fullname],
            data[:strasse],
			data[:countryCode],
            data[:plz],
            data[:ort],
            data[:land],
            data[:magazines]
		]
		@nr=@nr+1
    end
	end
  	send_data csv_data,
    	:type => 'text/csv; charset=iso-8859-1; header=present',
    	:disposition => "attachment; filename=#{@outfile}"

  	flash[:notice] = "Export complete!"
  end
  def nopayment
	@accounts = MemberAccountBooking.sum(:amount,:group=>:member_id)


	@ids = Set.new
	@accounts.each do |account|
      if (account[1]<0) then
        @ids.add(account[0])
	  end
	end
	@orchestras = Orchestra.includes(:member).order("members.mglnr").find(:all, :conditions=> ["member_id in (?)",@ids])

    respond_to do |format|
     format.html
     format.json { render :json => @orchestras }
    end

  end

  def gema
    currentYear = String(Time.now.year)
    respond_to do |format|
      @orchestras = Orchestra.includes(:member,:report_sheets).where("report_sheets.year = ? and members.mglnr < 20000",currentYear).order("members.mglnr")
      format.csv { render :csv => @orchestras, :style=>:gema, :filename => "gema"+Time.now.year.to_s }
		format.json { render :json => @orchestras }
    end
  end

  def index
    @orchestras = Orchestra.includes(:member).search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(10)

    respond_to do |format|
      format.html # index.html.erb
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
  
end
