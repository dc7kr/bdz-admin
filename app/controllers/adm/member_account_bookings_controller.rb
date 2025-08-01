module Adm
  class MemberAccountBookingsController < AuthenticatedController
    helper ApplicationHelper

    # GET /bookings
    # GET /bookings.json
    def index
      @bookings = MemberAccountBooking.order("booking_date").page(params[:page]).per(30)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @bookings }
        format.js
      end
    end

    # GET /bookings/1
    # GET /bookings/1.json
    def show
      @booking = MemberAccountBooking.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @booking }
      end
    end

    # GET /bookings/new
    # GET /bookings/new.json
    def new
      @isOrchestra = false

      if params[:orchestra_id]
        @member_entity = Orchestra.find(params[:orchestra_id])
        @isOrchestra = true
      else
        @member_entity = PersonMember.find(params[:person_member_id])
      end
      @member = @member_entity.member
      @booking = MemberAccountBooking.new(member: @member, booking_date: Time.zone.now, booking_year: Time.zone.now.year,
                                          booking_mode: "M", booking_type: "Z")

      @member_entity = @member.member_entity

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @booking }
      end
    end

    # GET /bookings/1/edit
    def edit
      @booking = MemberAccountBooking.find(params[:id])
      @basemember = @booking.member
      @isOrchestra = false

      @member = Member.includes(:member_entity).find(@booking.member_id)
      @isOrchestra = true unless @basemember.member_entity_type == "PersonMember"

      @member_entity = @member.member_entity
    end

    # POST /bookings
    # POST /bookings.json
    def create
      if params[:person_member_id]
        @member = PersonMember.find(params[:person_member_id])
        @isOrchestra = false
      else
        @member = Orchestra.find(params[:orchestra_id])
        @isOrchestra = true
      end
      @booking = MemberAccountBooking.new(member_account_booking_params)

      @booking.booking_mode = "M"
      @booking.member = @member.member
      respond_to do |format|
        if @booking.save
          format.html do
            if @isOrchestra
              redirect_to orchestra_member_account_bookings_path(@booking.member.member_entity),
                          notice: t("member_account_booking.create_success")
            else
              redirect_to person_member_member_account_bookings_path(@booking.member.member_entity),
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
      @isOrchestra = params[:orchestra_id]

      params[:member_account_booking][:booking_mode] = "M"

      respond_to do |format|
        if @booking.update(member_account_booking_params)
          format.html do
            if params[:orchestra_id]
              @orchestra = Orchestra.find(params[:orchestra_id])
              redirect_to orchestra_member_account_bookings_path(@orchestra),
                          notice: t_update_success("member_account_booking")
            else
              @person_member = PersonMember.find(params[:person_member_id])
              redirect_to person_member_member_account_bookings_path(@person_member),
                          notice: t_update_success("member_account_booking")
            end
          end
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @booking.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /bookings/1
    # DELETE /bookings/1.json
    def destroy
      @booking = MemberAccountBooking.find(params[:id])
      @booking.destroy

      respond_to do |format|
        format.html do
          if params[:orchestra_id]
            redirect_to orchestra_member_account_bookings_path(params[:orchestra_id])
          else
            redirect_to person_member_member_account_bookings_path(params[:person_member_id])
          end
        end
        format.json { render json: { status: "ok", op: "delete", entityId: @booking.id } }
      end
    end

    def download
      @booking = MemberAccountBooking.find(params[:id])
      fullPath = "#{INVOICE_CONFIG.archive_dir}/#{String(@booking.booking_year)}/#{@booking.filename}"
      send_file(fullPath, filename: @booking.filename, type: "application/pdf", x_sendfile: true)
    end

    private

    def member_account_booking_params
      params.require(:member_account_booking).permit(:booking_type, :booking_year, :booking_mode, :booking_date,
                                                     :booking_txt, :filename, :amount, :ref_booking_id)
    end
  end
end
