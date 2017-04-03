require 'rodf'
class EventMealsController < AuthenticatedController
  # GET /event_meals
  # GET /event_meals.json
  def index
    @event_meals = EventMeal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_meals }
      format.ods {
        prefix = Time.new.strftime("%Y%m%d%H%M_")
        renderOds(@event_meals,"/tmp/event_meals.ods") 
        send_file("/tmp/event_meals.ods", :filename => prefix+"event_meals.ods", :type => "application/octet-stream")
      }
    end
  end

  def update_hash(day,hash,e)
      mittag_seconds = 12*3600
      abend_seconds = 17*3600

      if e.arrival_time.nil?
        return
      end

      if e.arrival_time.day < day then
          hash[:mittag][:veg]+=e.veg
          hash[:mittag][:tln]+=e.tln
          hash[:abend][:veg]+=e.veg 
          hash[:abend][:tln]+=e.tln
      end

      if e.arrival_time.day == day then

        if e.arrival_time.seconds_since_midnight < mittag_seconds then
          hash[:mittag][:veg]+=e.veg
          hash[:mittag][:tln]+=e.tln
        end

        if e.arrival_time.seconds_since_midnight < abend_seconds then
          hash[:abend][:veg]+=e.veg 
          hash[:abend][:tln]+=e.tln
        end
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
    @event_meal = EventMeal.new(params[:event_meal])
    @event_meal.orderdate = Time.now

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
      format.json { render :json=>{ :status=>"ok", :op=>"delete", :entityId=>@event_meal.id } }
    end
  end


  def arrival_overview
    @event_meals = EventMeal.order(:arrival_time)

    @counts = Hash.new
    @counts[:do] = { :mittag=>{:tln=>0,:veg=>0}, :abend => {:tln=>0,:veg=>0} }
    @counts[:fr] = { :mittag=>{:tln=>0,:veg=>0}, :abend => {:tln=>0,:veg=>0} }
    @counts[:sa] = { :mittag=>{:tln=>0,:veg=>0}, :abend => {:tln=>0,:veg=>0} }

    @event_meals.each do |e|
      update_hash(29,@counts[:do],e)
      update_hash(30,@counts[:fr],e)
      update_hash(31,@counts[:sa],e)
    end  
  end

 def renderOds(meals,filename)

    RODF::Spreadsheet.file(filename) do
      table "Essensmeldungen"  do
        row {
            cell I18n.t("common.number")
            cell I18n.t("festival_application.orch_name")
            cell I18n.t("event_meal.arrival_time")
            cell ""
            cell I18n.t("event_meal.meals")
            cell I18n.t("event_meal.veg")
				}

	    	meals.each do |meal|
          row {
            cell meal.participant_id
            if meal.festival_application.nil? then
              cell "---"
            else
              cell meal.festival_application.orch_name
            end
            if meal.arrival_time.nil?  then
              cell "---"
              cell "---"
            else
              cell meal.arrival_time.strftime("%d.%m.%Y")
              cell meal.arrival_time.strftime("%H:%M")
            end
            cell meal.tln,:type => :float
            cell meal.veg,:type => :float
          }
        end
      end
    end
  end

end
