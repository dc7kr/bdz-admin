require "rodf"
require "csv"

class OrchestrasController < AuthenticatedController
  include ApplicationHelper
  # for table sort by column click
  helper_method :sort_column, :sort_direction

  before_action :set_orchestra, only: %i[ show edit update destroy invoice_preview ]

  #authority_actions lorch: "read"

  include UploadHelper
  include ReportSheetUploadHelper
  include PdfHelper
  include MagazineReportHelper
  #
  #  JSON ONLY
  #
  def addresses
    @orchestras = if params[:nomail]
                    Orchestra.nomail
    elsif params[:mailonly]
                    Orchestra.mail
    else
                    Orchestra.includes(:member).all
    end
    # where("members.email IS NULL or members.email=''")
    # respond_to do |format|
    #		format.json {
    render json: @orchestras.to_json(include: { member: {} })
    #		}
    #	end
  end

  def notyetemailed
    @event = params[:event]
    @orchestras = Orchestra.mailForEvent(@event)
    respond_to do |format|
      format.js
      format.html
      format.json do
        render json: @orchestras.to_json(
          { member: { include: :member } }
        )
      end
    end
  end

  # GET /orchestras
  # GET /orchestras.json
  # sample  before_action :authenticate_user!, :except => [:some_action_without_auth]
  def notinvoiced
    year = params[:year]

    year = Time.zone.now.year if year.nil?

    @orchestras = policy_scope(Orchestra).notinvoiced(year).search(params[:search]).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)

    respond_to do |format|
      format.js
      format.html
      format.turbo_stream { render partial: "list" }
      format.json do
        render json: @orchestras.to_json(
          { member: { include: :member } }
        )
      end
    end
  end

  def magazine
    @orchestras = policy_scope(Orchestra).with_zero_balance
    @result = []

    @orchestras.each do |orchestra|
      csvrow = Orchestra.magazine_address_list_row

      if csvrow.nil?
        Rails.logger.warn("Magazine count is zero: #{orchestra.member.mglnr}")
      else
        @result << @csvrow
      end
    end
    filename = "magazine.orch.#{Time.zone.now.strftime('%m-%d-%Y')}.ods"

    renderOrchestraMagazineListOds("/tmp/#{filename}", @result)

    send_file("/tmp/#{filename}", filename: filename, type: "application/octet-stream")

    flash[:notice] = "Export complete!"
  end

  def nopayment
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id]) unless params[:regional_organization_id].nil?

    data = policy_scope(Orchestra).no_payment(params[:before], @regional_organization)

    @members = data[:members]
    @accounts = data[:accounts]

    respond_to do |format|
      format.html
      format.json { render json: @members }
      format.turbo_stream { render partial: "list", locals: { resources: @orchestras }  }
      format.csv { render csv: @members, style: :minimal, filename: "nopayment_#{Time.zone.now.year}" }
      format.ods do
        renderNoPayOds("/tmp/nopayment.ods", @accounts, @members)
        send_file("/tmp/nopayment.ods", filename: "orch_nopay_#{Time.zone.now.year}.ods",
                                        type: "application/octet-stream")
      end
    end
  end

  def gema
    currentYear = String(Time.zone.now.year)
    respond_to do |format|
      @orchestras = Orchestra.includes(:member, :report_sheets).where(
        "report_sheets.year = ? and members.mglnr < 20000 and orchestras.orch_type <>'K'", currentYear
      ).order("members.mglnr")

      format.ods do
        sheet = GemaSpreadsheet.new(@orchestras)
        sheet.render
        tmpfile = Tempfile.new("gema")
        # send_data(sheet.sheet.bytes, :filename => "gema.ods", :type => "application/octet-stream")
        sheet.sheet.write_to tmpfile
        send_file(tmpfile, filename: "gema.ods", type: "application/octet-stream")
      end

      format.csv { render csv: @orchestras, style: :gema, filename: "gema#{Time.zone.now.year}" }
      format.json { render json: @orchestras }
    end
  end

  def lorch
    @orchestras = policy_scope(Orchestra).includes(:member).where("orch_type='L'").order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)

    # authorize @orchestras

    respond_to do |format|
      format.html do
        redirect_to @orchestras[0] if @orchestras.length == 1
      end
      format.turbo_stream { render partial: "list", locals: { resources: @orchestras }  }
      format.json { render json: @orchestras }
    end
  end

  def pro_musica
    @age = 90
    year = Time.zone.now.year - @age

    Rails.logger.debug { "Orchestra age: #{@age} year: #{year}" }
    @orchestras = policy_scope(Orchestra).includes(:member).where(
      "YEAR(gruendung) <= ? and gruendung <> '0000-00-00' and gruendung IS NOT NULL ", year
    ).order("members.mglnr")
  end

  def index
    @orchestras = policy_scope(Orchestra).includes(:member).search(params[:search]).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)

    respond_to do |format|
      format.html do
        redirect_to @orchestras[0] if @orchestras.length == 1
      end
      # index.html.erb
      format.json { render json: @orchestras }
      format.turbo_stream { render partial: "list", locals: { resources: @orchestras }  }
    end
  end

  def noreport
    @orchestras = policy_scope(Orchestra)
    year = if params[:year].nil?
             Time.zone.now.year
    else
             params[:year]
    end

    Rails.logger.debug { "Year: #{params[:year]}" }

    @orchestras = @orchestras.no_report_sheet(year).order("members.mglnr").page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "list", locals: { resources: @orchestras }  }
      format.json { render json: @orchestras }
    end
  end

  # GET /orchestras/1
  # GET /orchestras/1.json
  def show
    @report_sheets = @orchestra.report_sheets

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @orchestra }
    end
  end

  # GET /orchestras/new
  # GET /orchestras/new.json
  def new

    authorize Orchestra, :create?
    @orchestra = Orchestra.new
    @orchestra.build_member
    @orchestra.member.country_code = ISO3166::Country["DE"].alpha2
    @orchestra.member.eintritt = Time.zone.now

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @orchestra }
    end
  end

  # GET /orchestras/1/edit
  def edit
    @orchestra = Orchestra.find(params[:id])

    authorize @orchestra
  end

  # POST /orchestras
  # POST /orchestras.json
  def create

    authorize Orchestra, :create?

    @orchestra = Orchestra.new(orchestra_params)
    respond_to do |format|
      if @orchestra.save
        format.html { redirect_to @orchestra, notice: t("orchestra.create_success") }
        format.json { render json: @orchestra, status: :created, location: @orchestra }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @orchestra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orchestras/1
  # PUT /orchestras/1.json
  def update
    @orchestra = Orchestra.find(params[:id])

    authorize(@orchestra)

    respond_to do |format|
      if @orchestra.update(orchestra_params)
        format.html do
          redirect_to @orchestra,
                      notice: t_update_success("orchestra")
        end
        format.json { head :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @orchestra.errors, status: :unprocessable_entity }
      end
    end
  end

  def rsi_login
    @orchestra = Orchestra.find(params[:id])

    cur_year = Time.zone.now.year
    @rsi = ReportSheetInput.for_orchestra_and_year(@orchestra, cur_year)

    return if @rsi.nil?

    session[:report_sheet_input_id] = @rsi.id
    session[:report_sheet_input_token] = @rsi.token
    redirect_to polymorphic_url([ :mgl, @rsi ], action: :step1)
  end

  def gen_rsi
    @orchestra = Orchestra.includes(:member).find(params[:id])

    if @orchestra.nil?
      logger.warn("Orchestra is nil!: #{params[:id]}")
      respond_to do |format|
        format.html { redirect_to orchestras_url, status: :unprocessable_entity, notice: t("orchestra.nil") }
      end
      return
    end

    unless @orchestra.report_sheet_required?
      logger.info("No report sheet required: #{@orchestra.member.mglnr}")
      respond_to do |format|
        format.html { redirect_to @orchestra, status: :unprocessable_entity, notice: t("report_sheet.no_rs_required") }
      end
      return
    end

    rs_year = Time.zone.now.year

    dateprefix = Time.zone.now.strftime "%Y%m%d%H%M%S_"
    BDZ_SETTINGS["meldebogen_url"]
    target = "#{INVOICE_CONFIG.archive_dir}/#{rs_year}/#{dateprefix}#{@orchestra.member.mglnr}_meldebogen_anschreiben.pdf"

    @rsi = ReportSheetInput.for_orchestra_and_year(@orchestra, rs_year)

    unless @rsi.nil?
      logger.info("RSI already exists: #{@orchestra.member.mglnr}")
      respond_to do |format|
        format.html do
          redirect_to @orchestra, status: :unprocessable_entity, notice: t("report_sheet_input.already_exists")
        end
      end
      return
    end

    @rsi = @orchestra.gen_rsi(rs_year)

    gen_anschreiben(@orchestra, @rsi)
    send_file(target, filename: target, type: "application/octet-stream")
  end

  # DELETE /orchestras/1
  # DELETE /orchestras/1.json
  def destroy
    @orchestra = Orchestra.find(params[:id])
    @orchestra.destroy

    respond_to do |format|
      format.html { redirect_to orchestras_url }
      format.json { head :ok }
    end
  end

  def invoice_preview
    year = Time.zone.now.year
    @invoice = @orchestra.gen_invoice(year)

    @invoice_hash = @invoice.to_hash[:invoice]

    respond_to do |format|
      format.turbo_stream { render template: "corika_invoices/invoices/preview" }
      format.html { render template: "corika_invoices/invoices/preview" }
      format.json { render json: @invoice }
    end
  end

  def nomail
    @orchestras = policy_scope(Orchestra).nomail
    respond_to do |format|
      format.html
    end
  end

  private

  def sort_column
    if Member.column_names.include?(params[:sort])
      "members.#{params[:sort]}"
    else
      Orchestra.column_names.include?(params[:sort]) ? params[:sort] : "members.mglnr"
    end
  end

  def renderNoPayOds(filename, accounts, members)
    RODF::Spreadsheet.file(filename) do |sheet|
      sheet.table "Nopayment" do
        members.each do |m|
          row do
            cell m.mglnr.to_s
            cell m.member_entity.orchName
            cell m.email
            cell accounts[m.id].round(2), type: :float
          end
        end
      end
    end
  end

  def orchestra_params
    params.require(:orchestra).permit(:orchName, :url, :gruendung, :orch_type, :bemerkung, :zweitanschrift, :name2,
                                      :kuendigungErfasst, :gema_kdnr, :gema_kdnr_new, :promusica, :publish_url, :publish_address, :ztg_override, member_attributes: Member.nested_params)
  end

  protected 
  def index_actions
    super.append(:notinvoiced, :noreport, :lorch, :nomail, :nopayment, :pro_musica)
  end

  private 
  def set_orchestra
    @orchestra = policy_scope(Orchestra).includes(:member).includes(:report_sheets).find(params[:id])
    authorize @orchestra
  end
end
