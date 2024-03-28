class Public::CompetitionEntriesController < Public::ApplicationController

  def drawing

  end

  # GET /competition_entries/participate
  # GET /competition_entries/new.json
  def participate
    @competition_entry = CompetitionEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @competition_entry }
    end
  end


  def success
    @competition_entry = CompetitionEntry.find(params[:id])
  end
  # POST /competition_entries
  # POST /competition_entries.json
  def create
    @competition_entry = CompetitionEntry.new(params[:competition_entry])

    correct = @competition_entry.check_responses

    @competition_entry.correct=correct

    respond_to do |format|
      if @competition_entry.save
        format.html { redirect_to success_public_competition_entry_path(@competition_entry), notice: 'CompetitionEntry was successfully created.' }
        format.json { render json: @competition_entry, status: :created, location: @competition_entry }
      else
        format.html { render action: "participate" }
        format.json { render json: @competition_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /competition_entries/1
  # PUT /competition_entries/1.json
  def update
    @competition_entry = CompetitionEntry.find(params[:id])

    respond_to do |format|
      if @competition_entry.update(params[:competition])
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
      format.json { head :no_content }
    end
  end
end
