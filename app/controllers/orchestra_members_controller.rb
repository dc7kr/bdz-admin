class OrchestraMembersController < AuthenticatedController

  helper_method :sort_column, :sort_direction
  
  include ReportSheetUploadHelper

  # GET /orchestra_members
  # GET /orchestra_members.json
  def index

    @orchestra = nil

    if not params[:orchestra_id].nil? then
      @orchestra = Orchestra.find(params[:orchestra_id])
      @orchestra_members = @orchestra_members.where("orchestra_id = ?", params[:orchestra_id])
    end

    @orchestra_members = @orchestra_members.order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orchestra_members }
	    format.js
      format.ods {
        filename = gen_sheet(@orchestra_members)
        Rails.logger.debug("TMP File 2: "+ filename)
        send_file(filename, :filename => "orchestra_members.ods", :type => "application/octet-stream")
      }
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

	  @orchestra = @orchestra_member.orchestra

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @orchestra_member }
    end
  end


  def search
    @orchestra_members = OrchestraMember.where("first_name like ? and last_name like ?", params[:first_name]+"%",params[:last_name]+"%")
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
    session[:return_to] ||= request.referer
    @orchestra_member = OrchestraMember.find(params[:id])
	@orchestra = Orchestra.find(@orchestra_member.orchestra)
  end

  # POST /orchestra_members
  # POST /orchestra_members.json
  def create
	  @orchestra = Orchestra.find(params[:orchestra_id])
    @orchestra_member = OrchestraMember.new(orchestra_member_params)
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
      if @orchestra_member.update(orchestra_member_params)
        format.html { 
          redirect_to session.delete(:return_to), notice: t('orchestra_member.update_success') }
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
    @orchestra = Orchestra.find(params[:orchestra_id])
    @orchestra_members = @orchestra.orchestra_members

    @current_report_sheet = @orchestra.currentReportSheet
    @needs_update = false

    @faulty_members = Array.new
    @checked_members = Array.new
    @neutral_members = Array.new

    @orchestra_members.each do |o|
      if o.mglnr != nil and o.mglnr != 0 and o.mglnr != @orchestra.member.mglnr then
        orch = Orchestra.joins(:member).where("members.mglnr = ?",o.mglnr)	

        if (orch != nil and orch[0] != nil ) then
          Rails.logger.info("Found orchestra")
          @matching = OrchestraMember.where("orchestra_id = ? and first_name like ? and last_name like ?",orch[0].id,o.first_name,o.last_name).first

          if ( @matching != nil  ) then 
            other_orch = @matching.orchestra

            if other_orch.is_coop? or other_orch.is_lorch? then
              @faulty_members << o 
            else
              @checked_members << o
            end
          else 
            @faulty_members << o
          end
        else
          Rails.logger.info("Invalid mglnr: "+o.mglnr.to_s)
          @faulty_members << o
        end
      else 
        @neutral_members << o
      end
	  end

    if @checked_members.count != @current_report_sheet.azubi then
      @needs_update = true
    end
      
  end

  # DELETE /orchestra_members/1
  # DELETE /orchestra_members/1.json
  def destroy
    @orchestra_member = OrchestraMember.find(params[:id])
    orchestra = @orchestra_member.orchestra
    @orchestra_member.destroy

    respond_to do |format|
      format.html { redirect_to orchestra_orchestra_members_url(orchestra) }
      format.json { head :no_content }
    end
  end

  # POST
  def upload
    @orchestra = Orchestra.find(params[:orchestra_id])
    datafile = params[:datafile]

    prefix = @orchestra.member.mglnr.to_s+"_"+Time.now.year.to_s+"_"

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
  def orchestra_member_params
    params.require(:orchestra_member).permit(:first_name,:last_name,:date_of_birth,:instrument,:mglnr)
  end

  def gen_sheet(orchestra_members)
    tmpfile = Tempfile.new("mgl")
    
    filename = tmpfile.path

    Rails.logger.debug("TMP File: "+filename)

	  ODF::Spreadsheet.file(filename) do

      table "Mitglieder"  do
        row {
          cell "Vorname"
          cell "Name"
          cell "Mgl.Nr. des Vereins (*)"
          cell "Geburtsjahr"
          cell "Instrument"
          cell "(*) Nur für Landesorchester ausfüllen!"
        }

        orchestra_members.each do |om|
          row {
            cell om.first_name
            cell om.last_name
            cell om.mglnr
            cell om.date_of_birth
            cell om.instrument
          }
        end
      end
    end
    filename
  end
end
