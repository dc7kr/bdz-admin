module Public
  class CoursesController < ApplicationController
    layout :choose_layout
    helper_method :sort_column, :sort_direction

    def future
      @courses = Course.future
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @courses }
      end
    end

    def inactive
      @courses = Course.inactive
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @courses }
      end
    end

    # GET /courses
    # GET /courses.json
    def public
      @courses = Course.published

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @courses }
      end
    end

    def index
      @courses = Course.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @courses }
      end
    end

    # GET /courses/1
    # GET /courses/1.json
    def show
      @course = Course.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @course }
      end
    end

    # GET /courses/new
    # GET /courses/new.json
    def new
      @course = Course.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @course }
      end
    end

    # GET /courses/1/edit
    def edit
      @course = Course.find(params[:id])
    end

    # POST /courses
    # POST /courses.json
    def create
      @course = Course.new(course_params)

      @course.bland = 1 if @course.bland.nil?

      @course.ort = 'Barmingholtener Vereinshaus, Sterkrader Str. 14,46539 Dinslaken' if @course.ort.nil?

      respond_to do |format|
        if @course.save
          format.html { redirect_to @course, notice: 'Course was successfully created.' }
          format.json { render json: @course, status: :created, location: @course }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /courses/1
    # PUT /courses/1.json
    def update
      @course = Course.find(params[:id])

      respond_to do |format|
        if @course.update(course_params)
          format.html { redirect_to @course, notice: 'Course was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    end

    def course_params
      params.require(:course).permit(:startdate, :enddate, :bland, :fk_festival, :more_dates, :titel, :ort,
                                     :beschreibung, :inhalt, :gebuehr, :zielgruppe, :dozenten, :anmeldung, :deadline, :email, :country_code)
    end
  end
end
