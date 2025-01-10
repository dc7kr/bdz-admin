class Ef::FestivalPiecesController < Ef::ApplicationController
  respond_to :html, :js

  helper ApplicationHelper
  # GET /festival_pieces
  # GET /festival_pieces.json
  def index
    @festival_application = FestivalApplication.find_by token: params[:festival_application_token]
    @festival_pieces = @festival_application.festival_pieces

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @festival_pieces }
    end
  end

  # GET /festival_pieces/1
  # GET /festival_pieces/1.json
  def show
    @festival_piece = FestivalPiece.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @festival_piece }
    end
  end

  # GET /festival_pieces/new
  # GET /festival_pieces/new.json
  def new
    @festival_piece = FestivalPiece.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @festival_piece }
    end
  end

  # GET /festival_pieces/1/edit
  def edit
    @festival_piece = FestivalPiece.find(params[:id])
  end

  # POST /festival_pieces
  # POST /festival_pieces.json
  def create
    @festival_application = FestivalApplication.find_by token: params[:festival_application_token]

    @festival_piece = FestivalPiece.new(festival_piece_params)

    @festival_application.festival_pieces << @festival_piece

    respond_to do |format|
      if @festival_piece.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:new_piece, partial: 'ef/festival_applications/step2_form',
                                            locals: { festival_piece: FestivalPiece.new }),
            turbo_stream.append(:festival_pieces, @festival_piece)
          ]
        end
        format.html do
          redirect_to step2_ef_festival_application_path(@festival_application),
                      notice: t('festival_piece.create_success')
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:new_piece, partial: 'festival_applications/form', locals: { note: @note })
          ]
        end
        format.html { render :new, status: :unprocessable_entity }
      end

      # @festival_piece = @festival_application.festival_pieces.create(festival_piece_params)
      # logger.debug("New piece: "+@festival_piece.id.to_s)
      # respond_with @festival_piece, :location => festival_application_festival_pieces_url(@festival_application,@festival_application.festival_pieces)
    end
  end

  # PUT /festival_pieces/1
  # PUT /festival_pieces/1.json
  def update
    @festival_piece = FestivalPiece.find(params[:id])

    respond_to do |format|
      if @festival_piece.update(params[:festival_piece])
        format.html { redirect_to @festival_piece, notice: 'Festival piece was successfully updated.' }
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
    @festival_application = FestivalApplication.find_by token: params[:festival_application_token]
    @festival_piece = FestivalPiece.find(params[:id])
    respond_to do |format|
      if @festival_piece.destroy
        @festival_pieces = @festival_application.festival_pieces
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@festival_piece),
            turbo_stream.update(:new_piece, partial: 'ef/festival_applications/step2_form',
                                            locals: { festival_piece: FestivalPiece.new })
          ]
        end
        format.html do
          redirect_to step2_ef_festival_application_path(@festival_application),
                      notice: t('festival_piece.delete_success')
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:new_piece, partial: 'festival_applications/step2_form',
                                            locals: { piece: @festival_piece })
          ]
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def festival_piece_params
    params.require(:festival_piece).permit(:composer, :title, :duration)
  end
end
