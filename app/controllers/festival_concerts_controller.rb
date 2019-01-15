class FestivalConcertsController < AuthenticatedController
  # GET /festival_concerts
  # GET /festival_concerts.json

  helper FestivalApplicationsHelper

  def index
    @festival_concerts = FestivalConcert.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @festival_concerts }
    end
  end

  # GET /festival_concerts/1
  # GET /festival_concerts/1.json
  def show
    @festival_concert = FestivalConcert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @festival_concert }
    end
  end

  # GET /festival_concerts/new
  # GET /festival_concerts/new.json
  def new
    @festival_concert = FestivalConcert.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @festival_concert }
    end
  end

  # GET /festival_concerts/1/edit
  def edit
    @festival_concert = FestivalConcert.find(params[:id])
  end

  # POST /festival_concerts
  # POST /festival_concerts.json
  def create
    @festival_concert = FestivalConcert.new(festival_concert_params)

    respond_to do |format|
      if @festival_concert.save
        format.html { redirect_to @festival_concert, notice: 'Festival concert was successfully created.' }
        format.json { render json: @festival_concert, status: :created, location: @festival_concert }
      else
        format.html { render action: "new" }
        format.json { render json: @festival_concert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /festival_concerts/1
  # PUT /festival_concerts/1.json
  def update
    @festival_concert = FestivalConcert.find(params[:id])

    respond_to do |format|
      if @festival_concert.update_attributes(festival_concert_params)
        format.html { redirect_to @festival_concert, notice: 'Festival concert was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @festival_concert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /festival_concerts/1
  # DELETE /festival_concerts/1.json
  def destroy
    @festival_concert = FestivalConcert.find(params[:id])
    @festival_concert.destroy

    respond_to do |format|
      format.html { redirect_to festival_concerts_url }
      format.json { head :no_content }
    end
  end



  def programme

    @festival_concert = FestivalConcert.find(params[:id])

    @groups = FestivalApplication.where(:festival_concert_id => params[:id])

    respond_to do |format|
      format.html
    end

  end

  def festival_concert_params
    params.require(:festival_concert).permit( :concert_type, :number, :title, :location, :event_time, :outdoor)
  end
end
