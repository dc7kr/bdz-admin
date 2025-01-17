class FestivalPiecesController < AuthenticatedController
  respond_to :html, :js
  # GET /festival_pieces
  # GET /festival_pieces.json
  def index
    if params[:festival_application_token].nil?
      @festival_pieces = FestivalPiece.all
    else
      @festival_application = FestivalApplication.find_by(token: params[:festival_application_token])
      @festival_pieces = @festival_application.festival_pieces
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @festival_pieces }
    end
  end

  # GET /festival_pieces/1
  # GET /festival_pieces/1.json
  def show
    @festival_application = FestivalApplication.find_by(token: params[:festival_application_token])
    @festival_piece = FestivalPiece.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @festival_piece }
    end
  end

  # GET /festival_pieces/new
  # GET /festival_pieces/new.json
  def new
    @festival_application = FestivalApplication.find_by(token: params[:festival_application_token])
    @festival_piece = FestivalPiece.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @festival_piece }
    end
  end

  # GET /festival_pieces/1/edit
  def edit
    @festival_application = FestivalApplication.find_by(token: params[:festival_application_token])
    @festival_piece = FestivalPiece.find(params[:id])
  end

  # POST /festival_pieces
  # POST /festival_pieces.json
  def create
    @festival_application = FestivalApplication.find_by(token: params[:festival_application_token])
    @festival_piece = FestivalPiece.new(festival_piece_params)
    @festival_application.festival_pieces << @festival_piece
    @festival_piece.save

    logger.debug('New piece: ' + @festival_piece.id.to_s)

    respond_with @festival_piece, location: festival_application_festival_pieces_url(@festival_application)
  end

  # PUT /festival_pieces/1
  # PUT /festival_pieces/1.json
  def update
    @festival_application = FestivalApplication.find_by(token: params[:festival_application_token])
    @festival_piece = FestivalPiece.find(params[:id])

    respond_to do |format|
      if @festival_piece.update(festival_piece_params)
        format.html do
          redirect_to festival_application_festival_piece_url(@festival_application, @festival_piece),
                        notice: t_update_success("festival_piece")
        end
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @festival_piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /festival_pieces/1
  # DELETE /festival_pieces/1.json
  def destroy
    @festival_application = FestivalApplication.find_by(token: params[:festival_application_token])
    @festival_piece = FestivalPiece.find(params[:id])
    @festival_piece.destroy

    respond_with @festival_piece, location: festival_application_festival_pieces_url(@festival_application)
  end

  private

  def festival_piece_params
    params.require(:festival_piece).permit(
      :composer,
      :title,
      :duration
    )
  end
end
