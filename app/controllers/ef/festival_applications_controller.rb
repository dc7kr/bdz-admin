module Ef
  class FestivalApplicationsController < Ef::ApplicationController
    #  include ApplicationHelper
    helper ApplicationHelper
    helper FestivalPiecesHelper

    before_action :set_festival_application, only: %i[show edit update finalize step2 ticket_invoice fee_invoice]

    def show
      respond_to do |format|
        format.html # show.html.erb
        format.turbo_stream
        format.json { render json: @festival_application }
      end
    end

    def finalize
      @festival_application = FestivalApplication.find_by token: params[:token]

      if @festival_application.confirmed
        FestivalApplicationMailer.confirm_update(@festival_application.token).deliver
      else
        FestivalApplicationMailer.confirm_create(@festival_application.token).deliver
        @festival_application.confirmed = true
        @festival_application.save!
      end
    end

    def fee_invoice
      invoice = CorikaInvoices::Invoice.find(@festival_application.fee_invoice_id)
      invoice_file = CorikaInvoices::ArchiveFile.new(invoice.pdf_filename, invoice.pdf_filename, invoice.booking_year.to_s)
      send_file(invoice_file.full_path, filename: invoice_file.orig_filename, type: "application/octet-stream")
    end

    def ticket_invoice
      invoice = CorikaInvoices::Invoice.find(@festival_application.ticket_invoice_id)
    end

    def closed; end

    # GET /festival_applications/new
    # GET /festival_applications/new.json
    def new
      @festival_application = FestivalApplication.new
      @festival_application.group_type = "O"
      @festival_application.country_code = "DE"
      @festival_application.contact_person = ContactPerson.new
      @festival_application.contact_person.country_code = "DE"

      closed = BDZ_SETTINGS["config"]["festival_application_open"]

      respond_to do |format|
        format.html do
          if !closed && current_user.nil?
            Rails.logger.info("Festival application closed: #{closed} #{current_user.nil?}")
            redirect_to(closed_ef_festival_applications_path, notice: "Festival application is currently closed.")
          end
        end
        format.json { render json: @festival_application }
      end
    end

    # GET /festival_applications/1/edit
    def edit
    end

    # POST /festival_applications
    # POST /festival_applications.json
    def create
      fa_params = festival_application_params

      cp_params = fa_params[:contact_person]
      fa_params[:contact_person] = nil

      @festival_application = FestivalApplication.new(fa_params)
      @festival_application.year = BDZ_SETTINGS["config"]["festival_year"]

      Rails.logger.debug("Festival application contact person")
      Rails.logger.debug(cp_params.to_json)

      contact_person = ContactPerson.new(cp_params)
      @festival_application.contact_person = contact_person
      @festival_application.token = SecureRandom.uuid

      if @festival_application.contact_person.save
        respond_to do |format|
          if @festival_application.save
            format.html do
              redirect_to step2_ef_festival_application_path(@festival_application),
                          notice: t("festival_application.create_success")
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
      @contact_person = @festival_application.contact_person

      fa_params = festival_application_params

      cp_params = fa_params[:contact_person]
      fa_params[:contact_person] = @contact_person

      respond_to do |format|
        if !@contact_person.update(cp_params)
          format.html do
            render :edit, status: :unprocessable_entity
          end
        elsif @festival_application.update(fa_params)
          FestivalApplicationMailer.confirm_update(@festival_application.token).deliver
          format.html do
            redirect_to @festival_application, notice: t_update_success("festival_application")
          end
          format.json { head :no_content }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @festival_application.errors, status: :unprocessable_entity }
        end
      end
    end

    def step2
      @festival_pieces = @festival_application.festival_pieces
    end

    private
    def set_festival_application
      @festival_application = FestivalApplication.find_by token: params[:token]
    end

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
        :comment,
        :tickets,
        :tickets_red,
        :soloist_tickets,
        contact_person: ContactPerson.nested_params
      )
    end

    def contact_person_params
      my_params = params.require(:festival_application).permit(contact_person: ContactPerson.nested_params)
      my_params[:contact_person]
    end
  end
end
