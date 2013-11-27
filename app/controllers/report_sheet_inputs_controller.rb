class ReportSheetInputsController < AuthenticatedController

  include NotifyHelper  
  include UploadHelper
  include ReportSheetUploadHelper

  # GET /report_sheet_inputs
  # GET /report_sheet_inputs.json
  def index
    @report_sheet_inputs = ReportSheetInput.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @report_sheet_inputs }
    end
  end

  # GET /report_sheet_inputs/1
  # GET /report_sheet_inputs/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report_sheet_input }
    end
  end

  # GET /report_sheet_inputs/new
  # GET /report_sheet_inputs/new.json
  def new
	@year = Time.now.year+1

  	@orchestra = Orchestra.includes(:member).find(params[:orchestra_id])
    @report_sheet_input = ReportSheetInput.new_for_orchestra(@orchestra,@year)
 
    respond_to do |format|
      format.html { redirect_to @report_sheet_input, notice: 'Report sheet input was successfully created.' }
      format.json { render json: @report_sheet_input, status: :created, location: @report_sheet_input }
    end
  end

	# POST /report_sheet_inputs
	# POST /report_sheet_inputs
	# POST /report_sheet_inputs.json
	def create
		@report_sheet_input = ReportSheetInput.new(params[:report_sheet_input])
		if ( current_user != nil ) then
			@report_sheet_input.admin_flag=true
		else
			@report_sheet_input.admin_flag=false
		end

		respond_to do |format|
		  if @report_sheet_input.save
				format.html { redirect_to @report_sheet_input, notice: 'Report sheet input was successfully created.' }
				format.json { render json: @report_sheet_input, status: :created, location: @report_sheet_input }
			  else
				format.html { render action: "new" }
				format.json { render json: @report_sheet_input.errors, status: :unprocessable_entity }
			  end
			end
		  end

		  # PUT /report_sheet_inputs/1
		  # PUT /report_sheet_inputs/1.json
		  def update
			@report_sheet_input = ReportSheetInput.find(params[:id])

			respond_to do |format|
			  if @report_sheet_input.update_attributes(params[:report_sheet_input])
				format.html { redirect_to @report_sheet_input, notice: 'Report sheet input was successfully updated.' }
				format.json { head :no_content }
			  else
				format.html { render action: "edit" }
				format.json { render json: @report_sheet_input.errors, status: :unprocessable_entity }
			  end
			end
		  end

  # DELETE /report_sheet_inputs/1
  # DELETE /report_sheet_inputs/1.json
  def destroy
    @report_sheet_input = ReportSheetInput.find(params[:id])
    @report_sheet_input.destroy

    respond_to do |format|
      format.html { redirect_to report_sheet_inputs_url }
      format.json { head :no_content }
    end
  end

	def generate
    authorize! :index, Orchestra
    rs_year = params[:year].to_i

    if params[:year]== nil then
      rs_year = Time.now.year+1
    end

    @count = 0
    @orchestras = Orchestra.includes(:member)
    
    @orchestras.each do |o|
      @rsi = ReportSheetInput.for_orchestra_and_year(o,rs_year)
      if ( @rsi == nil ) then
        @rsi = ReportSheetInput.new_for_orchestra(o,rs_year)
      
        if @rsi.report_sheet.save then
  	      @rsi.save
        else 
          logger.warn(@rsi.report_sheet.errors.full_messages.join("\n"))
          logger.warn("Something went wrong during save of report sheet!")
        end

        @count+=1
      end
    end

    respond_to do |format|
      format.html {
        redirect_to  :back, notice: t('report_sheet_input.generated', count: @count ) 
			}
    end
	end

  def lockdown
  	@report_sheet_inputs = ReportSheetInput.not_final

    @report_sheet_inputs.each do |rs|
      rs.report_sheet.destroy
	  rs.destroy
    end
  end
end
