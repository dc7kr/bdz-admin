module Ef
  class EventMealsController < Ef::ApplicationController
    helper ApplicationHelper
    helper ButtonHelper
    
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
      @festival_application = FestivalApplication.find_by_token(params[:festival_application_token])
      @event_meal.arrival_time=DateTime.new(2026,5,14,6,0,Rational(2,24))
      @event_meal.participant_id = @festival_application.id
      @event_meal.tln = @festival_application.tickets_total


      respond_to do |format|
        format.html # new.html.erb
        format.turbo_stream 
        format.json { render json: @event_meal }
      end
    end

    # GET /event_meals/1/edit
    def edit
      @festival_application = FestivalApplication.find_by token: params[:festival_application_token]

      @event_meal = EventMeal.find(params[:id])
    end

    # POST /festival_pieces
    # POST /festival_pieces.json
    def create

      cancel = params[:cancel].present?

      @festival_application = FestivalApplication.find_by token: params[:festival_application_token]

      if cancel 
        respond_to do |format|
          format.turbo_stream 
          format.html {
            redirect_to ef_festival_application(@festival_application),
                        notice: t("event_meal.create_success")
          }
        end
        return
      end

      @event_meal = EventMeal.new(event_meal_params)
      @event_meal.participant_id = @festival_application.id
      @event_meal.email = @festival_application.contact_person.email
      @event_meal.name= @festival_application.contact_person.fullname
      @event_meal.orderdate = Time.zone.now

      respond_to do |format|
        if @event_meal.save
          format.turbo_stream 
          format.html {
            redirect_to ef_festival_application(@festival_application),
                        notice: t("event_meal.create_success")
          }
        else
          format.turbo_stream { render :new, status: :unprocessable_entity  }
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end



    # PUT /event_meals/1
    # PUT /event_meals/1.json
    def update
      @festival_application = FestivalApplication.find_by token: params[:festival_application_token]
      @event_meal = @festival_application.event_meal

      respond_to do |format|
        if @event_meal.update(event_meal_params)
          format.html { redirect_to @event_meal, notice: "Event meal was successfully updated." }
          format.turbo_stream
          format.json { head :no_content }
        else
          Rails.logger.info("Error saving event meal")
          Rails.logger.info(@event_meal.errors)
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render :edit, status: :unprocessable_entity  }
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

      @event_meal.orderdate = Time.zone.now

      timestr = params[:event_meal][:arrival_time]

      unless timestr.empty?
        begin
          arrival = Time.zone.parse(timestr)
          @event_meal.arrival_time = arrival
        rescue ArgumentError
          Rails.logger.error("Invalid arrival time: #{arrival}")
        end

      end

      respond_to do |format|
        if @event_meal.save

          Rails.logger.debug { "#{@event_meal.participant_id} #{timestr}" }
          EventMealsMailer.notify(@event_meal, "essensmeldung@bdz-online.de").deliver
          format.html
          format.json { render json: @event_meal, status: :created, location: @event_meal }
        else
          format.html { render action: "order_form" }
          format.json { render json: @event_meal.errors, status: :unprocessable_entity }
        end
      end
    end

    def event_meal_params
      params.require(:event_meal).permit(:participant_id, :name, :email, :arrival_time, :tln, :veg)
    end
  end
end
