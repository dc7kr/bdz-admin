class FestivalExhibitorsController < AuthenticatedController
  before_action :set_festival_exhibitor, only: %i[ show edit update destroy invoice_preview gen_invoice ]

  helper :downloads

  # GET /festival_exhibitors or /festival_exhibitors.json
  def index
    @festival_exhibitors = policy_scope(FestivalExhibitor).all
  end

  # GET /festival_exhibitors/1 or /festival_exhibitors/1.json
  def show
  end

  # GET /festival_exhibitors/new
  def new
    @festival_exhibitor = FestivalExhibitor.new
    @festival_exhibitor.contact = Contact.new
    @festival_exhibitor.contact.country_code = "DE"
    authorize @festival_exhibitor
  end

  # GET /festival_exhibitors/1/edit
  def edit
  end

  # POST /festival_exhibitors or /festival_exhibitors.json
  def create
    @festival_exhibitor = FestivalExhibitor.new(festival_exhibitor_params)
    @festival_exhibitor.year = BDZ_SETTINGS["config"]["festival_year"]
    authorize @festival_exhibitor

    respond_to do |format|
      if @festival_exhibitor.save
        format.html { redirect_to @festival_exhibitor, notice: "Festival exhibitor was successfully created." }
        format.json { render :show, status: :created, location: @festival_exhibitor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @festival_exhibitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /festival_exhibitors/1 or /festival_exhibitors/1.json
  def update
    respond_to do |format|
      if @festival_exhibitor.update(festival_exhibitor_params)
        format.html { redirect_to @festival_exhibitor, notice: "Festival exhibitor was successfully updated." }
        format.json { render :show, status: :ok, location: @festival_exhibitor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @festival_exhibitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /festival_exhibitors/1 or /festival_exhibitors/1.json
  def destroy
    @festival_exhibitor.destroy!

    respond_to do |format|
      format.html { redirect_to festival_exhibitors_path, status: :see_other, notice: "Festival exhibitor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def gen_invoice

    # Start background job
    GenerateExhibitorInvoiceJob.perform_later(@festival_exhibitor.id, current_user.id)

    respond_to do |format|
      format.html do
        redirect_to festival_exhibitor_path(@festival_exhibitor), notice: t("festival_exhibitor.invoice_generation_triggered")
      end
    end
  end

  def invoice_preview
    @invoice = @festival_exhibitor.gen_invoice

    @invoice_hash = @invoice.to_hash[:invoice]

    respond_to do |format|
      format.turbo_stream { render template: "corika_invoices/invoices/preview" }
      format.html { render template: "corika_invoices/invoices/preview" }
      format.yaml {
        filename = "#{@invoice.full_number}.yml"
        send_data @invoice.to_yaml, type: "text/yaml", disposition: 'attachment', filename: filename
      }
      format.json { render json: @invoice }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_festival_exhibitor
      @festival_exhibitor = FestivalExhibitor.find(params[:id])
      authorize @festival_exhibitor
    end

    # Only allow a list of trusted parameters through.
    def festival_exhibitor_params
      params.require(:festival_exhibitor).permit(:year, :special_tariff, :item_text, :special_amount, :tariff, :rollups, :advert_type, :extra_tables, contact_attributes: Contact.nested_attributes)
    end
end
