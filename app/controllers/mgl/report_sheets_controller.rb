module Mgl
  # Report sheets of the member's orchestra. They can be changed until they
  # have been invoiced (ReportSheet#locked?).
  class ReportSheetsController < BaseController
    AGE_CATEGORY_ATTRIBUTES = { "C" => :children, "T" => :teens, "Y" => :youth, "A" => :adult, "S" => :senior }.freeze

    before_action :set_report_sheet, only: %i[show edit update]

    def index
      authorize ReportSheet
      @report_sheets = policy_scope(ReportSheet).order(year: :desc)
    end

    def show
    end

    def edit
    end

    def update
      @report_sheet.assign_attributes(report_sheet_params)

      # like the report sheet input wizard: age groups are counted from the
      # orchestra member list, if there is one
      members = current_orchestra.orchestra_members
      if members.any?
        @report_sheet.assign_attributes(@report_sheet.orchestra_members_to_age_categories(members)
          .transform_keys { |category| AGE_CATEGORY_ATTRIBUTES.fetch(category) })
      end

      if @report_sheet.save
        redirect_to mgl_report_sheet_path(@report_sheet), notice: t("mgl.saved")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_report_sheet
      @report_sheet = policy_scope(ReportSheet).find(params[:id])
      return authorize(@report_sheet) if action_name == "show" || policy([ :mgl, @report_sheet ]).update?

      authorize @report_sheet, :show?
      redirect_to mgl_report_sheet_path(@report_sheet), flash: { error: t("mgl.report_sheets.locked") }
    end

    # same fields as in the report sheet input wizard
    def report_sheet_params
      params.require(:report_sheet).permit(:uv,
                                           :azubi_child, :azubi_teens, :azubi_youth, :azubi_adult, :azubi_senior,
                                           :passive, :supporters,
                                           :child_ens, :youth_ens, :adult_ens, :senior_ens, :other_ens,
                                           :zo, :zi_o, :go, :oz, :ms_total)
    end
  end
end
