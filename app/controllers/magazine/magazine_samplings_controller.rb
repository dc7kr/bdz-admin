module Magazine
  class MagazineSamplingsController < AuthenticatedController

    before_action :set_magazine_sampling, only: %i[ show edit update destroy ]

    helper_method :sort_column, :sort_direction

    # GET /magazine_samplings
    # GET /magazine_samplings.json

    include CountryHelper
    include MagazineReportHelper

    def index
      per_page = params[:per_page]

      per_page = 20 if per_page.nil?

      @magazine_samplings = policy_scope(MagazineSampling).includes(:contact)

      if not params[:search].nil?
        search = "%#{params[:search]}%"
        @magazine_samplings = policy_scope(MagazineSampling).includes(:contact).order("contacts.company, contacts.last_name,contacts.first_name").where("contacts.company like :search or contacts.city like :search", search: search).page(params[:page]).per(per_page)
      else 
        @magazine_samplings = policy_scope(MagazineSampling).includes(:contact).order("contacts.company, contacts.last_name,contacts.first_name").page(params[:page]).per(per_page)
      end

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @magazine_samplings }
        format.js
      end
    end

    # GET /magazine_samplings/1
    # GET /magazine_samplings/1.json
    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @magazine_sampling }
      end
    end

    # GET /magazine_samplings/new
    # GET /magazine_samplings/new.json
    def new
      @magazine_sampling = MagazineSampling.new
      authorize @magazine_sampling

      @magazine_sampling.count = 1

      @magazine_sampling.contact = Contact.new
      @magazine_sampling.contact.country_code = "DE"

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @magazine_sampling }
      end
    end

    # GET /magazine_samplings/1/edit
    def edit
    end

    # POST /magazine_samplings
    # POST /magazine_samplings.json
    def create
      @magazine_sampling = MagazineSampling.new(magazine_sampling_params)
      authorize @magazine_sampling

      respond_to do |format|
        if @magazine_sampling.save
          format.html { redirect_to @magazine_sampling, notice: "Magazine sampling was successfully created." }
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

      respond_to do |format|
        if @magazine_sampling.update!(magazine_sampling_params)
          format.html { redirect_to @magazine_sampling, notice: "Magazine sampling was successfully updated." }
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
      @magazine_sampling = policy_scope(MagazineSampling).find(params[:id])
      @magazine_sampling.destroy

      respond_to do |format|
        format.html { redirect_to magazine_samplings_url }
        format.json { head :no_content }
      end
    end

    def print_list
      @samplings = policy_scope(MagazineSampling).order("count")

      filename = "magazine_samplings.ods"
      renderSamplingListOds("/tmp/#{filename}", @samplings)
      send_file("/tmp/#{filename}", filename: filename, type: "application/octet-stream")

      flash[:notice] = "Export complete!"
    end

    private
    def set_magazine_sampling
      @magazine_sampling = policy_scope(MagazineSampling).find(params[:id])
      authorize @magazine_sampling
    end

    def magazine_sampling_params
      params.require(:magazine_sampling).permit(:count, :inactive,
                                                contact_attributes: %i[company department salutation title first_name last_name street zip city phone office_phone mobile fax email bic iban country_code id])
    end

    def sort_column
      MagazineSampling.column_names.include?(params[:sort]) ? params[:sort] : "members.mglnr"
    end
  end
end
