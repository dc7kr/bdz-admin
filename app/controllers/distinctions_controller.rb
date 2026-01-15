class DistinctionsController < AuthenticatedController
  # for table sort by column click
  helper_method :sort_column, :sort_direction

  before_action :set_distinction, only: %i[show edit update destroy invoice_preview]

  include ApplicationHelper

  def gen_invoice
    distinction = policy_scope(Distinction).find(params[:id])
    authorize distinction

    orchestra = distinction.orchestra

    if distinction.has_booking?
      redirect_to orchestra_distinction_path(orchestra, distinction),
                  flash: { error: t("distinction.invoice_already_exists") }
      return
    end

    # Start background job 
    GenerateDistinctionInvoiceJob.perform_later(distinction.id, current_user.id)
    
    respond_to do |format|
      format.html do
        redirect_to orchestra_distinction_path(orchestra, distinction), notice: t("distinction.invoice_generation_triggered")
      end
    end
  end

  # GET /distinctions
  # GET /distinctions.json
  def index
    @distinctions = policy_scope(Distinction).where(orchestra_id: params[:orchestra_id]).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)

    @orchestra = Orchestra.find(params[:orchestra_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @distinctions }
    end
  end

  # GET /distinctions/1
  # GET /distinctions/1.json
  def show
    @orchestra = policy_scope(Orchestra).find(params[:orchestra_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @distinction }
    end
  end

  def invoice_preview

    if not @distinction.invoice_id.nil?
      @invoice = CorikaInvoices::Invoice.find(@distinction.invoice_id)
    else
      @invoice = @distinction.gen_invoice
    end

    @invoice_hash = @invoice.to_hash[:invoice]


    respond_to do |format|
      format.turbo_stream { render template: "corika_invoices/invoices/preview" }
      format.html { render template: "corika_invoices/invoices/preview" }
      format.json { render json: @invoice }
    end
  end

  # GET /distinctions/new
  # GET /distinctions/new.json
  def new
    @orchestra = Orchestra.find(params[:orchestra_id])
    @distinction = Distinction.new(orchestra_id: @orchestra.id, dist_date: Time.zone.now)
    authorize @distinction

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @distinction }
    end
  end

  # GET /distinctions/1/edit
  def edit
    @distinction = Distinction.find(params[:id])
    @orchestra = Orchestra.find(params[:orchestra_id])
  end

  # POST /distinctions
  # POST /distinctions.json
  def create
    @distinction = Distinction.new(distinction_params)
    @orchestra = Orchestra.find(params[:orchestra_id])
    @distinction.orchestra = @orchestra
    authorize @distinction

    respond_to do |format|
      if @distinction.save
        format.html do
          redirect_to orchestra_distinction_path(params[:orchestra_id], @distinction),
                      notice: "Distinction was successfully created."
        end
        format.json { render json: @distinction, status: :created, location: @distinction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @distinction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /distinctions/1
  # PUT /distinctions/1.json
  def update
    @orchestra = Orchestra.find(params[:orchestra_id])
    @distinction = Distinction.find(params[:id])

    respond_to do |format|
      if @distinction.update(distinction_params)
        format.html do
          redirect_to orchestra_distinction_path(@orchestra, @distinction),
                      notice: t_update_success("distinction")
        end

        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @distinction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distinctions/1
  # DELETE /distinctions/1.json
  def destroy
    @orchestra = Orchestra.find(params[:orchestra_id])
    @distinction = Distinction.find(params[:id])
    @distinction.destroy

    respond_to do |format|
      format.html { redirect_to orchestra_distinctions_url(@orchestra) }
      format.json { head :no_content }
    end
  end

  private

  def sort_column
    Orchestra.column_names.include?(params[:sort]) ? params[:sort] : "distinctions.dist_date"
  end

  def set_distinction
    @distinction = policy_scope(Distinction).find(params[:id])
    authorize @distinction
  end

  def distinction_params
    params.require(:distinction).permit(:dist_date, :certificates, :honorletters, :medals, :gold_needles,
                                        :silver_needles, :national_needles, :porto)
  end
end
