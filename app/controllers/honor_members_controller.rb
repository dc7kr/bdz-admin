class HonorMembersController < ApplicationController
  load_and_authorize_resource
  # GET /honor_members
  # GET /honor_members.json
  def index
    @honor_members = HonorMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @honor_members }
    end
  end

  # GET /honor_members/1
  # GET /honor_members/1.json
  def show
    @honor_member = HonorMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @honor_member }
    end
  end

  # GET /honor_members/new
  # GET /honor_members/new.json
  def new
    @honor_member = HonorMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @honor_member }
    end
  end

  # GET /honor_members/1/edit
  def edit
    @honor_member = HonorMember.find(params[:id])
  end

  # POST /honor_members
  # POST /honor_members.json
  def create
    @honor_member = HonorMember.new(params[:honor_member])

    respond_to do |format|
      if @honor_member.save
        format.html { redirect_to @honor_member, notice: 'Honor member was successfully created.' }
        format.json { render json: @honor_member, status: :created, location: @honor_member }
      else
        format.html { render action: "new" }
        format.json { render json: @honor_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /honor_members/1
  # PUT /honor_members/1.json
  def update
    @honor_member = HonorMember.find(params[:id])

    respond_to do |format|
      if @honor_member.update_attributes(params[:honor_member])
        format.html { redirect_to @honor_member, notice: 'Honor member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @honor_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /honor_members/1
  # DELETE /honor_members/1.json
  def destroy
    @honor_member = HonorMember.find(params[:id])
    @honor_member.destroy

    respond_to do |format|
      format.html { redirect_to honor_members_url }
      format.json { head :no_content }
    end
  end
end
