class OrchestraContactsController < AuthenticatedController
  include ApplicationHelper
  helper_method :sort_column, :sort_direction

  # GET /orchestra_contacts
  # GET /orchestra_contacts.json
  def index
    @orchestra = Orchestra.find(params[:orchestra_id])

    @orchestra_contacts = @orchestra.orchestra_contacts.order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)

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
    @orchestra_contact.country_code = "DE"

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
    @orchestra_contact = OrchestraContact.new(orchestra_contact_params)
    @orchestra = Orchestra.find(params[:orchestra_id])

    Rails.logger.info("Orchestra id: #{params[:orchestra_id]}")

    @orchestra_contact.orchestra = @orchestra

    respond_to do |format|
      if @orchestra_contact.save
        format.html do
          redirect_to orchestra_orchestra_contacts_path(@orchestra),
                      notice: "#{t('orchestra_contact.one')} #{t('common.create_success')}"
        end
        format.json { render json: @orchestra_contact, status: :created, location: @orchestra_contact }
      else
        Rails.logger.info(@orchestra_contact.errors)
        @orchestra_contact.errors.each do |attr, message|
          Rails.logger.info("#{attr}: #{message}")
        end
        format.html { render :new, status: :unprocessable_entity }
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
      if @orchestra_contact.update!(orchestra_contact_params)
        format.html do
          redirect_to orchestra_orchestra_contact_path(@orchestra, @orchestra_contact),
                      notice: t_update_success("orchestra_contact")
        end
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
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

  def orchestra_contact_params
    params.require(:orchestra_contact).permit(:role, :salutation, :first_name, :last_name, :street, :zip, :city, :country_code,
                                              :email, :phone)
  end
end
