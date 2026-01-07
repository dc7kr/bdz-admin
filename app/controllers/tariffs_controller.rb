class TariffsController < AuthenticatedController
  before_action :set_tariff, only: %i[ show edit update destroy ]

  # GET /tariffs
  # GET /tariffs.json
  def index
    @tariffs = policy_scope(Tariff).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tariffs }
    end
  end

  # GET /tariffs/1
  # GET /tariffs/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tariff }
    end
  end

  # GET /tariffs/new
  # GET /tariffs/new.json
  def new
    @tariff = Tariff.new
    authorize @tariff, :create?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tariff }
    end
  end

  # GET /tariffs/1/edit
  def edit
  end

  # POST /tariffs
  # POST /tariffs.json
  def create
    @tariff = Tariff.new(tariff_params)

    respond_to do |format|
      if @tariff.save
        format.html { redirect_to @tariff, notice: "Tariff was successfully created." }
        format.json { render json: @tariff, status: :created, location: @tariff }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tariff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tariffs/1
  # PUT /tariffs/1.json
  def update

    respond_to do |format|
      if @tariff.update(tariff_params)
        format.html { redirect_to @tariff, notice: "Tariff was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tariff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tariffs/1
  # DELETE /tariffs/1.json
  def destroy
    @tariff.destroy

    respond_to do |format|
      format.html { redirect_to tariffs_url }
      format.json { head :no_content }
    end
  end

  private
  def set_tariff
    @tariff = policy_scope(Tariff).find(params[:id])
    authorize @tariff
  end
  def tariff_params
    params.require(:tariff).permit(:tariff_type, :description, :amount, :tag)
  end
end
