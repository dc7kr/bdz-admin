class Public::ContestsController < ApplicationController
  layout :choose_layout
  helper_method :sort_column, :sort_direction

  def index
    @contests = Contest.published.search(params[:search]).order(sort_column + ' ' + sort_direction).page(params[:page]).per(20)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contests }
    end
  end

  # GET /contests/1
  # GET /contests/1.json
  def show
    @contest = Contest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contest }
    end
  end

  # GET /contests/new
  # GET /contests/new.json
  def new
    @contest = Contest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contest }
    end
  end

  # POST /contests
  # POST /contests.json
  def create
    @contest = Contest.new(contest_params)

    respond_to do |format|
      if @contest.save
        format.html { redirect_to @contest, notice: 'Contest was successfully created.' }
        format.json { render json: @contest, status: :created, location: @contest }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  def sort_column
    Contest.column_names.include?(params[:sort]) ? params[:sort] : 'startDate'
  end

  def contest_params
    params.require(:contest).permit(:startdate, :enddate, :titel, :beschreibung, :gebuehr, :preis, :anmeldung,
                                    :deadline, :email, :reported, :confirmed, :visible)
  end
end
