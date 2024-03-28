class MemberAccountBookingsController < AuthenticatedController
  # GET /bookings
  # GET /bookings.json
  def index
    @member
    @name=nil
    
    @member_type = member_type_from_params(params)

    if ( params[:orchestra_id]) then
      @member = Member.includes(:member_entity).find_by "member_entity_id = ? and member_entity_type='Orchestra'" , params[:orchestra_id]
      @orchestra = @member.member_entity
      @name = @orchestra.orchName
    elsif (params[:person_member_id]) then
      @member = Member.includes(:member_entity).find_by "member_entity_id = ? and member_entity_type='PersonMember'", params[:person_member_id]
      @name = @member.member_entity.fullname
    elsif (params[:regional_organization_id]) then
      @member = Member.includes(:member_entity).find_by "member_entity_id = ? and member_entity_type='RegionalOrganization'", params[:regional_organization_id]
      @name = @member.member_entity.name
    end

    if not @member.nil? then
      @bookings = MemberAccountBooking.where("member_id=?",@member.id).page(params[:page])
      @member_entity = @member.member_entity
    else
      @bookings = MemberAccountBooking.order("booking_date").page(params[:page]).per(30)
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @bookings }
	    format.js
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
    
    if ( params[:orchestra_id] ) 
      @member_entity = Orchestra.find(params[:orchestra_id])
      @isOrchestra=true
    elsif ( params[:person_member_id] ) 
      @member_entity = PersonMember.find(params[:person_member_id])
    elsif ( params[:regional_organization_id] ) 
      @member_entity = RegionalOrganization.find(params[:regional_organization_id])
    end
    @member = @member_entity.member
    @booking = MemberAccountBooking.new(:member=>@member,:booking_date=>Time.now,:booking_year=>Time.now.year,:booking_mode=>'M',:booking_type=>'Z')

      @member_entity = @member.member_entity

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
    
    if ( @basemember.member_entity_type == 'PersonMember') 
      @member = Member.includes(:member_entity).find(@booking.member_id) 
    else
      @member = Member.includes(:member_entity).find(@booking.member_id)
      @isOrchestra=true
    end
  end

  # POST /bookings
  # POST /bookings.json
  def create

    @member_type = member_type_from_params(params)

    if params[:person_member_id] then
      @member = PersonMember.find(params[:person_member_id])
	    @isOrchestra=false
    elsif params[:orchestra_id] then
      @member = Orchestra.find(params[:orchestra_id])
    else 
      @member = RegionalOrganization.find(params[:regional_organization_id])
    end

    @booking = MemberAccountBooking.new(member_account_booking_params)

  	@booking.booking_mode='M'
    @booking.member = @member.member
    respond_to do |format|
      if @booking.save
        format.html { 
			if ( @member_type == :orchestra)
				redirect_to orchestra_member_account_bookings_path(@booking.member.member_entity), :notice => t('member_account_booking.create_success')
			elsif @member_type == :person_member
				redirect_to person_member_member_account_bookings_path(@booking.member.member_entity), :notice => t('member_account_booking.create_success')
      else
				redirect_to regional_organization_member_account_bookings_path(@booking.member.member_entity), :notice => t('member_account_booking.create_success')
			end
		}
        format.json { render :json => @booking, :status => :created, :location => @booking }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render :json => @booking.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    @booking = MemberAccountBooking.find(params[:id])

    member_entity = @booking.member.member_entity
    
    @member_type = member_type_from_params(params)

	  params[:member_account_booking][:booking_mode]='M'
	
    respond_to do |format|
      if @booking.update(member_account_booking_params)
        format.html { 
          if @member_type == :orchestra 
             redirect_to orchestra_member_account_bookings_path(member_entity), :notice => t('member_account_booking.update_success')
          elsif @member_type == :person_member
             redirect_to person_member_member_account_bookings_path(member_entity), :notice => t('member_account_booking.update_success')
          else 
            redirect_to regional_organization_member_account_bookings_path(member_entity), :notice => t('member_account_booking.update_success')
          end
		    }
        format.json { head :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
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
      		format.html { 
				if ( params[:orchestra_id]) then
					redirect_to orchestra_member_account_bookings_path(params[:orchestra_id])
				else 
      				redirect_to person_member_member_account_bookings_path(params[:person_member_id])
				end
			}
      format.json { render :json=>{ :status=>"ok", :op=>"delete", :entityId=>@booking.id } }
    end
  end

  def download
     x_sendfile=false
    @booking = MemberAccountBooking.find(params[:id])
	  fullPath = INVOICE_CONFIG.archive_dir+"/"+String(@booking.booking_year)+"/"+@booking.filename
	  #send_file(fullPath, :filename => @booking.filename, :type => "application/pdf", :x_sendfile=>true)
	  #send_file(fullPath, :filename => @booking.filename, :x_sendfile=>true,:type=>"application/octet-stream")
	  send_file(fullPath, filename: @booking.filename, x_sendfile: x_sendfile,type: "application/octet-stream")
  end

  private
  def member_account_booking_params
    params.require(:member_account_booking).permit(:booking_type, :booking_year, :booking_mode, :booking_date, :booking_txt, :filename, :amount, :ref_booking_id)
  end

  def member_type_from_params(params)
    if params[:orchestra_id]
      :orchestra
    elsif params[:person_member_id]
      :person_member
    else
      :regional_organization
    end
  end
end
