module Mgl
  class OrchestraContactsController < BaseController
    before_action :set_orchestra_contact, only: %i[edit update destroy]

    def index
      authorize OrchestraContact
      @orchestra_contacts = policy_scope(OrchestraContact).order(:role, :last_name)
    end

    def new
      @orchestra_contact = current_orchestra_contacts.build(country_code: "DE")
      authorize @orchestra_contact
    end

    def create
      @orchestra_contact = current_orchestra_contacts.build(orchestra_contact_params)
      authorize @orchestra_contact

      if @orchestra_contact.save
        redirect_to mgl_orchestra_contacts_path, notice: t("mgl.saved")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @orchestra_contact.update(orchestra_contact_params)
        redirect_to mgl_orchestra_contacts_path, notice: t("mgl.saved")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @orchestra_contact.destroy
      redirect_to mgl_orchestra_contacts_path, notice: t("mgl.deleted"), status: :see_other
    end

    private

    def current_orchestra_contacts
      raise ActiveRecord::RecordNotFound if current_orchestra.nil?

      current_orchestra.orchestra_contacts
    end

    def set_orchestra_contact
      @orchestra_contact = policy_scope(OrchestraContact).find(params[:id])
      authorize @orchestra_contact
    end

    def orchestra_contact_params
      params.require(:orchestra_contact).permit(OrchestraContact.permitted_params)
    end
  end
end
