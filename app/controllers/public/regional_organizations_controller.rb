module Public
  class RegionalOrganizationsController < ApplicationController
    before_action :set_regional_organization, only: [:show]

    def index
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @regional_organizations }
      end
    end

    # GET /regional_organizations/1
    # GET /regional_organizations/1.json
    def show
      @functions = Function.includes(:board_contact).where(regional_organization_id: @regional_organization.id)

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @regional_organization }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_regional_organization
      @regional_organization = RegionalOrganization.find(params[:id])
    end
  end
end
