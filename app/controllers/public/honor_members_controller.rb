class Public::HonorMembersController < ApplicationController
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
end
