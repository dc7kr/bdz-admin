class OrchestraMembersController < AuthenticatedController

  helper_method :sort_column, :sort_direction
  
  include ReportSheetUploadHelper

  # GET /orchestra_members
  # GET /orchestra_members.json
  def index
    @orchestra_members = OrchestraMember.where("orchestra_id = ?", params[:orchestra_id]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)


	@orchestra = Orchestra.find(params[:orchestra_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orchestra_members }
	  format.js
    end
  end

  def delete_members
	@orchestra = Orchestra.find(params[:orchestra_id])
	@orchestra.orchestra_members.delete_all
    respond_to do |format|
        format.html { redirect_to orchestra_orchestra_members_path(@orchestra), notice: t('report_sheet_input.member_delete_success') }
    end
  end
 
  # GET /orchestra_members/1
  # GET /orchestra_members/1.json
  def show
    @orchestra_member = OrchestraMember.find(params[:id])
	
	@orchestra = Orchestra.find(params[:orchestra_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @orchestra_member }
    end
  end

  # GET /orchestra_members/new
  # GET /orchestra_members/new.json
  def new
    @orchestra_member = OrchestraMember.new
	@orchestra = Orchestra.find(params[:orchestra_id])
	@orchestra_member.orchestra = @orchestra

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @orchestra_member }
    end
  end

  # GET /orchestra_members/1/edit
  def edit
    @orchestra_member = OrchestraMember.find(params[:id])
	@orchestra = Orchestra.find(@orchestra_member.orchestra)
  end

  # POST /orchestra_members
  # POST /orchestra_members.json
  def create
	@orchestra = Orchestra.find(params[:orchestra_id])
    @orchestra_member = OrchestraMember.new(params[:orchestra_member])
	@orchestra_member.orchestra = @orchestra

    respond_to do |format|
      if @orchestra_member.save
        format.html { redirect_to orchestra_orchestra_member_path(@orchestra_member.orchestra,@orchestra_member), notice: 'Orchestra member was successfully created.' }
        format.json { render json: @orchestra_member, status: :created, location: @orchestra_member }
      else
        format.html { render action: "new" }
        format.json { render json: @orchestra_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orchestra_members/1
  # PUT /orchestra_members/1.json
  def update
    @orchestra_member = OrchestraMember.find(params[:id])

    respond_to do |format|
      if @orchestra_member.update_attributes(params[:orchestra_member])
        format.html { redirect_to orchestra_orchestra_member_path(@orchestra_member.orchestra,@orchestra_member), notice: t('orchestra_member.update_success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @orchestra_member.errors, status: :unprocessable_entity }
      end
    end
  end

  def exchange
    @orchestra_member = OrchestraMember.find(params[:id])

	name = @orchestra_member.last_name
	first = @orchestra_member.first_name

	@orchestra_member.last_name=first
	@orchestra_member.first_name=name

    respond_to do |format|
      if @orchestra_member.save
        format.html { redirect_to orchestra_orchestra_members_path(@orchestra_member.orchestra), notice: t('orchestra_member.exchange_success') }
      end
	end
  end

  def check_double
    @orchestra_members = OrchestraMember.where("orchestra_id = ?", params[:orchestra_id])

	@faulty_members = Array.new
	@checked_members = Array.new
	@orchestra = Orchestra.find(params[:orchestra_id])
	@orchestra_members.each do |o|
		if o.mglnr != nil and o.mglnr != 0 then
			orch = Orchestra.includes(:member).where("members.mglnr = ?",o.mglnr)	

			if (orch != nil and orch[0] != nil ) then
				Rails.logger.info("Found orchestra")
				@matching = OrchestraMember.where("orchestra_id = ? and first_name like ? and last_name like ?",orch[0].id,o.first_name,o.last_name)

				if ( @matching != nil and @matching[0] != nil ) then 
					@checked_members << @matching[0]
				else 
					@faulty_members << o
				end
			else
				Rails.logger.info("Invalid mglnr: "+o.mglnr.to_s)
				@faulty_members << o
			end
		end
	end
	
  end

  # DELETE /orchestra_members/1
  # DELETE /orchestra_members/1.json
  def destroy
    @orchestra_member = OrchestraMember.find(params[:id])
    @orchestra_member.destroy

    respond_to do |format|
      format.html { redirect_to orchestra_orchestra_members_url(params[:orchestra_id]) }
      format.json { head :no_content }
    end
  end

  # POST
  def upload
    @orchestra = Orchestra.find(params[:orchestra_id])
    datafile = params[:datafile]

    prefix = @orchestra.mglnr.to_s+"_"+Time.now.year.to_s+"_"

    if (datafile == nil ) then
      redirect_to orchestra_orchestra_members_upload_path(@orchestra), :flash => { :error => t('upload.no_file_selected') }
      return
    end

    uploaded_file = DataFile.save(prefix, "/tmp",params[:datafile])


    if ( datafile != nil) then
      @att_file = datafile.original_filename

      doc = open_report_spreadsheet(@att_file,uploaded_file)
      if ( doc == nil ) then
        redirect_to orchestra_orchestra_members_path(@orchestra), :flash => { :error => t('upload.invalid_upload') }
      else
        read_report(doc,@orchestra)
        if ( @error_count > 0 ) then
          redirect_to orchestra_orchestra_members_path(@orchestra), :flash => { :warning=> t('orchestra.report_sheet_upload_warning',:error => @error_count,:success => @success_count) }
        else
          redirect_to orchestra_orchestra_members_path(@orchestra), :flash => { :notice=> t('orchestra.report_sheet_upload_success',:success => @success_count) }
        end
      end
    end
  end

  #########################
  # PRIVATE METHODS
  #########################
  private 
  def sort_column
    OrchestraMember.column_names.include?(params[:sort]) ? params[:sort] : "last_name,first_name"
  end
end
