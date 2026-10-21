class ReportSheetInputsController < AuthenticatedController
  include NotifyHelper
  include UploadHelper
  include ReportSheetUploadHelper

  before_action :set_report_sheet_input, only: %i[ show destroy metadata ]

  # GET /report_sheet_inputs
  # GET /report_sheet_inputs.json
  def index
    if params[:orch].present?
      @orchestra = policy_scope(Orchestra).find(params[:orch])
    end

    @report_sheet_inputs = if params[:orch].nil?
      policy_scope(ReportSheetInput).includes(:orchestra).page(params[:page]).per(20)
    else
      policy_scope(ReportSheetInput).includes(:orchestra).where(orchestra_id: params[:orch]).page(params[:page]).per(20)
    end

    respond_to do |format|
      format.turbo_stream { render partial: "list", locals: { resources: @report_sheet_inputs }  }
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
    @year = Time.zone.now.year + 1

    @orchestra = Orchestra.includes(:member).find(params[:orchestra_id])
    @report_sheet_input = policy_scope(ReportSheetInput).new_for_orchestra(@orchestra, @year)
    authorize @report_sheet_input

    respond_to do |format|
      format.html { redirect_to @report_sheet_input, notice: "Report sheet input was successfully created." }
      format.json { render json: @report_sheet_input, status: :created, location: @report_sheet_input }
    end
  end

  # DELETE /report_sheet_inputs/1
  # DELETE /report_sheet_inputs/1.json
  def destroy
    @report_sheet_input = policy_scope(ReportSheetInput).find(params[:id])
    authorize @report_sheet_input
    @report_sheet_input.destroy

    respond_to do |format|
      format.html { redirect_to report_sheet_inputs_url }
      format.json { head :no_content }
    end
  end

  def generate
    authorize! :index, Orchestra

    rs_year = Time.zone.now.year + 1

    rs_year = params[:year].to_i unless params[:year].nil?

    GenerateReportSheetInputsJob.perform_later(rs_year)

    respond_to do |format|
      format.html do
        redirect_to home_cron_path, notice: t("report_sheet_input.generation_triggered")
      end
    end
  end

  def metadata
    @report_sheet_input = policy_scope(ReportSheetInput).find(params[:id])
  end

  # removes all inputs that were never submitted, invoiced ones are kept
  def lockdown
    authorize ReportSheetInput

    @report_sheet_inputs = policy_scope(ReportSheetInput).not_final.to_a.reject(&:locked?)

    @report_sheet_inputs.each do |rs|
      rs.report_sheet.destroy
      rs.destroy
    end
  end

  private
  def set_report_sheet_input
    @report_sheet_input = policy_scope(ReportSheetInput).find(params[:id])
    authorize @report_sheet_input
  end
end
