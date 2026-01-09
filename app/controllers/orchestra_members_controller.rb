class OrchestraMembersController < AuthenticatedController
  include ApplicationHelper
  helper_method :sort_column, :sort_direction
  before_action :set_orchestra_member, only: %i[ show edit update destroy ]

  include ReportSheetUploadHelper

  # GET /orchestra_members
  # GET /orchestra_members.json
  def index
    @orchestra = nil

    unless params[:orchestra_id].nil?
      @orchestra = policy_scope(Orchestra).find(params[:orchestra_id])
      @orchestra_members = policy_scope(OrchestraMember).where(orchestra_id: params[:orchestra_id])
    end

    respond_to do |format|
      format.html do
        @orchestra_members = @orchestra_members.order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
      end

      format.json do
        @orchestra_members = @orchestra_members.order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
        render json: @orchestra_members
      end
      format.js do
        @orchestra_members = @orchestra_members.order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
      end
      format.ods do
        @orchestra_members = @orchestra_members.order(:last_name, :first_name)

        sheet = OrchestraMembersSpreadsheet.new(@orchestra_members)
        sheet.render
        filename = sheet.gen_file

        send_file(filename, filename: "orchestra_members.ods", type: "application/octet-stream")
      end
    end
  end

  def delete_members
    @orchestra = policy_scope(Orchestra.find(params[:orchestra_id]))
    @orchestra.orchestra_members.delete_all
    respond_to do |format|
      format.html do
        redirect_to orchestra_orchestra_members_path(@orchestra), notice: t("report_sheet_input.member_delete_success")
      end
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
    @orchestra_members = policy_scope(OrchestraMember).where("first_name like ? and last_name like ?", "#{params[:first_name]}%",
                                                             "#{params[:last_name]}%").order(:last_name,:first_name)
    respond_to do |format|
      format.html
    end
  end

  # GET /orchestra_members/new
  # GET /orchestra_members/new.json
  def new
    authorize OrchestraMember
    @orchestra_member = OrchestraMember.new
    @orchestra = policy_scope(Orchestra).find(params[:orchestra_id])
    @orchestra_member.orchestra = @orchestra

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @orchestra_member }
    end
  end

  # GET /orchestra_members/1/edit
  def edit
    session[:return_to] ||= request.referer
    @orchestra = @orchestra_member.orchestra

    authorize @orchestra_member
  end

  # POST /orchestra_members
  # POST /orchestra_members.json
  def create
    authorize OrchestraMember
    @orchestra = Orchestra.find(params[:orchestra_id])
    @orchestra_member = OrchestraMember.new(orchestra_member_params)
    @orchestra_member.orchestra = @orchestra

    respond_to do |format|
      if @orchestra_member.save
        format.html do
          redirect_to orchestra_orchestra_member_path(@orchestra_member.orchestra, @orchestra_member),
                      notice: "Orchestra member was successfully created."
        end
        format.json { render json: @orchestra_member, status: :created, location: @orchestra_member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @orchestra_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orchestra_members/1
  # PUT /orchestra_members/1.json
  def update
    respond_to do |format|
      if @orchestra_member.update(orchestra_member_params)
        format.html do
          redirect_to session.delete(:return_to),
                      notice: t_update_success("orchestra_member")
        end
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @orchestra_member.errors, status: :unprocessable_entity }
      end
    end
  end

  def exchange_all
    orchestra = Orchestra.find(params[:orchestra_id])

    orchestra.orchestra_members.each do |om|
      om.exchange_first_and_lastname
      om.save
    end

    format.html do
      redirect_to orchestra_orchestra_members_url(orchestra)
    end
  end

  def exchange
    @orchestra_member = policy_scope(OrchestraMember).find(params[:id])

    @orchestra_member.exchange_first_and_lastname

    respond_to do |format|
      if @orchestra_member.save
        format.html do
          redirect_to orchestra_orchestra_members_path(@orchestra_member.orchestra),
                      notice: t("orchestra_member.exchange_success")
        end
      end
    end
  end

  def check_double
    @orchestra = Orchestra.find(params[:orchestra_id])
    @current_report_sheet = @orchestra.currentReportSheet
    @needs_update = false

    @result = @orchestra.check_double

    return unless !@current_report_sheet.nil? && (@result[:verified].count != @current_report_sheet.azubi)

    @needs_update = true
  end

  # DELETE /orchestra_members/1
  # DELETE /orchestra_members/1.json
  def destroy
    @orchestra_member = policy_scope(OrchestraMember).find(params[:id])
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

    prefix = "#{@orchestra.member.mglnr}_#{Time.zone.now.year}_"

    if datafile.nil?
      redirect_to orchestra_orchestra_members_upload_path(@orchestra),
                  flash: { error: t("upload.no_file_selected") }
      return
    end

    uploaded_file = DataFile.save(prefix, "/tmp", params[:datafile])

    return if datafile.nil?

    @att_file = datafile.original_filename

    doc = open_report_spreadsheet(@att_file, uploaded_file)
    if doc.nil?
      redirect_to orchestra_orchestra_members_path(@orchestra), flash: { error: t("upload.invalid_upload") }
    else
      read_report(doc, @orchestra)
      if @error_count.positive?
        redirect_to orchestra_orchestra_members_path(@orchestra),
                    flash: { warning: t("orchestra.report_sheet_upload_warning", error: @error_count,
                                                                                 success: @success_count) }
      else
        redirect_to orchestra_orchestra_members_path(@orchestra),
                    flash: { notice: t("orchestra.report_sheet_upload_success", success: @success_count) }
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
    params.require(:orchestra_member).permit(:first_name, :last_name, :date_of_birth, :instrument, :mglnr)
  end

  def set_orchestra_member
    @orchestra_member = policy_scope(OrchestraMember).find(params[:id])
    authorize @orchestra_member
  end

  def index_actions
    super.append(:search)
  end
end
