class ReportSheetsController < AuthenticatedController
  load_and_authorize_resource

	include ReportSheetHelper

  # GET /report_sheets
  # GET /report_sheets.json
  def index

	  if (params[:orchestra_id]) then
	    @report_sheets = ReportSheet.find_all_by_orchestra_id(params[:orchestra_id])
      thisYear = Time.now.year
      @report_sheets.each do |rs|
          if rs.year == thisYear then
            @has_current_report_sheet = true
          end
      end
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

  def copy_from_last_year
    @orchestra = Orchestra.find_by_member_id(params[:orchestra_id])

    @curYear = Time.now.year
    @prevYear = @curYear-1

    @prev = ReportSheet.where(:year=>@prevYear,:orchestra_id=>params[:orchestra_id]).first

    logger.debug "PREV Sheet ID: "+@prev.id.to_s

    @report_sheet = @prev.dup

    @report_sheet.year = Time.now.year
    @report_sheet.report_date = Time.now	
    @report_sheet.id=nil
    @report_sheet.init_empty
    @report_sheet.generated=true
    @report_sheet.comment= t("report_sheet.data_from_last_year")
  

    if  not @report_sheet.valid? then
      @report_sheet.errors.each do |e|
      logger.warn "Invalid: "+e.to_s+":"+@report_sheet.errors[e].to_s
     end
    end

    logger.debug("UV: "+@report_sheet.uv.to_s)

    respond_to do |format|
        if @report_sheet.save
          format.html { redirect_to orchestra_report_sheet_path(@report_sheet.orchestra,@report_sheet), :notice => t('report_sheet.create_success') }
        else
          logger.error("ERROR: could not save report sheet")
        end
        logger.info ("ID is: "+@report_sheet.id.to_s)
    end
          
  end

  def final
    @curYear = Time.now.year
    @final = ReportSheet.final(@curYear)

    respond_to do |format|
	  format.js
      format.html # index.html.erb
      format.json { render :json => @final }
    end
  end

  def not_final
    @not_final = ReportSheet.not_final

    respond_to do |format|
	  format.js
      format.html # index.html.erb
      format.json { render :json => @not_final }
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
    @report_sheet = ReportSheet.new
    @report_sheet.init_empty
	  @report_sheet.orchestra = @orchestra
	  @report_sheet.year = Time.now.year
	  @report_sheet.report_date = Time.now


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

    logger.debug params[:report_sheet].to_s
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

  def analysis
	@current_year = Time.now.year;
	@last_year = @current_year-1

	@sheets = ReportSheet.includes(:orchestra).where('year in  (?) and orchestra_id IS NOT NULL',[@current_year,@last_year]).order(:orchestra_id)

	@counts = Hash.new

	@warning_sheets = Array.new

	@sheets.each do |s|
		list = @counts[s.orchestra]
		if list == nil then
			list = Hash.new
			@counts[s.orchestra]=list
		end
		list[s.year]=s

		if list[@current_year] != nil and list[@last_year] != nil then
			Rails.logger.info("Both sheets present")
			last_sheet = list[@last_year]
			cur_sheet = list[@current_year]

			if triggers_warning?(last_sheet,cur_sheet) then

				ws = { "cur" => cur_sheet, "last" => last_sheet}
				
				@warning_sheets << ws
			end
		end
	end
	Rails.logger.debug(@warning_sheets.size)

	respond_to do |format|
		format.html
	end
  end

  def update_double_members
    @report_sheet = ReportSheet.find(params[:id])

	@report_sheet.azubi=params[:dm]

    respond_to do |format|
      if @report_sheet.save
        format.html { redirect_to orchestra_report_sheet_path(@report_sheet.orchestra,@report_sheet), :notice => t('report_sheet.update_double_success') }
        format.json { render :json => @report_sheet, :status => :update_double_success, :location => @report_sheet }
      else
        format.html { redirect_to orchestra_report_sheet_path(@report_sheet.orchestra,@report_sheet), :warning => t('report_sheet.update_double_failed') }
        format.json { render :json => @report_sheet.errors, :status => :unprocessable_entity }
	  end
	end
  end

end
