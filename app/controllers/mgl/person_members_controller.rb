module Mgl
  class PersonMembersController < BaseController
    include MemberParams

    before_action :set_person_member

    def show
    end

    def edit
    end

    def update
      @person_member.assign_attributes(person_member_params)
      @member.assign_attributes(member_params)

      if save_with_member(@person_member)
        redirect_to mgl_person_member_path, notice: t("mgl.saved")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_person_member
      @person_member = current_entity if current_entity.is_a?(PersonMember)
      raise ActiveRecord::RecordNotFound if @person_member.nil?

      authorize @person_member
      @member = @person_member.member
    end

    def person_member_params
      params.require(:person_member).permit(:geburtstag, :telefonDienstl)
    end
  end
end
