class PersonMembersController < ApplicationController
  before_filter :authenticate_user!, :except => [:some_action_without_auth]
  load_and_authorize_resource
  # GET /person_members
  # GET /person_members.json
  def index
    @person_members = PersonMember.order(:mitgliedsnummer).find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @person_members }
    end
  end

  # GET /person_members/1
  # GET /person_members/1.json
  def show
    @person_member = PersonMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @person_member }
    end
  end

  # GET /person_members/new
  # GET /person_members/new.json
  def new
    @person_member = PersonMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @person_member }
    end
  end

  # GET /person_members/1/edit
  def edit
    @person_member = PersonMember.find(params[:id])
  end

  # POST /person_members
  # POST /person_members.json
  def create
    @person_member = PersonMember.new(params[:person_member])

    respond_to do |format|
      if @person_member.save
        format.html { redirect_to @person_member, :notice => 'Person member was successfully created.' }
        format.json { render :json => @person_member, :status => :created, :location => @person_member }
      else
        format.html { render :action => "new" }
        format.json { render :json => @person_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /person_members/1
  # PUT /person_members/1.json
  def update
    @person_member = PersonMember.find(params[:id])

    respond_to do |format|
      if @person_member.update_attributes(params[:person_member])
        format.html { redirect_to @person_member, :notice => 'Person member was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @person_member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /person_members/1
  # DELETE /person_members/1.json
  def destroy
    @person_member = PersonMember.find(params[:id])
    @person_member.destroy

    respond_to do |format|
      format.html { redirect_to person_members_url }
      format.json { head :ok }
    end
  end
end
