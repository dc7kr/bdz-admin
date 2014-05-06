require 'odf/spreadsheet'
class FestivalApplicationsController < AuthenticatedController

  include CountryHelper
  include FileArchiveHelper

  helper_method :sort_column, :sort_direction

  layout :choose_layout
  # GET /festival_applications
  # GET /festival_applications.json
  def index
    @festival_applications = FestivalApplication.order(sort_column+ " "+ sort_direction).search(params[:search]).page(params[:page]).per(20)
    @sum_players = FestivalApplication.sum(:num_players)

    respond_to do |format|
	 		format.js
      format.html # index.html.erb
      format.json { render json: @festival_applications }
    end
  end

  def permitted 
    now = Time.new
	  currDate = now.strftime("%d.%m.%Y")

    respond_to do |format|
      @festival_applications = FestivalApplication.where(:permission=>true).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

      format.js

      format.html { 
        render :index
      }

      format.json { 
        render json: @festival_applications 
      }

      format.pdf do
        pdf = FestivalApplicationsPdf.new(@festival_applications,view_context)
        send_data pdf.render, filename: "festival_applications_#{currDate}.pdf", type: "application/pdf", disposition: "inline"
      end

      format.ods do 
        @festival_applications = FestivalApplication.where(:permission=>true).order(sort_column+ " "+ sort_direction)
        @sum_players = FestivalApplication.where(:permission=>true).sum(:num_players)
        renderApplicationOds(@festival_applications,"/tmp/festival_applications.ods") 
              send_file("/tmp/festival_applications.ods", :filename => "festival_permissions_"+Time.now.year.to_s+".ods", :type => "application/octet-stream")
      end

    end
  end

  def list
    @festival_applications = FestivalApplication.order([:group_type,:orch_name])
    now = Time.new
	  currDate = now.strftime("%d.%m.%Y")

    respond_to do |format|
      format.html { render}
      format.pdf do
      pdf = FestivalApplicationsPdf.new(@festival_applications,view_context)
      send_data pdf.render, filename: "festival_applications_#{currDate}.pdf", type: "application/pdf", disposition: "inline"
      end
      format.ods do renderApplicationOds(@festival_applications,"/tmp/festival_applications.ods") 
              send_file("/tmp/festival_applications.ods", :filename => "festival_applications_"+Time.now.year.to_s+".ods", :type => "application/octet-stream")
      end
    end
  end

  def grp_list
    @festival_applications = FestivalApplication.where("visitor_type = ?",params[:visitor_type]).order([:group_type,:orch_name])

    now = Time.new
	  currDate = now.strftime("%d.%m.%Y")

    respond_to do |format|
      format.html { render}
      format.pdf do
      pdf = FestivalApplicationsPdf.new(@festival_applications,view_context)
      send_data pdf.render, filename: "festival_applications_#{currDate}.pdf", type: "application/pdf", disposition: "inline"
      end
      format.ods do renderApplicationOds(@festival_applications,"/tmp/festival_applications.ods") 
              send_file("/tmp/festival_applications.ods", :filename => "festival_applications_"+Time.now.year.to_s+".ods", :type => "application/octet-stream")
      end
    end
  end

  # GET /festival_applications/1
  # GET /festival_applications/1.json
  def show
    @festival_application = FestivalApplication.find(params[:id])

    @contact_person = @festival_application.contact_person

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @festival_application }
    end
  end

  def finalize 
    @festival_application = FestivalApplication.find(params[:id])
  end

  # GET /festival_applications/new
  # GET /festival_applications/new.json
  def new
    @festival_application = FestivalApplication.new
	@festival_application.contact_person = ContactPerson.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @festival_application }
    end
  end

  # GET /festival_applications/1/edit
  def edit
    @festival_application = FestivalApplication.find(params[:id])
  end

  # POST /festival_applications
  # POST /festival_applications.json
  def create
    @festival_application = FestivalApplication.new(params[:festival_application])
    @contact_person = ContactPerson.new(params[:contact_person])
	@contact_person.save
	@festival_application.contact_person= @contact_person

    respond_to do |format|
      if @festival_application.save
        format.html { redirect_to step2_festival_application_path(@festival_application), notice: 'Festival application was successfully created.' }
        format.json { render json: @festival_application, status: :created, location: @festival_application }
      else
        format.html { render action: "new" }
        format.json { render json: @festival_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /festival_applications/1
  # PUT /festival_applications/1.json
  def update
    @festival_application = FestivalApplication.find(params[:id])

    @festival_application.contact_person.update_attributes(params[:contact_person])

    respond_to do |format|
      if @festival_application.update_attributes(params[:festival_application])
        format.html { redirect_to @festival_application, notice: 'Festival application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @festival_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /festival_applications/1
  # DELETE /festival_applications/1.json

  def destroy
    @festival_application = FestivalApplication.find(params[:id])
    @festival_application.destroy

    respond_to do |format|
      format.html { redirect_to festival_applications_url }
      format.json { head :no_content }
    end
  end

  def step2
	@festival_application = FestivalApplication.find(params[:id])
	
	@festival_pieces = @festival_application.festival_pieces

  end

  def renderApplicationOds(applications,filename)

	  ODF::Spreadsheet.file(filename) do
				table "Festival Anmeldungen"  do
					row {
						cell I18n.t("common.number")
						cell I18n.t("festival_application.group_type")
						cell I18n.t("festival_application.orch_name")
						cell I18n.t("festival_application.country_id")
						cell I18n.t("festival_application.num_players")
        		cell I18n.t("contact_person.salutation")
				    cell I18n.t("contact_person.first_name")
				    cell I18n.t("contact_person.last_name")
				    cell I18n.t("contact_person.street")
				    cell I18n.t("contact_person.zip")
				    cell I18n.t("contact_person.city")
				    cell I18n.t("contact_person.country_code")
				    cell I18n.t("contact_person.email")
						cell I18n.t("festival_application.special_cast")
						cell I18n.t("festival_application.equipment")
						cell I18n.t("festival_piece.composer")
						cell I18n.t("festival_piece.title")
						cell I18n.t("festival_piece.duration")
						cell I18n.t("festival_piece.composer")
						cell I18n.t("festival_piece.title")
						cell I18n.t("festival_piece.duration")
						cell I18n.t("festival_piece.composer")
						cell I18n.t("festival_piece.title")
						cell I18n.t("festival_piece.duration")
						cell I18n.t("festival_piece.composer")
						cell I18n.t("festival_piece.title")
						cell I18n.t("festival_piece.duration")
						cell I18n.t("festival_piece.composer")
						cell I18n.t("festival_piece.title")
						cell I18n.t("festival_piece.duration")
					}

	    			applications.each do |app|
						if ( app.country_code != "de" ) then 
							grp_locale=:en
						else
							grp_locale=:de
						end

						row {
							cell app.id
							cell I18n.t("festival_application.group_types."+app.group_type)
							cell app.orch_name
							cell app.t_country
							cell app.num_players
							cell I18n.t("common.salutations."+app.contact_person.salutation,:locale=>grp_locale)
							cell app.contact_person.first_name
							cell app.contact_person.last_name
							cell app.contact_person.street
							cell app.contact_person.zip
							cell app.contact_person.city
							cell app.contact_person.t_country
							cell app.contact_person.email

							cell app.special_cast
							cell app.equipment

							app.festival_pieces.each do |p|
								cell p.composer
								cell p.title
								cell p.duration
							end
						}
					end
  				end
			end
	end


  def gen_invoice
    @festival_application = FestivalApplication.find(params[:id])
    tw = TexWriter.new

    prefix = Time.now.strftime("%Y%m%d%H%M%S_")
    year = Time.now.year
    invoice = @festival_application.invoice 
    tw.writeInvoice(invoice,'festival',year)

    inv_type = "festival.en"
    if invoice.customer.country == 'de' or invoice.customer.country=='at' then
      inv_type = "festival.de"
    end

    work_pdf_file = tw.gen_pdf(inv_type,prefix,invoice.customer.id)

    workdir = BDZ_SETTINGS["invoice_workdir"]
    invoice_file = archive_file(workdir,work_pdf_file,year)  

    send_file(invoice_file.full_path, :filename => invoice_file.orig_filename, :type => "application/octet-stream")

  end


  def sort_column
    FestivalApplication.column_names.include?(params[:sort]) ? params[:sort] : "id"
  #group_type [:group_type,:orch_name])
  end
end
