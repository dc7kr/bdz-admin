class MagazineSamplingsController < ApplicationController
  # GET /magazine_samplings
  # GET /magazine_samplings.json
  def index
    @magazine_samplings = MagazineSampling.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @magazine_samplings }
    end
  end

  # GET /magazine_samplings/1
  # GET /magazine_samplings/1.json
  def show
    @magazine_sampling = MagazineSampling.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @magazine_sampling }
    end
  end

  # GET /magazine_samplings/new
  # GET /magazine_samplings/new.json
  def new
    @magazine_sampling = MagazineSampling.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @magazine_sampling }
    end
  end

  # GET /magazine_samplings/1/edit
  def edit
    @magazine_sampling = MagazineSampling.find(params[:id])
  end

  # POST /magazine_samplings
  # POST /magazine_samplings.json
  def create
    @magazine_sampling = MagazineSampling.new(params[:magazine_sampling])

    respond_to do |format|
      if @magazine_sampling.save
        format.html { redirect_to @magazine_sampling, notice: 'Magazine sampling was successfully created.' }
        format.json { render json: @magazine_sampling, status: :created, location: @magazine_sampling }
      else
        format.html { render action: "new" }
        format.json { render json: @magazine_sampling.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /magazine_samplings/1
  # PUT /magazine_samplings/1.json
  def update
    @magazine_sampling = MagazineSampling.find(params[:id])

    respond_to do |format|
      if @magazine_sampling.update_attributes(params[:magazine_sampling])
        format.html { redirect_to @magazine_sampling, notice: 'Magazine sampling was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @magazine_sampling.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /magazine_samplings/1
  # DELETE /magazine_samplings/1.json
  def destroy
    @magazine_sampling = MagazineSampling.find(params[:id])
    @magazine_sampling.destroy

    respond_to do |format|
      format.html { redirect_to magazine_samplings_url }
      format.json { head :no_content }
    end
  end
end
