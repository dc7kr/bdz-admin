class MemberAccountBookingsController < ApplicationController
  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = MemberAccountBooking.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @bookings }
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    @booking = MemberAccountBooking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.json
  def new
    @booking = MemberAccountBooking.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @booking }
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = MemberAccountBooking.find(params[:id])
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = MemberAccountBooking.new(params[:booking])

    respond_to do |format|
      if @booking.save
        format.html { redirect_to @booking, :notice => 'MemberAccountBooking was successfully created.' }
        format.json { render :json => @booking, :status => :created, :location => @booking }
      else
        format.html { render :action => "new" }
        format.json { render :json => @booking.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    @booking = MemberAccountBooking.find(params[:id])

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
        format.html { redirect_to @booking, :notice => 'MemberAccountBooking was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @booking.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking = MemberAccountBooking.find(params[:id])
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_url }
      format.json { head :ok }
    end
  end
end
