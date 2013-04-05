class FestivalApplicationsController < ApplicationController
  # GET /festival_applications
  # GET /festival_applications.json
  def index
    @festival_applications = FestivalApplication.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @festival_applications }
    end
  end

  # GET /festival_applications/1
  # GET /festival_applications/1.json
  def show
    @festival_application = FestivalApplication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @festival_application }
    end
  end

  # GET /festival_applications/new
  # GET /festival_applications/new.json
  def new
    @festival_application = FestivalApplication.new
	@festival_application.contact_person = ContactPerson.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @festival_application }
    end
  end

  # GET /festival_applications/1/edit
  def edit
    @festival_application = FestivalApplication.find(params[:id])
  end

  # POST /festival_applications
  # POST /festival_applications.json
  def create
    @festival_application = FestivalApplication.new(params[:festival_application])
    @contact_person = ContactPerson.new(params[:contact_person])
	@contact_person.save
	@festival_application.contact_person= @contact_person

    respond_to do |format|
      if @festival_application.save
        format.html { redirect_to step2_festival_application_path(@festival_application), notice: 'Festival application was successfully created.' }
        format.json { render json: @festival_application, status: :created, location: @festival_application }
      else
        format.html { render action: "new" }
        format.json { render json: @festival_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /festival_applications/1
  # PUT /festival_applications/1.json
  def update
    @festival_application = FestivalApplication.find(params[:id])

    respond_to do |format|
      if @festival_application.update_attributes(params[:festival_application])
        format.html { redirect_to @festival_application, notice: 'Festival application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @festival_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /festival_applications/1
  # DELETE /festival_applications/1.json
  def destroy
    @festival_application = FestivalApplication.find(params[:id])
    @festival_application.destroy

    respond_to do |format|
      format.html { redirect_to festival_applications_url }
      format.json { head :no_content }
    end
  end

  def step2
	@festival_application = FestivalApplication.find(params[:id])
	
	@festival_pieces = @festival_application.festival_pieces

  end
end
