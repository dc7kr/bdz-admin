class MagazineIssuesController < ApplicationController
  # GET /magazine_issues
  # GET /magazine_issues.json
  def index
    @magazine_issues = MagazineIssue.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @magazine_issues }
    end
  end

  # GET /magazine_issues/1
  # GET /magazine_issues/1.json
  def show
    @magazine_issue = MagazineIssue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @magazine_issue }
    end
  end

  # GET /magazine_issues/new
  # GET /magazine_issues/new.json
  def new
    @magazine_issue = MagazineIssue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @magazine_issue }
    end
  end

  # GET /magazine_issues/1/edit
  def edit
    @magazine_issue = MagazineIssue.find(params[:id])
  end

  # POST /magazine_issues
  # POST /magazine_issues.json
  def create
    @magazine_issue = MagazineIssue.new(params[:magazine_issue])

    respond_to do |format|
      if @magazine_issue.save
        format.html { redirect_to @magazine_issue, notice: 'Magazine issue was successfully created.' }
        format.json { render json: @magazine_issue, status: :created, location: @magazine_issue }
      else
        format.html { render action: "new" }
        format.json { render json: @magazine_issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /magazine_issues/1
  # PUT /magazine_issues/1.json
  def update
    @magazine_issue = MagazineIssue.find(params[:id])

    respond_to do |format|
      if @magazine_issue.update_attributes(params[:magazine_issue])
        format.html { redirect_to @magazine_issue, notice: 'Magazine issue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @magazine_issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /magazine_issues/1
  # DELETE /magazine_issues/1.json
  def destroy
    @magazine_issue = MagazineIssue.find(params[:id])
    @magazine_issue.destroy

    respond_to do |format|
      format.html { redirect_to magazine_issues_url }
      format.json { head :no_content }
    end
  end
end
