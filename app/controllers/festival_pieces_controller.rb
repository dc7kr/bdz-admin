class FestivalPiecesController < ApplicationController
  # GET /festival_pieces
  # GET /festival_pieces.json
  def index
    @festival_pieces = FestivalPiece.all

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
    @festival_piece = FestivalPiece.new(params[:festival_piece])

    respond_to do |format|
      if @festival_piece.save
        format.html { redirect_to @festival_piece, notice: 'Festival piece was successfully created.' }
        format.json { render json: @festival_piece, status: :created, location: @festival_piece }
      else
        format.html { render action: "new" }
        format.json { render json: @festival_piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /festival_pieces/1
  # PUT /festival_pieces/1.json
  def update
    @festival_piece = FestivalPiece.find(params[:id])

    respond_to do |format|
      if @festival_piece.update_attributes(params[:festival_piece])
        format.html { redirect_to @festival_piece, notice: 'Festival piece was successfully updated.' }
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
    @festival_piece = FestivalPiece.find(params[:id])
    @festival_piece.destroy

    respond_to do |format|
      format.html { redirect_to festival_pieces_url }
      format.json { head :no_content }
    end
  end
end
