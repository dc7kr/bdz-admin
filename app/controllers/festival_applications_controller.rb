require "rodf"
class FestivalApplicationsController < AuthenticatedController
  include CountryHelper

  include ApplicationHelper

  helper_method :sort_column, :sort_direction

  before_action :set_festival_application, only: %i[ show edit update destroy fee_invoice_preview fee_invoice ticket_invoice_preview ticket_invoice finalize gen_participant_sheet ]

  layout :choose_layout
  # GET /festival_applications
  # GET /festival_applications.json

  def calc_sums(year = BDZ_SETTINGS["config"]["festival_year"])
    result = policy_scope(FestivalApplication).where(year: year).select("SUM(num_players) as players, SUM(tickets) as tickets, SUM(tickets_red) as tickets_red, SUM(bdz_tickets) as bdz_tickets, SUM(bdz_tickets_red) as bdz_tickets_red").first

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
        @festival_applications = policy_scope(FestivalApplication).current_festival.where(permission: true).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    else
        @sum_players = policy_scope(FestivalApplication).where(year: params["year"]).sum(:num_players)
        @festival_applications = policy_scope(FestivalApplication).where(permission: true, year: params["year"]).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    end


    respond_to do |format|
      format.js

      format.html do
        render :index
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
        renderApplicationOds(@festival_applications, "/tmp/festival_applications.ods")
        send_file("/tmp/festival_applications.ods",
                  filename: "festival_permissions_#{Time.zone.now.year}.ods", type: "application/octet-stream")
      end
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
        renderApplicationOds(@festival_applications, "/tmp/festival_applications.ods")
        send_file("/tmp/festival_applications.ods",
                  filename: "festival_applications_#{Time.zone.now.year}.ods", type: "application/octet-stream")
      end
    end
  end

  def grp_list
    @festival_applications = policy_scope(FestivalApplication).current_fetsival.where(visitor_type: params[:visitor_type]).order(%i[group_type
                                                                                                                      orch_name])

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
        renderApplicationOds(@festival_applications, "/tmp/festival_applications.ods")
        send_file("/tmp/festival_applications.ods",
                  filename: "festival_applications_#{Time.zone.now.year}.ods", type: "application/octet-stream")
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

  def renderApplicationOds(applications, filename)
    RODF::Spreadsheet.file(filename) do
      table "Festival Anmeldungen" do
        row do
          cell I18n.t("common.number")
          cell I18n.t("festival_application.group_type")
          cell I18n.t("festival_application.orch_name")
          cell I18n.t("festival_application.country_id")
          cell I18n.t("festival_application.num_players")
          cell I18n.t("contact_person.salutation")
          cell I18n.t("contact_person.first_name")
          cell I18n.t("contact_person.last_name")
          cell I18n.t("contact_person.street")
          cell I18n.t("contact_person.zip")
          cell I18n.t("contact_person.city")
          cell I18n.t("contact_person.country_code")
          cell I18n.t("contact_person.email")
          cell I18n.t("festival_application.special_cast")
          cell I18n.t("festival_application.equipment")
          cell I18n.t("festival_piece.composer")
          cell I18n.t("festival_piece.title")
          cell I18n.t("festival_piece.duration")
          cell I18n.t("festival_piece.composer")
          cell I18n.t("festival_piece.title")
          cell I18n.t("festival_piece.duration")
          cell I18n.t("festival_piece.composer")
          cell I18n.t("festival_piece.title")
          cell I18n.t("festival_piece.duration")
          cell I18n.t("festival_piece.composer")
          cell I18n.t("festival_piece.title")
          cell I18n.t("festival_piece.duration")
          cell I18n.t("festival_piece.composer")
          cell I18n.t("festival_piece.title")
          cell I18n.t("festival_piece.duration")
        end

        applications.each do |app|
          grp_locale = if app.country_code == ISO3166::Country["DE"].alpha2
                         :de
          else
                         :en
          end

          row do
            cell app.id
            cell I18n.t("festival_application.group_types.#{app.group_type}")
            cell app.orch_name
            cell app.t_country
            cell app.num_players
            cell I18n.t("common.salutations.#{app.contact_person.salutation}", locale: grp_locale)
            cell app.contact_person.first_name
            cell app.contact_person.last_name
            cell app.contact_person.street
            cell app.contact_person.zip
            cell app.contact_person.city
            cell app.contact_person.t_country
            cell app.contact_person.email

            cell app.special_cast
            cell app.equipment

            app.festival_pieces.each do |p|
              cell p.composer
              cell p.title
              cell p.duration
            end
          end
        end
      end
    end
  end

  def participant_overview
    datePrefix = Time.zone.now.strftime("%Y%m%d%H%M%S_")

    @participants = if params[:alpha]
                      policy_scope(FestivalApplication).where("permission = 1").order(:orch_name)
    else
                      policy_scope(FestivalApplication).where("permission = 1").order(:id)
    end

    pdf = ParticipantOverviewPdf.new(@participants, view_context)
    send_data pdf.render, filename: "participant_overview_#{datePrefix}.pdf", type: "application/pdf",
                          disposition: "inline"
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
    if @festival_application.fee_invoice_id.nil?
        respond_to do |format|
            format.html { render :show, status: :unprocessable_entity }
        end
        return
    end

    invoice = @festival_application.get_ticket_invoice
    invoice_file = invoice.gen_pdf

    send_file(invoice_file.full_path, filename: invoice_file.orig_filename, type: "application/octet-stream")
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

  def sort_column
    FestivalApplication.column_names.include?(params[:sort]) ? params[:sort] : "id"
    # group_type [:group_type,:orch_name])
  end

  private

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
      :rehearsal_time,
      :payment_status,
      :comment
    )
  end

  protected 
  def index_actions
    super.append(:permitted, :open_issues)

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
