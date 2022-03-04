class DistinctionsController < AuthenticatedController

  # for table sort by column click
  helper_method :sort_column, :sort_direction

  def gen_invoice
    cur_year = Time.now.year
    distinction = Distinction.find(params[:id])
    
    orchestra = distinction.orchestra 

    if distinction.has_booking? then
        redirect_to orchestra_distinction_path(orchestra,distinction), :flash => { :error => t('distinction.invoice_already_exists') }
        return
    end

    datePrefix = Time.now.strftime '%Y%m%d%H%M%S'

    ddWriter = CorikaInvoices::SEPAWriter.new(datePrefix, INVOICE_CONFIG)

    invoice = distinction.gen_invoice 
    invoice.save

    pdf = invoice.gen_pdf
    sepa = invoice.gen_sepa 

    booking_txt = 'Ehrungsrechung '+invoice.number
    booking =  MemberAccountBooking.newDistinctionInvoice(booking_txt,-1*invoice.sum,invoice.customer.customer_id,pdf)
    booking.member_id = orchestra.member.id
    booking.invoice_id = invoice.id.to_s
    booking.save

    if (invoice.customer.is_direct_debit?) then
      @wdbooking = MemberAccountBooking.newWithdrawal("Lastschrift "+booking_txt,distinction.calcSum,sepa.orig_filename)
      @wdbooking.member_id = orchestra.member.id
      @wdbooking.save
    end

    distinction.member_account_booking = booking
    distinction.invoice_id=invoice.id.to_s
    distinction.save

    send_mail(invoice,sepa)
    shortprefix = Time.now.strftime("%Y%m%d-")

    redirect_to(download_orchestra_member_account_booking_path(orchestra,booking))
  end

  # GET /distinctions
  # GET /distinctions.json
  def index
    @distinctions = Distinction.where("orchestra_id = ?",params[:orchestra_id]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

	  @orchestra = Orchestra.find(params[:orchestra_id])

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
	  @orchestra = Orchestra.find(params[:orchestra_id])
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
    @distinction = Distinction.new(distinction_params)
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
      if @distinction.update_attributes(distinction_params)
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

  def send_mail(invoice,sepa) 

    #ddFile, invoiceNr, orch )
    #sepa, invoice.number, distinction.orchestra)

    pdf = invoice.pdf_filename

    base_url = cron_downloads_url

    if not sepa.nil?
  	  dd_url = base_url+"?year="+invoice.invoice_date.year.to_s+"&filename="+sepa.orig_filename
    end

	  AdminNotifier.newdistinction_notification(invoice).deliver
  end

  def distinction_params
    params.require(:distinction).permit(:dist_date, :certificates, :honorletters, :medals, :gold_needles, :silver_needles, :national_needles, :porto)
  end
end
