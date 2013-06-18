class BoardContactsController < AuthenticatedController
  helper_method :sort_column, :sort_direction
  # GET /board_contacts
  # GET /board_contacts.json
  def index
    @board_contacts = BoardContact.includes(:contact).search(params[:search]).order(sort_column+ " "+ sort_direction).page(params[:page]).per(20)

    respond_to do |format|
      format.html {
			if  ( @board_contacts.length == 1 ) then
				redirect_to @board_contacts[0]
			end
		}
			# index.html.erb
      format.json { render :json => @board_contacts}
	  format.js
    end
  end

  # GET /board_contacts/1
  # GET /board_contacts/1.json
  def show
    @board_contact = BoardContact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @board_contact }
    end
  end

  # GET /board_contacts/new
  # GET /board_contacts/new.json
  def new
    @board_contact = BoardContact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @board_contact }
    end
  end

  # GET /board_contacts/1/edit
  def edit
    @board_contact = BoardContact.find(params[:id])
  end

  # POST /board_contacts
  # POST /board_contacts.json
  def create
    @board_contact = BoardContact.new(params[:board_contact])

    respond_to do |format|
      if @board_contact.save
        format.html { redirect_to @board_contact, notice: 'Board contact was successfully created.' }
        format.json { render json: @board_contact, status: :created, location: @board_contact }
      else
        format.html { render action: "new" }
        format.json { render json: @board_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /board_contacts/1
  # PUT /board_contacts/1.json
  def update
    @board_contact = BoardContact.find(params[:id])

    respond_to do |format|
      if @board_contact.update_attributes(params[:board_contact])
        format.html { redirect_to @board_contact, notice: 'Board contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @board_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /board_contacts/1
  # DELETE /board_contacts/1.json
  def destroy
    @board_contact = BoardContact.find(params[:id])
    @board_contact.destroy

    respond_to do |format|
      format.html { redirect_to board_contacts_url }
      format.json { head :no_content }
    end
  end


  ## helpers ###

  private 
  def sort_column
    Contact.column_names.include?(params[:sort]) ? "members."+params[:sort] :
    BoardContact.column_names.include?(params[:sort]) ? params[:sort] : "contacts.last_name,contacts.first_name"
  end

end
