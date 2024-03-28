class ContactEventsController < AuthenticatedController
  # GET /contact_events
  # GET /contact_events.json
  def index

    @contact_events = nil
    if params[:contact_person_id] != nil then
      @contact_person = ContactPerson.find(params[:contact_person_id])
      @contact_events = ContactEvent.where(:contact_person_id => @contact_person.id)
      @up_path = contact_person_path(@contact_person)

    else 
      @up_path = home_public_data_path
      @contact_events = ContactEvent.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contact_events }
    end
  end

  # GET /contact_events/1
  # GET /contact_events/1.json
  def show
    @contact_event = ContactEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact_event }
    end
  end

  # GET /contact_events/new
  # GET /contact_events/new.json
  def new
    @contact_event = ContactEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact_event }
    end
  end

  # GET /contact_events/1/edit
  def edit
    @contact_event = ContactEvent.find(params[:id])
  end

  # POST /contact_events
  # POST /contact_events.json
  def create
    @contact_event = ContactEvent.new(params[:contact_event])

    respond_to do |format|
      if @contact_event.save
        format.html { redirect_to @contact_event, notice: 'Contact event was successfully created.' }
        format.json { render json: @contact_event, status: :created, location: @contact_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contact_events/1
  # PUT /contact_events/1.json
  def update
    @contact_event = ContactEvent.find(params[:id])

    respond_to do |format|
      if @contact_event.update(params[:contact_event])
        format.html { redirect_to @contact_event, notice: 'Contact event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_events/1
  # DELETE /contact_events/1.json
  def destroy
    @contact_event = ContactEvent.find(params[:id])
    @contact_event.destroy

    respond_to do |format|
      format.html { redirect_to contact_events_url }
      format.json { head :no_content }
    end
  end
end
