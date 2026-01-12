require "rodf"
class EventMealsController < AuthenticatedController

  before_action :set_event_meal, only: %i[ show edit update destroy ]

  # GET /event_meals
  # GET /event_meals.json
  def index
    year =BDZ_SETTINGS["config"]["festival_year"]
    @event_meals = policy_scope(EventMeal).where("festival_year = ?", year)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_meals }
      format.ods do
        prefix = Time.zone.now.strftime("%Y%m%d%H%M_")
        renderOds(@event_meals, "/tmp/event_meals.ods")
        send_file("/tmp/event_meals.ods", filename: "#{prefix}event_meals.ods", type: "application/octet-stream")
      end
    end
  end

  def update_hash(day, hash, e)
    mittag_seconds = 12 * 3600
    abend_seconds = 17 * 3600

    return if e.arrival_time.nil?

    if e.arrival_time.day < day
      hash[:mittag][:veg] += e.veg
      hash[:mittag][:tln] += e.tln
      hash[:abend][:veg] += e.veg
      hash[:abend][:tln] += e.tln
    end

    return unless e.arrival_time.day == day

    if e.arrival_time.seconds_since_midnight < mittag_seconds
      hash[:mittag][:veg] += e.veg
      hash[:mittag][:tln] += e.tln
    end

    return unless e.arrival_time.seconds_since_midnight < abend_seconds

    hash[:abend][:veg] += e.veg
    hash[:abend][:tln] += e.tln
  end

  # GET /event_meals/1
  # GET /event_meals/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_meal }
    end
  end

  # GET /event_meals/new
  # GET /event_meals/new.json
  def new
    @event_meal = EventMeal.new
    authorize @event_meal

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_meal }
    end
  end

  # GET /event_meals/1/edit
  def edit
  end

  # POST /event_meals
  # POST /event_meals.json
  def create
    @event_meal = EventMeal.new(event_meal_params)
    @event_meal.orderdate = Time.zone.now
    @event_meal.festival_year = BDZ_SETTINGS["config"]["festival_year"]

    respond_to do |format|
      if @event_meal.save
        format.html { redirect_to @event_meal, notice: "Event meal was successfully created." }
        format.json { render json: @event_meal, status: :created, location: @event_meal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event_meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /event_meals/1
  # PUT /event_meals/1.json
  def update

    respond_to do |format|
      if @event_meal.update(event_meal_params)
        format.html { redirect_to @event_meal, notice: "Event meal was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event_meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_meals/1
  # DELETE /event_meals/1.json
  def destroy
    @event_meal.destroy

    respond_to do |format|
      format.html { redirect_to event_meals_url }
      format.json { render json: { status: "ok", op: "delete", entityId: @event_meal.id } }
    end
  end

  def arrival_overview
    @event_meals = policy_scope(EventMeal).order(:arrival_time)

    @counts = {}
    @counts[:do] = { mittag: { tln: 0, veg: 0 }, abend: { tln: 0, veg: 0 } }
    @counts[:fr] = { mittag: { tln: 0, veg: 0 }, abend: { tln: 0, veg: 0 } }
    @counts[:sa] = { mittag: { tln: 0, veg: 0 }, abend: { tln: 0, veg: 0 } }

    @event_meals.each do |e|
      update_hash(10, @counts[:do], e)
      update_hash(11, @counts[:fr], e)
      update_hash(12, @counts[:sa], e)
    end
  end

  def renderOds(meals, filename)
    RODF::Spreadsheet.file(filename) do
      table "Essensmeldungen" do
        row do
          cell I18n.t("common.number")
          cell I18n.t("festival_application.orch_name")
          cell I18n.t("event_meal.arrival_time")
          cell ""
          cell I18n.t("event_meal.meals")
          cell I18n.t("event_meal.veg")
        end

        meals.each do |meal|
          row do
            cell meal.participant_id
            if meal.festival_application.nil?
              cell "---"
            else
              cell meal.festival_application.orch_name
            end
            if meal.arrival_time.nil?
              cell "---"
              cell "---"
            else
              cell meal.arrival_time.strftime("%d.%m.%Y")
              cell meal.arrival_time.strftime("%H:%M")
            end
            cell meal.tln, type: :float
            cell meal.veg, type: :float
          end
        end
      end
    end
  end

  protected 
  def index_actions
    super.append(:arrival_overview)
  end

  private 
  def event_meal_params
    params.require(:event_meal).permit(:participant_id, :name, :email, :arrival_time, :tln, :veg)
  end

  def set_event_meal
    @event_meal = policy_scope(EventMeal).find(params[:id])
    authorize @event_meal
  end

end
