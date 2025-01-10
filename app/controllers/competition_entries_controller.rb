class CompetitionEntriesController < AuthenticatedController
  # GET /competition_entries
  # GET /competition_entries.json
  def index
    @competition_entries = CompetitionEntry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @competition_entries }
    end
  end

  # GET /competition_entries/1
  # GET /competition_entries/1.json
  def show
    @competition_entry = CompetitionEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @competition_entry }
    end
  end

  def winner
    @competition_entry = CompetitionEntry.find(params[:id])

    @competition_entry.winner = true
    respond_to do |format|
      if @competition_entry.save
        format.json { render json: @competition_entry }
      else
        format.json { render json: @competition_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def drawable
    @drawable = CompetitionEntry.where('winner = false and correct=true')

    drawable_ids = []

    @drawable.each do |d|
      drawable_ids << d.id
    end

    respond_to do |format|
      format.json { render json: drawable_ids }
    end
  end

  def drawing; end

  # GET /competition_entries/1/edit
  def edit
    @competition_entry = CompetitionEntry.find(params[:id])
  end

  # POST /competition_entries
  # POST /competition_entries.json
  def create
    @competition_entry = CompetitionEntry.new(params[:competition_entry])

    @competition_entry.correct = if @competition_entry.check_responses
                                   false
                                 else
                                   true
                                 end

    respond_to do |format|
      if @competition_entry.save
        format.html do
          redirect_to success_public_competition_entry(@competition_entry),
                      notice: 'CompetitionEntry was successfully created.'
        end
        format.json { render json: @competition_entry, status: :created, location: @competition_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @competition_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /competition_entries/1
  # PUT /competition_entries/1.json
  def update
    @competition_entry = CompetitionEntry.find(params[:id])

    @competition_entry.check_responses

    respond_to do |format|
      if @competition_entry.update(params[:competition_entry])
        format.html { redirect_to @competition_entry, notice: 'CompetitionEntry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @competition_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competition_entries/1
  # DELETE /competition_entries/1.json
  def destroy
    @competition_entry = CompetitionEntry.find(params[:id])
    @competition_entry.destroy

    respond_to do |format|
      format.html { redirect_to competition_entries_url }
      format.json { render json: { status: 'ok', op: 'delete', entityId: @competition_entry.id } }
    end
  end
end
