class MemberAccountBookingsController < AuthenticatedController
  include ApplicationHelper

  before_action :set_booking, only: %i[ show edit update destroy download invoice_preview invoice_sepa ]
  helper_method :sort_column, :sort_direction

  # GET /bookings
  # GET /bookings.json
  def index
    @name = nil

    @member_type = member_type_from_params(params)

    if params[:orchestra_id]
      @member = policy_scope(Member).includes(:member_entity).find_by "member_entity_id = ? and member_entity_type='Orchestra'",
                                                        params[:orchestra_id]
      @orchestra = @member.member_entity
      @name = @orchestra.orchName
    elsif params[:person_member_id]
      @member = policy_scope(Member).includes(:member_entity).find_by "member_entity_id = ? and member_entity_type='PersonMember'",
                                                        params[:person_member_id]
      @name = @member.member_entity.fullname
    elsif params[:regional_organization_id]
      @member = policy_scope(Member).includes(:member_entity).find_by "member_entity_id = ? and member_entity_type='RegionalOrganization'",
                                                        params[:regional_organization_id]
      @name = @member.member_entity.name
    end

    if @member.nil?
      @bookings = policy_scope(MemberAccountBooking).order("#{sort_column} #{sort_direction}").page(params[:page]).per(30)
    else
      @bookings = policy_scope(MemberAccountBooking).where("member_id=?", @member.id).order("#{sort_column} #{sort_direction}").page(params[:page]).per(30)
      @member_entity = @member.member_entity
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookings }
      format.js
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.json
  def new
    if params[:orchestra_id]
      @member_entity = Orchestra.find(params[:orchestra_id])
    elsif params[:person_member_id]
      @member_entity = PersonMember.find(params[:person_member_id])
    elsif params[:regional_organization_id]
      @member_entity = RegionalOrganization.find(params[:regional_organization_id])
    end

    @member_type = @member_entity.class.name.singularize.underscore.to_sym

    @member = @member_entity.member
    @booking = MemberAccountBooking.new(member: @member, booking_date: Time.zone.now, booking_year: Time.zone.now.year,
                                        booking_mode: "M", booking_type: "Z")

    authorize @booking

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/1/edit
  def edit
    basemember = @booking.member
    @isOrchestra = false
    @member = policy_scope(Member).includes(:member_entity).find(@booking.member_id)
    @member_entity = @member.member_entity
    @member_type = @member_entity.class.name.singularize.underscore.to_sym
    Rails.logger.debug(@member_type)
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @member_type = member_type_from_params(params).to_sym

    if params[:person_member_id]
      @member = PersonMember.find(params[:person_member_id])
      @isOrchestra = false
    elsif params[:orchestra_id]
      @member = Orchestra.find(params[:orchestra_id])
    else
      @member = RegionalOrganization.find(params[:regional_organization_id])
    end

    @booking = MemberAccountBooking.new(member_account_booking_params)
    authorize @booking

    @booking.booking_mode = "M"
    @booking.member = @member.member
    respond_to do |format|
      if @booking.save
        format.html do
          if @member_type == :orchestra
            redirect_to orchestra_member_account_bookings_path(@booking.member.member_entity),
                        notice: t("member_account_booking.create_success")
          elsif @member_type == :person_member
            redirect_to person_member_member_account_bookings_path(@booking.member.member_entity),
                        notice: t("member_account_booking.create_success")
          else
            redirect_to regional_organization_member_account_bookings_path(@booking.member.member_entity),
                        notice: t("member_account_booking.create_success")
          end
        end
        format.json { render json: @booking, status: :created, location: @booking }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    @booking = MemberAccountBooking.find(params[:id])

    member_entity = @booking.member.member_entity

    @member_type = member_type_from_params(params)

    params[:member_account_booking][:booking_mode] = "M"

    respond_to do |format|
      if @booking.update(member_account_booking_params)
        format.html do
          if @member_type == :orchestra
            redirect_to orchestra_member_account_bookings_path(member_entity),
                        notice: t_update_success("member_account_booking")

          elsif @member_type == :person_member
            redirect_to person_member_member_account_bookings_path(member_entity),
                        notice: t_update_success("member_account_booking")
          else
            redirect_to regional_organization_member_account_bookings_path(member_entity),
                        notice: t_update_success("member_account_booking")
          end
        end
        format.json { head :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    member_entity = @booking.member.member_entity
    member_type = @booking.member_type 

    @booking.destroy

    respond_to do |format|
      format.html do
        if member_type == :orchestra 
          redirect_to orchestra_member_account_bookings_path(member_entity)
        else
          redirect_to person_member_member_account_bookings_path(member_entity)
        end
      end
      format.json { render json: { status: "ok", op: "delete", entityId: @booking.id } }
    end
  end

  def download
    x_sendfile = false
    fullPath = "#{INVOICE_CONFIG.archive_dir}/#{String(@booking.booking_year)}/#{@booking.filename}"
    # send_file(fullPath, :filename => @booking.filename, :x_sendfile=>true,:type=>"application/octet-stream")
    send_file(fullPath, filename: @booking.filename, x_sendfile: x_sendfile, type: "application/octet-stream")
  end

  def invoice_sepa
    @invoice = CorikaInvoices::Invoice.find(@booking.invoice_id)

    sepa = @invoice.gen_sepa_xml

    filename = File.basename(@booking.filename)
    filename.append(".sepa.xml")

    send_data(sepa, filename: filename, type: "application/octet-stream")
  end
  
  def invoice_preview
    @invoice = CorikaInvoices::Invoice.find(@booking.invoice_id)

    @invoice_hash = @invoice.to_hash[:invoice]

    respond_to do |format|
      format.turbo_stream { render template: "corika_invoices/invoices/preview" }
      format.html { render template: "corika_invoices/invoices/preview" }
    end
  end


  private

  def member_account_booking_params
    params.require(:member_account_booking).permit(:booking_type, :booking_year, :booking_mode, :booking_date,
                                                   :booking_txt, :filename, :amount, :ref_booking_id)
  end

  def member_type_from_params(params)
    if params[:orchestra_id]
      :orchestra
    elsif params[:person_member_id]
      :person_member
    elsif params[:regional_organization_id]
      :regional_organization
    else 
      :none
    end
  end

  private 
  def set_booking
    @booking = policy_scope(MemberAccountBooking).find(params[:id])
    authorize @booking
  end
  def sort_column
    MemberAccountBooking.column_names.include?(params[:sort]) ? params[:sort] : "booking_date"
  end

end
