class Magazine::MagazineAdvertsController < AuthenticatedController
  # GET /magazine_adverts
  # GET /magazine_adverts.json
  def index
    @magazine_adverts = MagazineAdvert.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @magazine_adverts }
    end
  end

  # GET /magazine_adverts/1
  # GET /magazine_adverts/1.json
  def show
    @magazine_advert = MagazineAdvert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @magazine_advert }
    end
  end

  # GET /magazine_adverts/new
  # GET /magazine_adverts/new.json
  def new
    @magazine_advert = MagazineAdvert.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @magazine_advert }
    end
  end

  # GET /magazine_adverts/1/edit
  def edit
    @magazine_advert = MagazineAdvert.find(params[:id])
  end

  # POST /magazine_adverts
  # POST /magazine_adverts.json
  def create
    @magazine_advert = MagazineAdvert.new(params[:magazine_advert])

    respond_to do |format|
      if @magazine_advert.save
        format.html { redirect_to @magazine_advert, notice: 'Magazine advert was successfully created.' }
        format.json { render json: @magazine_advert, status: :created, location: @magazine_advert }
      else
        format.html { render action: "new" }
        format.json { render json: @magazine_advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /magazine_adverts/1
  # PUT /magazine_adverts/1.json
  def update
    @magazine_advert = MagazineAdvert.find(params[:id])

    respond_to do |format|
      if @magazine_advert.update_attributes(params[:magazine_advert])
        format.html { redirect_to @magazine_advert, notice: 'Magazine advert was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @magazine_advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /magazine_adverts/1
  # DELETE /magazine_adverts/1.json
  def destroy
    @magazine_advert = MagazineAdvert.find(params[:id])
    @magazine_advert.destroy

    respond_to do |format|
      format.html { redirect_to magazine_adverts_url }
      format.json { head :no_content }
    end
  end
end
