class Public::CountriesController < CountriesController

	include Public::PublicControllerModule

  # GET /countries
  # GET /countries.json
  def index
    @countries = Country.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /countries/1
  # GET /countries/1.json
  def show
    @country = Country.find(params[:id])

    respond_to do |format|
      format.html 
    end
  end

end
