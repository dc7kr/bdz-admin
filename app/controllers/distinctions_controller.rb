class DistinctionsController < AuthenticatedController

  # for table sort by column click
  helper_method :sort_column, :sort_direction

  def gen_invoice
    @cur_year = Time.now.year
    @distinction = Distinction.find(params[:id])

    datePrefix = Time.now.strftime '%Y%m%d%H%M%S'

    @tw = TexWriter.new
    @ddWriter = SEPAWriter.new(datePrefix, BDZ_SETTINGS)

    @orchestra = @distinction.orchestra 

    @invoiceNumber = "E-"+Time.now.strftime("%Y%m%d-")+@orchestra.mglnr.to_s

    if (@distinction.orchestra.is_direct_debit?) then
       remittance_txt = "Ehrungsrechnung #{@invoiceNumber}" 
       @ddWriter.addBooking(@orchestra, @distinction.calcSum, remittance_txt,"OOFF")
    end

    @invoice = @distinction.gen_invoice(@invoiceNumber)
    @tw.writeInvoice(@invoice, 'distinction',Time.now.year)
    system("/opt/bdz-rechnung/bin/ehrungsrechnung.sh "+String(@orchestra.mglnr))
    @tw.moveGeneratedFiles(@ddWriter.datePrefix)

    if ( @distinction.orchestra.is_direct_debit?) then
      @ddFileName = @ddWriter.generateFile
    end


    @booking_txt = 'Ehrungsrechung '+@invoiceNumber
    @booking =  MemberAccountBooking.newDistinctionInvoice(@booking_txt,-1*@distinction.calcSum,String(@orchestra.mglnr))
    @booking.member_id = @orchestra.id
    @booking.save

    if (@distinction.orchestra.is_direct_debit?) then
      @wdbooking = MemberAccountBooking.newWithdrawal("Lastschrift "+@booking_txt,@distinction.calcSum)
      @wdbooking.member_id = @orchestra.id
      @wdbooking.save
    end

    @distinction.member_account_booking = @booking
    @distinction.save

    send_mail(@ddFileName, @invoiceNumber, @distinction.orchestra)
    shortprefix = Time.now.strftime("%Y%m%d-")

    redirect_to(download_orchestra_member_account_booking_path(@orchestra,@booking))
  end

  # GET /distinctions
  # GET /distinctions.json
  def index
    @distinctions = Distinction.where("orchestra_id = ?",params[:orchestra_id]).search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

	  @orchestra = Orchestra.find_by_member_id(params[:orchestra_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @distinctions }
    end
  end

  # GET /distinctions/1
  # GET /distinctions/1.json
  def show
	@orchestra = Orchestra.find(params[:orchestra_id])
    @distinction = Distinction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @distinction }
    end
  end

  # GET /distinctions/new
  # GET /distinctions/new.json
  def new
	@orchestra = Orchestra.find_by_member_id(params[:orchestra_id])
    @distinction = Distinction.new(:orchestra_id=>@orchestra.id, :dist_date=>Time.now)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @distinction }
    end
  end

  # GET /distinctions/1/edit
  def edit
    @distinction = Distinction.find(params[:id])
	@orchestra = Orchestra.find(params[:orchestra_id])
  end

  # POST /distinctions
  # POST /distinctions.json
  def create
    @distinction = Distinction.new(params[:distinction])
    @orchestra = Orchestra.find(params[:orchestra_id])
    @distinction.orchestra = @orchestra

    respond_to do |format|
      if @distinction.save
        format.html { redirect_to orchestra_distinction_path(params[:orchestra_id],@distinction), notice: 'Distinction was successfully created.' }
        format.json { render json: @distinction, status: :created, location: @distinction }
      else
        format.html { render action: "new" }
        format.json { render json: @distinction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /distinctions/1
  # PUT /distinctions/1.json
  def update
	@orchestra = Orchestra.find(params[:orchestra_id])
    @distinction = Distinction.find(params[:id])

    respond_to do |format|
      if @distinction.update_attributes(params[:distinction])
        format.html { redirect_to orchestra_distinction_path(@orchestra,@distinction), notice: t('distinction.update_success') }

        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @distinction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distinctions/1
  # DELETE /distinctions/1.json
  def destroy
	@orchestra = Orchestra.find(params[:orchestra_id])
    @distinction = Distinction.find(params[:id])
    @distinction.destroy

    respond_to do |format|
      format.html { redirect_to orchestra_distinctions_url(@orchestra) }
      format.json { head :no_content }
    end
  end


  private 
  def sort_column
    Orchestra.column_names.include?(params[:sort]) ? params[:sort] : "distinctions.dist_date"
  end

  def send_mail(ddFile, invoiceNr, orch )
	  year = Time.now.strftime('%Y')
	  pdf_prefix= Time.now.strftime '%Y%m%d'

	  @users = User.where("role like ?", "%admin%")
    base_url = cron_downloads_url
    if not ddFile.nil?
  	  dd_url = base_url+"?year="+year+"&filename="+ddFile.orig_filename
    end

	  AdminNotifier.newdistinction_notification(dd_url,invoiceNr,orch).deliver
  end
end
