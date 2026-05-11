require "rodf"
class FestivalApplicationsController < AuthenticatedController
  include CountryHelper

  include ApplicationHelper

  helper_method :sort_column, :sort_direction

  before_action :set_festival_application, only: %i[ show edit update destroy fee_invoice_preview fee_invoice ticket_invoice_preview ticket_invoice gen_ticket_invoice finalize gen_participant_sheet storno ]

  layout :choose_layout
  # GET /festival_applications
  # GET /festival_applications.json

  def calc_sums(year = BDZ_SETTINGS["config"]["festival_year"], visitor_type = nil)
    query = policy_scope(FestivalApplication).where(year: year, permission: 1).select("SUM(num_players) as players, SUM(tickets) as tickets, SUM(tickets_red) as tickets_red, SUM(bdz_tickets) as bdz_tickets, SUM(bdz_tickets_red) as bdz_tickets_red")

    if visitor_type.present?
      query= query.where(visitor_type: visitor_type)
    end

    result = query.first

    sums = {}
    sums[:tickets] = nil_safe_value result[:tickets]
    sums[:tickets_red] = nil_safe_value result[:tickets_red]
    sums[:bdz_tickets] = nil_safe_value result[:bdz_tickets]
    sums[:bdz_tickets_red] = nil_safe_value result[:bdz_tickets_red]
    sums[:players] = nil_safe_value result[:players]

    sums[:no_ticket] =
      sums[:players] - sums[:tickets] - sums[:tickets_red] - sums[:bdz_tickets] - sums[:bdz_tickets_red]

    sums
  end

  def index
    @festival_applications = policy_scope(FestivalApplication).current_festival.order("#{sort_column} #{sort_direction}").search(params[:search]).page(params[:page]).per(20)

    set_year(params)

    @sums = calc_sums(@year)

    respond_to do |format|
      format.js
      format.html # index.html.erb

      format.turbo_stream do
        render partial: "list", locals: { resources: @festival_applications }
      end

      format.json { render json: @festival_applications }
    end
  end

  def permitted
    set_year(params)

    @sums = calc_sums(@year)

    now = Time.zone.now
    currDate = now.strftime("%d.%m.%Y")

    if params["year"].nil?
      @sum_players = 42  # FestivalApplication.current_festival.sum(:num_players)
        @festival_applications = policy_scope(FestivalApplication).current_festival.permitted.order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    else
        @sum_players = policy_scope(FestivalApplication).where(year: params["year"]).sum(:num_players)
        @festival_applications = policy_scope(FestivalApplication).where(permission: true, year: params["year"]).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    end


    respond_to do |format|
      format.js

      format.html do
        render
      end

      format.turbo_stream do
        render partial: "list", locals: { resources: @festival_applications }
      end


      format.json do
        render json: @festival_applications
      end

      format.pdf do
        pdf = FestivalApplicationsPdf.new(@festival_applications, view_context)
        send_data pdf.render, filename: "festival_applications_#{currDate}.pdf", type: "application/pdf",
                              disposition: "inline"
      end

      format.ods do
        @festival_applications = policy_scope(FestivalApplication).current_festival.where(permission: true).order("#{sort_column} #{sort_direction}")
        @sum_players = policy_scope(FestivalApplication).where(permission: true).sum(:num_players)
        sheet = FestivalApplicationsSpreadsheet.new(@festival_applications)
        sheet.render

        send_data(sheet.bytes,   filename: "festival_permissions_#{Time.zone.now.year}.ods", type: "application/octet-stream")
      end
    end
  end

  def no_meals
    @festival_applications = policy_scope(FestivalApplication).current_festival.permitted.no_meals.page(params[:page]).per(20)

    Rails.logger.debug(@festival_applications.count)

    respond_to do |format|
      format.html # index.html.erb

      format.turbo_stream do
        render partial: "list", locals: { resources: @festival_applications }
      end
    end
  end


  def no_tickets
    authorize :festival_application, :no_tickets?
    set_year(params)

    @sums = calc_sums(@year)

    now = Time.zone.now
    currDate = now.strftime("%d.%m.%Y")

    if params["year"].nil?
        @festival_applications = policy_scope(FestivalApplication).current_festival
    else
        @festival_applications = policy_scope(FestivalApplication).where(permission: true, year: params["year"]).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    end

    @festival_applications = @festival_applications.where(permission: true).where("(tickets IS NULL or tickets = 0) and (tickets_red IS NULL or tickets_red =0)" ).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)

    respond_to do |format|
      format.js
      format.html # index.html.erb

      format.turbo_stream do
        render partial: "list", locals: { resources: @festival_applications }
      end

      format.json { render json: @festival_applications }
    end
  end

  def list

    @festival_applications = policy_scope(FestivalApplication).current_festival.order(%i[group_type orch_name])
    now = Time.zone.now
    currDate = now.strftime("%d.%m.%Y")

    respond_to do |format|
      format.html { render }
      format.pdf do
        pdf = FestivalApplicationsPdf.new(@festival_applications, view_context)
        send_data pdf.render, filename: "festival_applications_#{currDate}.pdf", type: "application/pdf",
                              disposition: "inline"
      end

      format.ods do
         sheet = FestivalApplicationsSpreadsheet.new(@festival_applications)
        sheet.render

        send_data(sheet.bytes,   filename: "festival_applications_#{currDate}.pdf", type: "application/pdf",
                              disposition: "inline")
      end
    end
  end

  def grp_list
    set_year(params)

    @visitor_type =  group_list_params[:visitor_type]
    file_format = group_list_params[:file_format]

    @festival_applications = policy_scope(FestivalApplication).current_festival.where(visitor_type: @visitor_type)
        .order(%i[group_type orch_name])

    @sums = calc_sums(@year, @visitor_type)

    now = Time.zone.now
    curr_date = now.strftime("%d.%m.%Y")

    type_str = t("festival_application.visitor_types.#{@visitor_type}").parameterize

    base_filename =  "#{type_str}_#{curr_date}"

    Rails.logger.info("Rendering list: #{params[:visitor_type]} #{params[:file_format]}")
    request.format = file_format

    respond_to do |format|
      format.pdf do
        Rails.logger.info("PDF")
        pdf = FestivalApplicationsPdf.new(@festival_applications, view_context)
        #send_data(pdf.render, filename: "#{base_filename}.pdf", type: "application/pdf", disposition: "inline")
        send_data(pdf.render, filename: "#{base_filename}.pdf", type: "application/octet-stream")
      end

      format.ods do
        Rails.logger.info("ODS")
        sheet = FestivalApplicationsSpreadsheet.new(@festival_applications)
        sheet.render
        send_data(sheet.bytes, filename: "#{base_filename}.ods", type: "application/octet-stream")
      end

      format.html do
        Rails.logger.info("HTML")
        render
      end
    end
  end

  # GET /festival_applications/1
  # GET /festival_applications/1.json
  def show

    @contact_person = @festival_application.contact_person

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @festival_application }
    end
  end

  def fee_invoice_preview
    @invoice = @festival_application.get_fee_invoice

    @invoice_hash = @invoice.to_hash[:invoice]

    respond_to do |format|
      format.turbo_stream { render template: "corika_invoices/invoices/preview" }
      format.html { render template: "corika_invoices/invoices/preview" }
      format.json { render json: @invoice }
    end
  end

  def ticket_invoice_preview
    @invoice = @festival_application.get_ticket_invoice

    @invoice_hash = @invoice.to_hash[:invoice]

    respond_to do |format|
      format.turbo_stream { render template: "corika_invoices/invoices/preview" }
      format.html { render template: "corika_invoices/invoices/preview" }
      format.json { render json: @invoice }
    end
  end

  def gen_ticket_invoice
    @invoice = @festival_application.get_ticket_invoice
    @invoice.gen_pdf

    @festival_application.ticket_invoice_id = @invoice.id
    @festival_application.save

    respond_to do |format|
          format.html { redirect_to @festival_application, notice: t("festival_application.ticket_invoice_success") }
    end
  end

  def storno
    if not @festival_application.ticket_invoice_id.present?
      respond_to do |format|
        format.html { render :show, status: :unprocessable_entity }
        return
      end
    else
      invoice = CorikaInvoices::Invoice.find(@festival_application.ticket_invoice_id)

      storno_invoice = invoice.storno
      storno_invoice.gen_pdf
      storno_invoice.save
      storno_invoice.pdf_filename


      @festival_application.ticket_invoice_id = nil
      @festival_application.storno_invoice_id = storno_invoice.id
      @festival_application.save

      AdminNotifier.new_storno(invoice.id, storno_invoice.id).deliver

      respond_to do |format|
        format.html { redirect_to @festival_application, notice: t("festival_application.storno_success") }
      end
    end
  end


  def finalize
  end

  # GET /festival_applications/new
  # GET /festival_applications/new.json
  def new
    @festival_application = FestivalApplication.new
    @festival_application.contact_person = ContactPerson.new

    authorize @festival_application

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @festival_application }
    end
  end

  # GET /festival_applications/1/edit
  def edit
  end

  # POST /festival_applications
  # POST /festival_applications.json
  def create
    @festival_application = policy_scope(FestivalApplication).new(festival_application_params)

    Rails.logger.debug("Festival application contact person")
    contact_person = ContactPerson.new(contact_person_params)
    @festival_application.contact_person = contact_person
    @festival_application.token = SecureRandom.uuid

    if @festival_application.year.nil?
        @festival_application.year = BDZ_SETTINGS["config"]["festival_year"]
    end

    if @festival_application.contact_person.save
      respond_to do |format|
        if @festival_application.save
          format.html { redirect_to @festival_application, notice: t("festival_application.create_success") }
          format.json { render json: @festival_application, status: :created, location: @festival_application }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @festival_application.errors, status: :unprocessable_entity }
        end
      end
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @festival_application.errors, status: :unprocessable_entity }
    end
  end

  # PUT /festival_applications/1
  # PUT /festival_applications/1.json
  def update
    @festival_application.contact_person.update(contact_person_params)

    respond_to do |format|
      if @festival_application.update(festival_application_params)
        format.html do
          redirect_to @festival_application,
                      notice: t_update_success("festival_application")
        end
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @festival_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /festival_applications/1
  # DELETE /festival_applications/1.json

  def destroy
    @festival_application.destroy

    respond_to do |format|
      format.html { redirect_to festival_applications_url }
      format.json { head :no_content }
    end
  end



  def participant_overview
    date_prefix = Time.zone.now.strftime("%Y%m%d%H%M%S_")

    @participants = if params[:alpha]
                      policy_scope(FestivalApplication).current_festival.permitted.order(:orch_name)
    else
                      policy_scope(FestivalApplication).current_festival.permitted.order(:id)
    end

    respond_to do |format|
      format.pdf do
        pdf = ParticipantOverviewPdf.new(@participants, view_context)
        send_data pdf.render, filename: "#{date_prefix}participant_overview.pdf", type: "application/pdf",
                              disposition: "inline"
      end

      format.ods do
        ods = ParticipantOverviewSpreadsheet.new(@participants, view_context)
        ods.render
        send_data ods.bytes, filename: "#{date_prefix}participant_overview.ods", type: "application/octet-stream"
      end
    end
  end

  def fee_invoice
    if @festival_application.fee_invoice_id.nil?
        respond_to do |format|
            format.html { render :show, status: :unprocessable_entity }
        end
        return
    end

    invoice = @festival_application.get_fee_invoice

    invoice_file = invoice.gen_pdf

    send_file(invoice_file.full_path, filename: invoice_file.orig_filename, type: "application/octet-stream")
  end

  def ticket_invoice
    if @festival_application.ticket_invoice_id.nil?
        respond_to do |format|
            format.html { render :show, status: :unprocessable_entity }
        end
        return
    end

    invoice = @festival_application.get_ticket_invoice
    invoice_file = invoice.gen_pdf

    send_file(invoice_file.full_path, filename: invoice_file.orig_filename, type: "application/octet-stream")
  end

  def datasheets
    applications = policy_scope(FestivalApplication).current_festival.permitted.order(:id)

    date_prefix = Time.zone.now.strftime("%Y%m%d%H%M%S_")

    combined_file = CombinePDF.new

    applications.each do |appl|
      pdf = ParticipantSheetPdf.new(appl, view_context)
      combined_file << CombinePDF.parse(pdf.render)
    end

    send_data combined_file.to_pdf, filename: "#{date_prefix}datasheets.pdf", type: "application/pdf"
  end

  def gen_participant_sheets
    @appl = policy_scope(FestivalApplication).order(:id)

    @appl.each do |a|
      pdf = ParticipantSheetPdf.new(a, view_context)

      pdf.render_file(BDZ_SETTINGS["invoice_workdir"] + "/participant_sheet_#{a.id}.pdf")
    end
  end

  def gen_participant_sheet
    pdf = ParticipantSheetPdf.new(@festival_application, view_context)
    send_data pdf.render, filename: "participant_sheet_#{@festival_application.id}.pdf", type: "application/pdf", disposition: "inline"
  end

  def open_issues
    @festival_applications = policy_scope(FestivalApplication).current_festival.order(:id)
  end


  def stage_plans
    @festival_applications = policy_scope(FestivalApplication).current_festival.where(permission: 1).order(:id)
    filename = "stage_plans.zip"
    temp_file = Tempfile.new(filename)

    Zip::OutputStream.open(temp_file.path) do |zos|
      @festival_applications.each do |fa|
        plan = fa.stage_plan

        next if not plan.attached?
        zos.put_next_entry("#{fa.id}_#{plan.filename.to_s}")
        zos.print plan.download
      end
    end

    send_file temp_file.path, type: 'application/zip', disposition: 'attachment', filename: filename
  ensure
    temp_file.close
  end

  def sort_column
    FestivalApplication.column_names.include?(params[:sort]) ? params[:sort] : "id"
    # group_type [:group_type,:orch_name])
  end

  private

  def group_list_params
    params.permit(:visitor_type, :file_format)
  end

  def festival_application_params
    params.require(:festival_application).permit(
      :group_type,
      :visitor_type,
      :country_code,
      :conductor,
      :special_cast,
      :orch_name,
      :equipment,
      :num_players,
      :contact_phone,
      :permission,
      :bdz_tickets,
      :bdz_tickets_red,
      :tickets,
      :tickets_red,
      :soloist_tickets,
      :amount,
      :stage_time,
      :festival_concert_id,
      :outdoor_concert_id,
      :rehearsal_time,
      :payment_status,
      :comment,
      :stage_plan,
      :player_list,
      :stage_timeslot,
      :program_item
    )
  end

  protected
  def index_actions
    super.append(:permitted, :open_issues, :participant_overview, :list, :grp_list, :no_tickets, :no_meals, :stage_plans, :datasheets )

  end

  private
    def set_year(params)
      if params[:year].nil?
    @year = BDZ_SETTINGS["config"]["festival_year"]
      else
    @year = params["year"]
      end
    end

    def set_festival_application
      @festival_application = policy_scope(FestivalApplication).find_by token: params[:token]
      authorize @festival_application
    end

    def contact_person_params
      my_params = params.require(:festival_application).permit(contact_person: ContactPerson.nested_params)
      Rails.logger.debug { "My params: #{my_params}" }
      my_params[:contact_person]
    end

end
