module Mgl
  class OrchestraMembersController < BaseController
    before_action :set_orchestra_member, only: %i[edit update destroy]

    def index
      authorize OrchestraMember
      @orchestra_members = policy_scope(OrchestraMember).order(:last_name, :first_name).page(params[:page]).per(50)
    end

    def new
      @orchestra_member = current_orchestra_members.build
      authorize @orchestra_member
    end

    def create
      @orchestra_member = current_orchestra_members.build(orchestra_member_params)
      authorize @orchestra_member

      if @orchestra_member.save
        redirect_to mgl_orchestra_members_path, notice: t("mgl.saved")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @orchestra_member.update(orchestra_member_params)
        redirect_to mgl_orchestra_members_path, notice: t("mgl.saved")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @orchestra_member.destroy
      redirect_to mgl_orchestra_members_path, notice: t("mgl.deleted"), status: :see_other
    end

    private

    def current_orchestra_members
      raise ActiveRecord::RecordNotFound if current_orchestra.nil?

      current_orchestra.orchestra_members
    end

    def set_orchestra_member
      @orchestra_member = policy_scope(OrchestraMember).find(params[:id])
      authorize @orchestra_member
    end

    def orchestra_member_params
      params.require(:orchestra_member).permit(:first_name, :last_name, :date_of_birth, :instrument)
    end
  end
end
