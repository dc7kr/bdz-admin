class EventCardsController < AuthenticatedController
  include FileArchiveHelper
  # GET /event_cards
  # GET /event_cards.json
  def index
    @event_cards = EventCard.search(params[:search])


    @sum=0
    @payed=0
    @event_cards.each do |e|
      iv = e.invoice
      @sum+=iv.sum
      if e.payment_received then
        @payed+=iv.sum
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_cards }
    end
  end

  # GET /event_cards/1
  # GET /event_cards/1.json
  def show
    @event_card = EventCard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event_card }
    end
  end

  # GET /event_cards/new
  # GET /event_cards/new.json
  def new
    @event_card = EventCard.new
    @prices = BDZ_SETTINGS["festival_prices"]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_card }
    end
  end

  # GET /event_cards/1/edit
  def edit
    @event_card = EventCard.find(params[:id])
    @prices = BDZ_SETTINGS["festival_prices"]
  end

  # POST /event_cards
  # POST /event_cards.json
  def create
    @event_card = EventCard.new(params[:event_card])

    respond_to do |format|
      if @event_card.save
        format.html { redirect_to @event_card, notice: 'Event card was successfully created.' }
        format.json { render json: @event_card, status: :created, location: @event_card }
      else
        format.html { render action: "new" }
        format.json { render json: @event_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /event_cards/1
  # PUT /event_cards/1.json
  def update
    @event_card = EventCard.find(params[:id])

    respond_to do |format|
      if @event_card.update_attributes(params[:event_card])
        format.html { redirect_to @event_card, notice: 'Event card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_cards/1
  # DELETE /event_cards/1.json
  def destroy
    @event_card = EventCard.find(params[:id])
    @event_card.destroy

    respond_to do |format|
      format.html { redirect_to event_cards_url }
      format.json { render :json=>{ :status=>"ok", :op=>"delete", :entityId=>@event_card.id } }
    end
  end

  def gen_invoice
    @event_card = EventCard.find(params[:id])
    tw = TexWriter.new

    prefix = Time.now.strftime("%Y%m%d%H%M%S_")
    year = Time.now.year
    invoice = @event_card.invoice 
    tw.writeInvoice(invoice,'festival',year)

    inv_type = "event_card.en"
    if invoice.customer.country == 'de' or invoice.customer.country=='at' then
      inv_type = "event_card.de"
    end
    logger.debug("Customer: "+invoice.customer.name)

    work_pdf_file = tw.gen_pdf(inv_type,prefix,invoice.customer.id)

    workdir = BDZ_SETTINGS["invoice_workdir"]
    invoice_file = archive_file(workdir,work_pdf_file,year)  

    send_file(invoice_file.full_path, :filename => invoice_file.orig_filename, :type => "application/octet-stream")
  end

  def invoices

    date_prefix = Time.now.strftime '%Y%m%d'
    year = Time.now.year

    tw = TexWriter.new
    orders = EventCard.all

    orders.each do |o|

      invoice_file = event_card_invoice(date_prefix, o, year, tw)

      system("/opt/bdz-rechnung/bin/ehrungsrechnung.sh #{o.id}")
#      tw.moveGeneratedFiles(date_prefix.datePrefix)
    end
  end

  def overview
    datePrefix = Time.now.strftime '%Y%m%d%H%M%s'
    @event_cards = EventCard.order(:id)
    respond_to do |format|
      format.pdf do
        pdf = TicketOrderOverviewPdf.new(@event_cards,view_context)
        send_data pdf.render, filename: datePrefix+"_ticket_orders.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  private
  def event_card_invoice(datePrefix, event_card, year, tw)


    renr = "EC-#{datePrefix}-#{event_card.id}"
    invoice = event_card.gen_invoice(renr)
		tw.write(invoice.customer,year)

    invoice_type = "event_card"

		tw.writeInvoice(invoice, 'gs',year)

    work_pdf_file = tw.gen_pdf(invoice_type,datePrefix, invoice.customer.customer_id)

    workdir = BDZ_SETTINGS["invoice_workdir"]
    invoice_file = archive_file(workdir,work_pdf_file,year)

    invoice_file
  end

  

end
