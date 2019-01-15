class Public::EventMealsController < Public::ApplicationController
  # GET /event_meals
  # GET /event_meals.json
  def index
    @event_meals = EventMeal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_meals }
    end
  end

  # GET /event_meals/1
  # GET /event_meals/1.json
  def show
    @event_meal = EventMeal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_meal }
    end
  end

  # GET /event_meals/new
  # GET /event_meals/new.json
  def new
    @event_meal = EventMeal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_meal }
    end
  end

  # GET /event_meals/1/edit
  def edit
    @event_meal = EventMeal.find(params[:id])
  end

  # POST /event_meals
  # POST /event_meals.json
  def create
    @event_meal = EventMeal.new(event_meal_params)

    respond_to do |format|
      if @event_meal.save
        format.html { redirect_to @event_meal, notice: 'Event meal was successfully created.' }
        format.json { render json: @event_meal, status: :created, location: @event_meal }
      else
        format.html { render action: "new" }
        format.json { render json: @event_meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /event_meals/1
  # PUT /event_meals/1.json
  def update
    @event_meal = EventMeal.find(params[:id])

    respond_to do |format|
      if @event_meal.update_attributes(params[:event_meal])
        format.html { redirect_to @event_meal, notice: 'Event meal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_meals/1
  # DELETE /event_meals/1.json
  def destroy
    @event_meal = EventMeal.find(params[:id])
    @event_meal.destroy

    respond_to do |format|
      format.html { redirect_to event_meals_url }
      format.json { head :no_content }
    end
  end

  def order_form 
   @event_meal = EventMeal.new 
  end

  def order_success
    @event_meal = EventMeal.new(event_meal_params)

    @event_meal.orderdate = Time.now

    timestr = params[:event_meal][:arrival_time]

    if not timestr.empty? then 
      begin
      arrival = Time.parse(timestr)
        @event_meal.arrival_time = arrival
      rescue ArgumentError
        Rails.logger.error("Invalid arrival time: #{arrival}")
      end

    end

    respond_to do |format|
      if @event_meal.save

        Rails.logger.debug("#{@event_meal.participant_id} #{timestr}")
        EventMealsMailer.notify(@event_meal,"essensmeldung@bdz-online.de").deliver
        format.html 
        format.json { render json: @event_meal, status: :created, location: @event_meal }
      else
        format.html { render action: "order_form" }
        format.json { render json: @event_meal.errors, status: :unprocessable_entity }
      end
    end
  end

  def event_meal_params
    params.require(:event_meal).permit( :participant_id, :name, :email, :arrival_time, :tln, :veg)
  end
end
