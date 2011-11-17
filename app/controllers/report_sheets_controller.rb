class ReportSheetsController < ApplicationController
  # GET /report_sheets
  # GET /report_sheets.json
  def index
    @report_sheets = ReportSheet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @report_sheets }
    end
  end

  # GET /report_sheets/1
  # GET /report_sheets/1.json
  def show
    @report_sheet = ReportSheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @report_sheet }
    end
  end

  # GET /report_sheets/new
  # GET /report_sheets/new.json
  def new
    @report_sheet = ReportSheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @report_sheet }
    end
  end

  # GET /report_sheets/1/edit
  def edit
    @report_sheet = ReportSheet.find(params[:id])
  end

  # POST /report_sheets
  # POST /report_sheets.json
  def create
    @report_sheet = ReportSheet.new(params[:report_sheet])

    respond_to do |format|
      if @report_sheet.save
        format.html { redirect_to @report_sheet, :notice => 'Report sheet was successfully created.' }
        format.json { render :json => @report_sheet, :status => :created, :location => @report_sheet }
      else
        format.html { render :action => "new" }
        format.json { render :json => @report_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /report_sheets/1
  # PUT /report_sheets/1.json
  def update
    @report_sheet = ReportSheet.find(params[:id])

    respond_to do |format|
      if @report_sheet.update_attributes(params[:report_sheet])
        format.html { redirect_to @report_sheet, :notice => 'Report sheet was successfully updated.' }
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
    @report_sheet = ReportSheet.find(params[:id])
    @report_sheet.destroy

    respond_to do |format|
      format.html { redirect_to report_sheets_url }
      format.json { head :ok }
    end
  end
end
