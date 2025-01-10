class RegionalOrganizationBookingsController < AuthenticatedController
  # GET /regional_organization_bookings
  # GET /regional_organization_bookings.json
  def index
    @name = nil
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])

    @bookings = RegionalOrganizationBooking.where('regional_organization_id=?', @regional_organization.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookings }
    end
  end

  # GET /regional_organization_bookings/new
  # GET /regional_organization_bookings/new.json
  def new
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])

    @booking = RegionalOrganizationBooking.new(regional_organization: @regional_organization, booking_date: Time.now,
                                               booking_year: Time.now.year, booking_mode: 'M', booking_type: 'S')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /regional_organization_bookings/1/edit
  def edit
    @regional_organization = RegionalOrganization.find(params[:regional_organization_id])
    @booking = RegionalOrganizationBooking.find(params[:id])
  end

  # POST /regional_organization_bookings
  # POST /regional_organization_bookings.json
  def create
    @booking = RegionalOrganizationBooking.new(params[:regional_organization_booking])

    @booking.booking_mode = 'M'
    respond_to do |format|
      if @booking.save
        format.html do
          redirect_to regional_organization_acct_bookings_path(@booking.regional_organization),
                      notice: 'Regional organization booking was successfully created.'
        end
        format.json { render json: @booking, status: :created, location: @booking }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /regional_organization_bookings/1
  # PUT /regional_organization_bookings/1.json
  def update
    @booking = RegionalOrganizationBooking.find(params[:id])

    respond_to do |format|
      if @booking.update(params[:regional_organization_booking])
        format.html do
          redirect_to regional_organization_acct_bookings_path(@booking.regional_organization),
                      notice: t('regional_organization.change_success')
        end
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /regional_organization_bookings/1
  # DELETE /regional_organization_bookings/1.json
  def destroy
    @booking = RegionalOrganizationBooking.find(params[:id])
    @lv = @booking.regional_organization_id
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to regional_organization_acct_bookings_path(@lv) }
      format.json { render json: { status: 'ok', op: 'delete', entityId: @booking.id } }
    end
  end

  def download; end
end
