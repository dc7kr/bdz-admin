class FestivalApplicationAttachmentsController < ApplicationController
  # GET /festival_application_attachments
  # GET /festival_application_attachments.json
  def index
    @festival_application_attachments = FestivalApplicationAttachment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @festival_application_attachments }
    end
  end

  # GET /festival_application_attachments/1
  # GET /festival_application_attachments/1.json
  def show
    @festival_application_attachment = FestivalApplicationAttachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @festival_application_attachment }
    end
  end

  # GET /festival_application_attachments/new
  # GET /festival_application_attachments/new.json
  def new
    @festival_application_attachment = FestivalApplicationAttachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @festival_application_attachment }
    end
  end

  # GET /festival_application_attachments/1/edit
  def edit
    @festival_application_attachment = FestivalApplicationAttachment.find(params[:id])
  end

  # POST /festival_application_attachments
  # POST /festival_application_attachments.json
  def create
    @festival_application_attachment = FestivalApplicationAttachment.new(params[:festival_application_attachment])

    respond_to do |format|
      if @festival_application_attachment.save
        format.html do
          redirect_to @festival_application_attachment,
                      notice: "Festival application attachment was successfully created."
        end
        format.json do
          render json: @festival_application_attachment, status: :created, location: @festival_application_attachment
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @festival_application_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /festival_application_attachments/1
  # PUT /festival_application_attachments/1.json
  def update
    @festival_application_attachment = FestivalApplicationAttachment.find(params[:id])

    respond_to do |format|
      if @festival_application_attachment.update(params[:festival_application_attachment])
        format.html do
          redirect_to @festival_application_attachment,
                      notice: "Festival application attachment was successfully updated."
        end
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @festival_application_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /festival_application_attachments/1
  # DELETE /festival_application_attachments/1.json
  def destroy
    @festival_application_attachment = FestivalApplicationAttachment.find(params[:id])
    @festival_application_attachment.destroy

    respond_to do |format|
      format.html { redirect_to festival_application_attachments_url }
      format.json { head :no_content }
    end
  end
end
