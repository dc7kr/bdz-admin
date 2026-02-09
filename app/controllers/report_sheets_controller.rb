class ReportSheetsController < AuthenticatedController
  include ReportSheetHelper

  include ApplicationHelper

  before_action :set_report_sheet, only: %i[ show edit update destroy invoice_preview ]

  # GET /report_sheets
  # GET /report_sheets.json
  def index
    if params[:orchestra_id]
      @orchestra = policy_scope(Orchestra).find(params[:orchestra_id])

      @report_sheets = @orchestra.report_sheets.order(:year)
      thisYear = Time.zone.now.year
      @report_sheets.each do |rs|
        @has_current_report_sheet = true if rs.year == thisYear
      end
    elsif params[:regional_organization_id]

      year = if params[:year].nil?
               Time.zone.now.year
      else
               params[:year]
      end
      @report_sheets = ReportSheet.for_regional_organization(year, params[:regional_organization_id])

    else
      @curYear = Time.zone.now.year
      @report_sheets = ReportSheet.joins(orchestra: :member).order("members.mglnr").find_all_by_year(@curYear)
    end

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @report_sheets }
      format.ods do
        tmpfile = Tempfile.new("report_sheets")
        ReportSheet.renderOds(@report_sheets, tmpfile.path)
        send_file(tmpfile.path, filename: "meldeboegen_#{year}.ods", type: "application/octet-stream")
      end
    end
  end

  def copy_from_last_year
    @orchestra = Orchestra.find(params[:orchestra_id])

    @curYear = Time.zone.now.year
    @prevYear = @curYear - 1

    @prev = ReportSheet.where(year: @prevYear, orchestra_id: params[:orchestra_id]).first

    logger.debug "PREV Sheet ID: #{@prev.id}"

    @cur = ReportSheet.where(year: @curYear, orchestra_id: params[:orchestra_id]).first

    cur_id = if @cur.nil?
               nil
    else
               @cur.id
    end

    @cur = @prev.dup
    @cur.year = Time.zone.now.year
    @cur.report_date = Time.zone.now
    @cur.id = cur_id
    @cur.init_empty
    @cur.generated = true
    @cur.comment = t("report_sheet.data_from_last_year")
    @cur.orchestra = @orchestra

    unless @cur.valid?
      @cur.errors.each do |e|
        logger.warn "Invalid: #{e}:#{@cur.errors[e]}"
      end
    end

    logger.debug("UV: #{@cur.uv}")

    respond_to do |format|
      if @cur.save
        format.html do
          redirect_to orchestra_report_sheet_path(@cur.orchestra, @cur), notice: t("report_sheet.create_success")
        end
      else
        logger.error("ERROR: could not save report sheet")
      end
      logger.info("ID is: #{@cur.id}")
    end
  end

  def final
    @curYear = params[:year] || Time.zone.now.year
    @final = policy_scope(ReportSheet).final(@curYear)

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @final }
    end
  end

  def not_final
    @not_final = ReportSheet.not_final

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @not_final }
    end
  end

  def payed
    @curYear = Time.zone.now.year
    @report_sheets = ReportSheet.joins(orchestra: :member).order("members.mglnr").where(report_sheets: { year: @curYear }).page(params[:page]).per(20)
    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @report_sheets }
    end
  end

  # GET /report_sheets/1
  # GET /report_sheets/1.json
  def show
    @orchestra = @report_sheet.orchestra

    @booking = @report_sheet.find_booking
    @invoice = @report_sheet.orchestra.gen_invoice(@report_sheet.year)

    @age_categories = @report_sheet.orchestra_members_to_age_categories(@orchestra.orchestra_members)

    @consistent = @report_sheet.is_consistent?

    @invoiced = @report_sheet.is_invoiced?
    @invoice_delta = @report_sheet.invoice_delta

    @needs_update = @invoice_delta != 0

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report_sheet }
      format.pdf do
        pdf = ReportSheetInputPdf.new(@report_sheet, view_context)
        filename = "meldebogen#{@report_sheet.year}_#{@report_sheet.orchestra.member.mglnr}.pdf"
        send_data pdf.render, filename: filename, type: "application/pdf"
      end
    end
  end

  # GET /report_sheets/new
  # GET /report_sheets/new.json
  def new
    @orchestra = Orchestra.find(params[:orchestra_id])
    @report_sheet = ReportSheet.new
    @report_sheet.init_empty
    @report_sheet.orchestra = @orchestra
    @report_sheet.year = Time.zone.now.year
    @report_sheet.report_date = Time.zone.now
    authorize @report_sheet

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report_sheet }
    end
  end

  # GET /report_sheets/1/edit
  def edit
    @report_sheet = ReportSheet.find(params[:id])
    @orchestra = Orchestra.find(params[:orchestra_id])
  end

  # POST /report_sheets
  # POST /report_sheets.json
  def create
    @report_sheet = ReportSheet.new(report_sheet_params)
    orchestra = Orchestra.find(params[:orchestra_id])
    @report_sheet.orchestra = orchestra
    authorize @report_sheet

    respond_to do |format|
      if @report_sheet.save
        format.html do
          redirect_to orchestra_report_sheet_path(@report_sheet.orchestra, @report_sheet),
                      notice: t("report_sheet.create_success")
        end
        format.json { render json: @report_sheet, status: :created, location: @report_sheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orchestras/42/report_sheets/1
  # PUT /orchestras/42/report_sheets/1.json
  def update
    @report_sheet = ReportSheet.includes(:orchestra).find(params[:id])

    respond_to do |format|
      if @report_sheet.update(report_sheet_params)
        format.html do
          redirect_to orchestra_report_sheet_path(@report_sheet.orchestra, @report_sheet),
                      notice: t_update_success("report_sheet")
        end
        format.json { head :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /report_sheets/1
  # DELETE /report_sheets/1.json
  def destroy
    @report_sheet = ReportSheet.includes(:orchestra).find(params[:id])
    @orchestra = Orchestra.find(@report_sheet.orchestra_id)
    @report_sheet.destroy

    respond_to do |format|
      format.html { redirect_to orchestra_report_sheets_path(@orchestra) }
      format.json { head :ok }
    end
  end

  def invoice_preview
    #if not @report_sheet.invoice_id.nil?
    #  @invoice = CorikaInvoices::Invoice.find(@report_sheet.invoice_id)
    #else
      @invoice = @report_sheet.orchestra.gen_invoice(@report_sheet.year)
    #end

    @invoice_hash = @invoice.to_hash[:invoice]


    respond_to do |format|
      format.turbo_stream { render template: "corika_invoices/invoices/preview" }
      format.html { render template: "corika_invoices/invoices/preview" }
      format.json { render json: @invoice }
    end
  end


  def analysis
    @current_year = Time.zone.now.year
    @last_year = @current_year - 1

    @sheets = policy_scope(ReportSheet).includes(:orchestra).where("year in  (?) and orchestra_id IS NOT NULL",
                                                     [ @current_year, @last_year ]).order(:orchestra_id)

    @counts = {}

    @warning_sheets = []

    @sheets.each do |s|
      list = @counts[s.orchestra]
      if list.nil?
        list = {}
        @counts[s.orchestra] = list
      end
      list[s.year] = s

      next unless !list[@current_year].nil? && !list[@last_year].nil?

      Rails.logger.info("Both sheets present")
      last_sheet = list[@last_year]
      cur_sheet = list[@current_year]

      next unless triggers_warning?(last_sheet, cur_sheet)

      ws = { "cur" => cur_sheet, "last" => last_sheet }

      @warning_sheets << ws
    end
    Rails.logger.debug(@warning_sheets.size)

    respond_to do |format|
      format.html
    end
  end

  def update_double_members
    @report_sheet = ReportSheet.find(params[:id])

    @report_sheet.azubi = params[:dm]

    respond_to do |format|
      if @report_sheet.save
        format.html do
          redirect_to orchestra_report_sheet_path(@report_sheet.orchestra, @report_sheet),
                      notice: t("report_sheet.update_double_success")
        end
        format.json { render json: @report_sheet, status: :update_double_success, location: @report_sheet }
      else
        format.html do
          redirect_to orchestra_report_sheet_path(@report_sheet.orchestra, @report_sheet),
                      warning: t("report_sheet.update_double_failed")
        end
        format.json { render json: @report_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def gen_invoice_pdf
    @report_sheet = ReportSheet.find(params[:id])

    tex_writer = CorikaInvoices::TexWriter.new
    invoice = @report_sheet.orchestra.gen_invoice(@report_sheet.year)

    @report_sheet.gen_invoice_pdf(tex_writer, invoice, nil)

    invoice_file = @report_sheet.gen_invoice_pdf(invoice)
    send_file(invoice_file.path, filename: invoice_file.orig_filename, type: "application/octet-stream")
  end

  def update_from_members
    @orchestra = Orchestra.find(params[:orchestra_id])
    @report_sheet = ReportSheet.find(params[:id])

    respond_to do |format|
      if @report_sheet.update_from_orchestra_members(@orchestra.orchestra_members)
        format.html do
          redirect_to orchestra_report_sheet_path(@report_sheet.orchestra, @report_sheet),
                      notice: t("report_sheet.update_from_memberssuccess")
        end
      else
        format.html do
          redirect_to orchestra_report_sheet_path(@report_sheet.orchestra, @report_sheet),
                      warning: t("report_sheet.update_from_members_failed")
        end
      end
    end
  end

  def update_invoice
    @orchestra = Orchestra.find(params[:orchestra_id])
    @report_sheet = ReportSheet.find(params[:id])
    authorize @report_sheet

    year = @report_sheet.year

    @delta_value = @report_sheet.invoice_delta

    if @delta_value.zero?
      respond_to do |format|
        format.html do
          redirect_to orchestra_report_sheet_path(@report_sheet.orchestra, @report_sheet),
                      notice: t("report_sheet.no_update_needed")
        end
      end
      return
    end

    GenerateOrchestraInvoiceJob.perform_later(@report_sheet.orchestra.id, @report_sheet.year, current_user.id)

    respond_to do |format|
      format.html do
        redirect_to orchestra_report_sheet_path(@report_sheet.orchestra, @report_sheet),
          notice: t("report_sheets.notice.background_job_triggered")
      end
    end
  end

  def gen_pdf
    pdf = ReportSheetInputPdf.new(@rsi, view_context)

    respond_to do |format|
      format.ods do
        tmpfile = Tempfile.new("report_sheets")
        ReportSheet.renderOds(@report_sheets, tmpfile.path)
        send_file(tmpfile.path, filename: "meldeboegen_#{year}.ods", type: "application/octet-stream")
      end
      send_file(pdf)
    end
  end

  private

    def set_report_sheet
      @report_sheet = policy_scope(ReportSheet).find(params[:id])
      authorize @report_sheet
    end

  def report_sheet_params
    params.require(:report_sheet).permit(
      :year, :children, :teens, :youth, :adult, :senior, :uv,
      :zusatz_uv, :korr_ztg, :zusatz_ztg, :gema, :azubi, :passive,
      :child_ens, :youth_ens, :adult_ens, :senior_ens, :chamber_ens,
      :other_ens, :token, :azubi_child, :azubi_teens, :azubi_youth,
      :azubi_adult, :azubi_senior, :supporters, :zo, :zi_o, :go, :oz,
      :report_date, :report_date_str, :comment, :ms_total
    )
  end
  
  protected
  def index_actions
    super.append(:final, :analysis)
  end

end
