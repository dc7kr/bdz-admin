module Mgl
  class OrchestrasController < BaseController
    include MemberParams

    before_action :set_orchestra

    def show
    end

    def edit
    end

    def update
      @orchestra.assign_attributes(orchestra_params)
      @member.assign_attributes(member_params)

      if save_with_member(@orchestra)
        redirect_to mgl_orchestra_path, notice: t("mgl.saved")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_orchestra
      @orchestra = current_orchestra
      raise ActiveRecord::RecordNotFound if @orchestra.nil?

      authorize @orchestra
      @member = @orchestra.member
    end

    def orchestra_params
      params.require(:orchestra).permit(:orchName, :url, :gruendung, :publish_url, :publish_address)
    end
  end
end
