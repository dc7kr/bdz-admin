class MemberEventsController < AuthenticatedController
  helper_method :sort_column, :sort_direction

  before_action :set_member_entity, only: %i[index new create show edit update destroy]

  # GET /member_events
  # GET /member_events.json
  def index
    page = params[:page]

    @member_events = if @member_entity
                       MemberEvent.where("member_id=?", @member_entity.member.id).page(page).per(20)
    else
                       MemberEvent.all.page(page).per(20)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @member_events }
      format.js
      format.js
    end
  end

  # GET /member_events/1
  # GET /member_events/1.json
  def show
    @member_event = MemberEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member_event }
    end
  end

  # GET /member_events/new
  # GET /member_events/new.json
  def new
    @member_event = MemberEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @member_event }
    end
  end

  # GET /member_events/1/edit
  def edit
    @member_event = MemberEvent.find(params[:id])

    @basemember = @member_event.member

    @member = @basemember.member_entity

    return unless @member.is_a? Orchestra

    @isOrchestra = true
  end

  # POST /member_events
  # POST /member_events.json
  def create
    @member_event = MemberEvent.new(member_event_params)

    respond_to do |format|
      if @member_event.save
        format.html { redirect_to @member_event, notice: "Member event was successfully created." }
        format.json { render json: @member_event, status: :created, location: @member_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /member_events/1
  # PUT /member_events/1.json
  def update
    @member_event = MemberEvent.find(params[:id])

    respond_to do |format|
      if @member_event.update!(member_event_params)
        format.html { redirect_to @member_event, notice: "Member event was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /member_events/1
  # DELETE /member_events/1.json
  def destroy
    @return_path = ""
    if params[:orchestra_id]
      @return_path = orchestra_member_events_path(params[:orchestra_id])
    elsif params[:person_member_id]
      @return_path = person_member_member_events_path(params[:person_member_id])
    end

    @member_event = MemberEvent.find(params[:id])
    @member_event.destroy

    respond_to do |format|
      format.html { redirect_to @return_path }
      format.json { render json: { status: "ok", op: "delete", entityId: @member_event.id } }
    end
  end

  def download
    @event = MemberEvent.find(params[:id])
    fullPath = "#{INVOICE_CONFIG.archive_dir}/#{@event.filename}"
    send_file(fullPath, filename: File.basename(@event.filename), type: "application/pdf", x_sendfile: true)
  end

  def sort_column
    MemberEvent.column_names.include?(params[:sort]) ? params[:sort] : "event_date"
  end

  private

  def member_event_params
    params.require(:member_event).permit(:event_type, :event_date, :event_id, :comment, :member_id)
  end

  def set_member_entity
    if params[:orchestra_id]
      @member_entity = Orchestra.includes(:member).find(params[:orchestra_id])
      @orchestra = @member_entity
      @name = @member_entity.orchName
      @isOrchestra = true
    elsif params[:person_member_id]
      @member_entity = PersonMember.includes(:member).find(params[:person_member_id])
      @name = @member_entity.fullname
      @isOrchestra = false
    end
  end
end
