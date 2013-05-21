class FestivalPiecesController < AuthenticatedController
	respond_to :html,:js
  # GET /festival_pieces
  # GET /festival_pieces.json
  def index
	@festival_application = FestivalApplication.find(params[:festival_application_id])
    @festival_pieces = @festival_application.festival_pieces

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @festival_pieces }
    end
  end

  # GET /festival_pieces/1
  # GET /festival_pieces/1.json
  def show
	@festival_application = FestivalApplication.find(params[:festival_application_id])
    @festival_piece = FestivalPiece.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @festival_piece }
    end
  end

  # GET /festival_pieces/new
  # GET /festival_pieces/new.json
  def new
	@festival_application = FestivalApplication.find(params[:festival_application_id])
    @festival_piece = FestivalPiece.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @festival_piece }
    end
  end

  # GET /festival_pieces/1/edit
  def edit
	@festival_application = FestivalApplication.find(params[:festival_application_id])
    @festival_piece = FestivalPiece.find(params[:id])
  end

  # POST /festival_pieces
  # POST /festival_pieces.json
  def create
  	@festival_application = FestivalApplication.find(params[:festival_application_id])
    @festival_piece = @festival_application.festival_pieces.create(params[:festival_piece])

	logger.debug("New piece: "+@festival_piece.id.to_s)

    respond_with @festival_piece, :location => festival_application_festival_pieces_url(@festival_application)
  end

  # PUT /festival_pieces/1
  # PUT /festival_pieces/1.json
  def update
	@festival_application = FestivalApplication.find(params[:festival_application_id])
    @festival_piece = FestivalPiece.find(params[:id])

    respond_to do |format|
      if @festival_piece.update_attributes(params[:festival_piece])
        format.html { redirect_to festival_application_festival_piece_url(@festival_application,@festival_piece), notice: t('festival_piece.update_success') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @festival_piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /festival_pieces/1
  # DELETE /festival_pieces/1.json
  def destroy
    @festival_application = FestivalApplication.find(params[:festival_application_id])
    @festival_piece = FestivalPiece.find(params[:id])
    @festival_piece.destroy

    respond_with @festival_piece, :location => festival_application_festival_pieces_url(@festival_application)
  end
end
