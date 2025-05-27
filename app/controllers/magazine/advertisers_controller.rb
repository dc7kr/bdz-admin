module Magazine
  class AdvertisersController < AuthorityController
    # GET /advertisers
    # GET /advertisers.json
    def index
      per_page = params[:per_page]

      per_page = 20 if per_page.nil?

      @advertisers = Advertiser.includes(:contact).order("contacts.company, contacts.last_name,contacts.first_name").page(params[:page]).per(per_page)
      authorize_action_for(@advertisers)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @advertisers }
      end
    end

    # GET /advertisers/1
    # GET /advertisers/1.json
    def show
      @advertiser = Advertiser.find(params[:id])
      authorize_action_for(@advertiser)

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @advertiser }
      end
    end

    # GET /advertisers/new
    # GET /advertisers/new.json
    def new
      @advertiser = Advertiser.new
      @advertiser.contact = Contact.new
      @advertiser.contact.country_code = "DE"
      authorize_action_for(@advertiser)

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @advertiser }
      end
    end

    # GET /advertisers/1/edit
    def edit
      @advertiser = Advertiser.find(params[:id])
      authorize_action_for(@advertiser)
    end

    # POST /advertisers
    # POST /advertisers.json
    def create
      @advertiser = Advertiser.new(advertiser_params)

      respond_to do |format|
        if @advertiser.save
          format.html { redirect_to [ :magazine, @advertiser ], notice: "Advertiser was successfully created." }
          format.json { render json: @advertiser, status: :created, location: @advertiser }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @advertiser.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /advertisers/1
    # PUT /advertisers/1.json
    def update
      @advertiser = Advertiser.find(params[:id])

      respond_to do |format|
        if @advertiser.update(advertiser_params)
          format.html { redirect_to [ :magazine, @advertiser ], notice: "Advertiser was successfully updated." }
          format.json { head :no_content }
        else
          format.html { render action: "edit", status: :unprocessable_entity }
          format.json { render json: @advertiser.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /advertisers/1
    # DELETE /advertisers/1.json
    def destroy
      @advertiser = Advertiser.find(params[:id])
      @advertiser.destroy

      respond_to do |format|
        format.html { redirect_to magazine_advertisers_url }
        format.json { head :no_content }
      end
    end

    def advertiser_params
      params.require(:advertiser).permit(:magazines, :active, :iban, :bic, :account_owner, :direct_debit,
                                         :customer_number, contact_attributes: Contact.nested_attributes)
    end
  end
end
