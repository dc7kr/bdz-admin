class OrchestraContactsController < AuthenticatedController

  helper_method :sort_column, :sort_direction

  # GET /orchestra_contacts
  # GET /orchestra_contacts.json
  def index
    @orchestra_contacts = OrchestraContact.where("orchestra_id = ?",params[:orchestra_id]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)
	@orchestra = Orchestra.find(params[:orchestra_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orchestra_contacts }
    end
  end

  # GET /orchestra_contacts/1
  # GET /orchestra_contacts/1.json
  def show
    @orchestra_contact = OrchestraContact.find(params[:id])
	@orchestra = Orchestra.find(params[:orchestra_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @orchestra_contact }
    end
  end

  # GET /orchestra_contacts/new
  # GET /orchestra_contacts/new.json
  def new
    @orchestra_contact = OrchestraContact.new

	@orchestra = Orchestra.find(params[:orchestra_id])
	@orchestra_contact.orchestra = @orchestra

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @orchestra_contact }
    end
  end

  # GET /orchestra_contacts/1/edit
  def edit
    @orchestra_contact = OrchestraContact.find(params[:id])
	@orchestra = Orchestra.find(params[:orchestra_id])
  end

  # POST /orchestra_contacts
  # POST /orchestra_contacts.json
  def create
    @orchestra_contact = OrchestraContact.new(params[:orchestra_contact])
	@orchestra_contact.orchestra_id= params[:orchestra_id]
	

    respond_to do |format|
      if @orchestra_contact.save
        format.html { redirect_to orchestra_orchestra_contacts_path(@orchestra), notice: t('orchestra_contact.title_s')+' '+t('common.create_success') }
        format.json { render json: @orchestra_contact, status: :created, location: @orchestra_contact }
      else
        format.html { render action: "new" }
        format.json { render json: @orchestra_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orchestra_contacts/1
  # PUT /orchestra_contacts/1.json
  def update
    @orchestra_contact = OrchestraContact.find(params[:id])
	@orchestra = Orchestra.find(params[:orchestra_id])

	@orchestra_contact.orchestra = @orchestra

    respond_to do |format|
      if @orchestra_contact.update_attributes(params[:orchestra_contact])
        format.html { redirect_to orchestra_orchestra_contact_path(@orchestra,@orchestra_contact), notice: t('orchestra_contact.title_s')+' '+t('common.update_success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @orchestra_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orchestra_contacts/1
  # DELETE /orchestra_contacts/1.json
  def destroy
    @orchestra_contact = OrchestraContact.find(params[:id])
    @orchestra_contact.destroy

    respond_to do |format|
      format.html { redirect_to orchestra_orchestra_contacts_url(params[:orchestra_id]) }
      format.json { head :no_content }
    end
  end

  #########################
  # PRIVATE METHODS
  #########################
  private 
  def sort_column
    OrchestraContact.column_names.include?(params[:sort]) ? params[:sort] : "last_name,first_name"
  end
end
