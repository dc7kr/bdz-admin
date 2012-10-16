class ReportSheetsController < AuthenticatedController
  load_and_authorize_resource
  # GET /report_sheets
  # GET /report_sheets.json
  def index

	if (params[:orchestra_id]) then
	    @report_sheets = ReportSheet.find_all_by_orchestra_id(params[:orchestra_id])
    	@orchestra = Orchestra.find_by_member_id(params[:orchestra_id])
	else 
		@curYear = Time.now.year
		@report_sheets = ReportSheet.joins(:orchestra => :member).order('members.mglnr').find_all_by_year(@curYear)
	end

    respond_to do |format|
	  format.js
      format.html # index.html.erb
      format.json { render :json => @report_sheets }
    end
  end

  def payed 
		@curYear = Time.now.year
		@report_sheets = ReportSheet.joins(:orchestra => :member).order('members.mglnr').where("report_sheets.year = ?",@curYear).page(params[:page]).per(20)
    respond_to do |format|
	  format.js
      format.html # index.html.erb
      format.json { render :json => @report_sheets }
    end
  end

  # GET /report_sheets/1
  # GET /report_sheets/1.json
  def show
    @report_sheet = ReportSheet.find(params[:id])
    @orchestra = @report_sheet.orchestra

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @report_sheet }
    end
  end

  # GET /report_sheets/new
  # GET /report_sheets/new.json
  def new
    @orchestra = Orchestra.find_by_member_id(params[:orchestra_id])
    @report_sheet = ReportSheet.new(:orchestra=>@orchestra,:year=>Time.now.year,
		:youth=>0,
		:children=>0,
		:teens=>0,
		:adult=>0,
		:senior=>0,
		:passive=>0,
		:azubi=>0
    )

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @report_sheet }
    end
  end

  # GET /report_sheets/1/edit
  def edit
    @report_sheet = ReportSheet.find(params[:id])
    @orchestra = Orchestra.find_by_member_id(params[:orchestra_id])
  end

  # POST /report_sheets
  # POST /report_sheets.json
  def create
    @report_sheet = ReportSheet.new(params[:report_sheet])

    respond_to do |format|
      if @report_sheet.save
        format.html { redirect_to orchestra_report_sheet_path(@report_sheet.orchestra,@report_sheet), :notice => t('report_sheet.create_success') }
        format.json { render :json => @report_sheet, :status => :created, :location => @report_sheet }
      else
        format.html { render :action => "new" }
        format.json { render :json => @report_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orchestras/42/report_sheets/1
  # PUT /orchestras/42/report_sheets/1.json
  def update
    @report_sheet = ReportSheet.includes(:orchestra).find(params[:id])

    respond_to do |format|
      if @report_sheet.update_attributes(params[:report_sheet])
        format.html { redirect_to orchestra_report_sheet_path(@report_sheet.orchestra,@report_sheet), :notice => I18n.t('report_sheet.title')+' '+t('common.update_success') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @report_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /report_sheets/1
  # DELETE /report_sheets/1.json
  def destroy
    @report_sheet = ReportSheet.includes(:orchestra).find(params[:id])
    @orchestra = Orchestra.find_by_member_id(@report_sheet.orchestra_id)
    @report_sheet.destroy

    respond_to do |format|
      format.html { redirect_to orchestra_report_sheets_path(@orchestra)}
      format.json { head :ok }
    end
  end
end
