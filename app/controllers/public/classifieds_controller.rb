module Public
  class ClassifiedsController < Public::ApplicationController
    helper_method :sort_column, :sort_direction

    def index
      @offer_classifieds = Classified.not_expired.active.where('adv_type=1').order('entrydate desc')
      @search_classifieds = Classified.not_expired.active.where('adv_type=0').order('entrydate desc')

      @classifieds = Classified.search(params[:search]).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)

      respond_to do |format|
        format.html # index.html.erb
        format.js
        format.json { render json: @offer_classifieds }
      end
    end

    def show
      @classified = Classified.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @classified }
      end
    end

    # GET /classifieds/new
    # GET /classifieds/new.json
    def new
      @classified = Classified.new
      @classified.adv_type = 1

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @classified }
      end
    end

    # GET /classifieds/1/edit
    def edit
      @classified = Classified.find(params[:id])
    end

    # POST /classifieds
    # POST /classifieds.json
    def create
      @classified = Classified.new(classified_params)

      @classified.entrydate = Time.zone.now
      @classified.validuntil = @classified.entrydate + 3.months
      @classified.ip = request.remote_ip

      Rails.logger.debug { "Remote IP: <#{request.remote_ip}" }

      respond_to do |format|
        if @classified.save
          format.html { redirect_to public_classifieds_path, notice: I18n.t('classified.create_success') }
          format.json { render json: @classified, status: :created, location: @classified }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @classified.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /classifieds/1
    # PUT /classifieds/1.json
    def update
      @classified = Classified.find(params[:id])

      respond_to do |format|
        if @classified.update(params[:classified])
          format.html { redirect_to @classified, notice: 'Classified was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @classified.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def sort_column
      Classified.column_names.include?(params[:sort]) ? params[:sort] : 'validuntil'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

    def classified_params
      params.require(:classified).permit(:adv_type, :object, :description, :name, :email, :url)
    end
  end
end
