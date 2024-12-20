class Magazine::MagazineSamplingsController < AuthenticatedController
  # GET /magazine_samplings
  # GET /magazine_samplings.json

  include CountryHelper
  include MagazineReportHelper


  def search
    @magazine_samplings = MagazineSampling.includes(:contact).order('contacts.company, contacts.last_name,contacts.first_name').where("contacts.company like '%:search%' or contacts.city like '%:search%'").page(params[:page]).per(per_page)
  end


  def index
    per_page = params[:per_page]

    if per_page.nil?
      per_page=20
    end

    @magazine_samplings = MagazineSampling.includes(:contact).order('contacts.company, contacts.last_name,contacts.first_name').page(params[:page]).per(per_page)


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @magazine_samplings }
      format.js 
    end
  end

  # GET /magazine_samplings/1
  # GET /magazine_samplings/1.json
  def show
    @magazine_sampling = MagazineSampling.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @magazine_sampling }
    end
  end

  # GET /magazine_samplings/new
  # GET /magazine_samplings/new.json
  def new
    @magazine_sampling = MagazineSampling.new

    @magazine_sampling.count=1

    @magazine_sampling.contact = Contact.new
    @magazine_sampling.contact.country_code="DE"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @magazine_sampling }
    end
  end

  # GET /magazine_samplings/1/edit
  def edit
    @magazine_sampling = MagazineSampling.find(params[:id])
  end

  # POST /magazine_samplings
  # POST /magazine_samplings.json
  def create
    @magazine_sampling = MagazineSampling.new(magazine_sampling_params)

    respond_to do |format|
      if @magazine_sampling.save
        format.html { redirect_to @magazine_sampling, notice: 'Magazine sampling was successfully created.' }
        format.json { render json: @magazine_sampling, status: :created, location: @magazine_sampling }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @magazine_sampling.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /magazine_samplings/1
  # PUT /magazine_samplings/1.json
  def update
    @magazine_sampling = MagazineSampling.find(params[:id])

    respond_to do |format|
      if @magazine_sampling.update!(magazine_sampling_params)
        format.html { redirect_to @magazine_sampling, notice: 'Magazine sampling was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @magazine_sampling.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /magazine_samplings/1
  # DELETE /magazine_samplings/1.json
  def destroy
    @magazine_sampling = MagazineSampling.find(params[:id])
    @magazine_sampling.destroy

    respond_to do |format|
      format.html { redirect_to magazine_samplings_url }
      format.json { head :no_content }
    end
  end
  def print_list
    @samplings = MagazineSampling.order("count")

    filename = "magazine_samplings.ods"
    renderSamplingListOds("/tmp/"+filename,@samplings)
    send_file("/tmp/"+filename, :filename => filename, :type => "application/octet-stream")

  	flash[:notice] = "Export complete!"
  end

  private 
  def magazine_sampling_params
    params.require(:magazine_sampling).permit(:count, :inactive, contact_attributes: [:company,:department,:salutation,:title,:first_name,:last_name,:street,:zip,:city,:phone,:office_phone,:mobile,:fax,:email,:bic,:iban,:country_code,:id])
  end
end
