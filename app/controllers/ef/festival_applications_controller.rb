class Ef::FestivalApplicationsController < Ef::ApplicationController
  #  include ApplicationHelper
  helper ApplicationHelper

  def show
    @festival_application = FestivalApplication.find_by token: params[:token]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @festival_application }
    end
  end

  def finalize
    @festival_application = FestivalApplication.find_by token: params[:token]
  end

  def closed; end

  # GET /festival_applications/new
  # GET /festival_applications/new.json
  def new
    @festival_application = FestivalApplication.new
    @festival_application.group_type = 'O'
    @festival_application.country_code = 'DE'
    @festival_application.contact_person = ContactPerson.new
    @festival_application.contact_person.country_code = 'DE'

    closed = BDZ_SETTINGS['config']['festival_application_open']

    respond_to do |format|
      format.html do
        if !closed and current_user.nil?
          Rails.logger.info("Festival application closed: #{closed} #{current_user.nil?}")
          redirect_to(closed_ef_festival_applications_path, notice: 'Festival application is currently closed.')
        end
      end
      format.json { render json: @festival_application }
    end
  end

  # GET /festival_applications/1/edit
  def edit
    @festival_application = FestivalApplication.find_by token: params[:token]
  end

  # POST /festival_applications
  # POST /festival_applications.json
  def create
    fa_params = festival_application_params

    cp_params = fa_params[:contact_person]
    fa_params[:contact_person] = nil

    @festival_application = FestivalApplication.new(fa_params)
    @festival_application.year = BDZ_SETTINGS['config']['festival_year']

    Rails.logger.debug('Festival application contact person')
    Rails.logger.debug(cp_params.to_json)

    contact_person = ContactPerson.new(cp_params)
    @festival_application.contact_person = contact_person
    @festival_application.token = SecureRandom.uuid

    if @festival_application.contact_person.save
      respond_to do |format|
        if @festival_application.save
          format.html do
            redirect_to step2_ef_festival_application_path(@festival_application),
                        notice: t('festival_application.create_success')
          end
          format.json { render json: @festival_application, status: :created, location: @festival_application }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @festival_application.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact_person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /festival_applications/1
  # PUT /festival_applications/1.json
  def update
    @festival_application = FestivalApplication.find_by params[:token]

    respond_to do |format|
      if @festival_application.update(params[:festival_application])
        format.html { redirect_to @festival_application, 
                      notice: t_update_success("festival_application")
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @festival_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /festival_applications/1
  # DELETE /festival_applications/1.json
  def destroy
    @festival_application = FestivalApplication.find(params[:id])
    @festival_application.destroy

    respond_to do |format|
      format.html { redirect_to festival_applications_url }
      format.json { head :no_content }
      format.js { render layout: false }
    end
  end

  def step2
    @festival_application = FestivalApplication.find_by token: params[:token]
    @festival_pieces = @festival_application.festival_pieces
  end

  private

  def festival_application_params
    params.require(:festival_application).permit(
      :group_type,
      :country_code,
      :conductor,
      :special_cast,
      :workshop_request,
      :orch_name,
      :equipment,
      :num_players,
      contact_person: ContactPerson.nested_params
    )
  end

  def contact_person_params
    my_params = params.require(:festival_application).permit(contact_person: ContactPerson.nested_params)
    my_params[:contact_person]
  end
end
