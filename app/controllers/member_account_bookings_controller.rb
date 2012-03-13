class MemberAccountBookingsController < ApplicationController
  # GET /bookings
  # GET /bookings.json
  def index
	@isOrchestra
	@member
	@name=nil
	@mglnr=nil
	if ( params[:orchestra_id]) then
		@member = Orchestra.includes(:member).find(params[:orchestra_id])
		@name = @member.orchName
		@isOrchestra=true
	elsif (params[:person_member_id]) then
		@member= PersonMember.includes(:member).find(params[:person_member_id])
		@name = @member.vorname+" "+@member.nachname
		@isOrchestra=false
	end
    @bookings = MemberAccountBooking.where("member_id=?",@member.member_id)

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
	@isOrchestra=false
	@member
	if ( params[:orchestra_id] ) 
	    @member = Orchestra.find_by_member_id(params[:orchestra_id])
		@isOrchestra=true
	else 
		@member = PersonMember.find_by_member_id(params[:person_member_id]);
	end
    @booking = MemberAccountBooking.new(:member=>@member.member,:booking_date=>Time.now,:booking_mode=>'M')


    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @booking }
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = MemberAccountBooking.find(params[:id])
	@basemember = @booking.member
	@isOrchestra=false
	if ( @basemember.subtype == 'PersonMember') 
		@member = PersonMember.find_by_member_id(params[:person_member_id]);
	else
		@member = Orchestra.find_by_member_id(@basemember.id)
		@isOrchestra=true
	end
	
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = MemberAccountBooking.new(params[:member_account_booking])
	@isOrchestra=false
	if ( params[:orchestra_id])
		@isOrchestra=true
	end

	@booking.booking_mode='M'
    respond_to do |format|
      if @booking.save
        format.html { 
			if ( @isOrchestra )
				redirect_to orchestra_member_account_bookings_path(@booking.member), :notice => t('member_account_booking.create_success')
			else 
				redirect_to person_member_member_account_bookings_path(@booking.member), :notice => t('member_account_booking.create_success')
			end
		}
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
	@isOrchestra = params[:orchestra_id]

	params[:member_account_booking][:booking_mode]='M'
	
    respond_to do |format|
      if @booking.update_attributes(params[:member_account_booking])
        format.html { 
			 if ( params[:orchestra_id] ) then 
				@orchestra = Orchestra.find_by_member_id(params[:orchestra_id])
                redirect_to orchestra_member_account_bookings_path(@orchestra), :notice => t('member_account_booking.update_success')
            else
				@person_member = PersonMember.find_by_member_id(params[:person_member_id])
                redirect_to person_member_member_account_bookings_path(@person_member), :notice => t('member_account_booking.update_success')
            end

		}
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
