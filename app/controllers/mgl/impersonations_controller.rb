module Mgl
  # Starts and stops the impersonation of an orchestra or person member by a
  # national user, see Mgl::Impersonation. Uses the main area policies, the member
  # area policies only apply once the member area is opened.
  class ImpersonationsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :destroy

    # POST /mgl/impersonation?entity_type=Orchestra&entity_id=1
    def create
      entity = find_entity
      authorize entity, :impersonate?

      start_impersonation(entity)
      redirect_to mgl_root_path, notice: t("mgl.impersonation.started", name: mgl_entity_name(entity))
    end

    # DELETE /mgl/impersonation
    def destroy
      entity = mgl_entity if impersonating?
      stop_impersonation

      if entity
        redirect_to entity, notice: t("mgl.impersonation.stopped")
      else
        redirect_to root_path
      end
    end

    private

    def find_entity
      type = params[:entity_type]
      raise ActiveRecord::RecordNotFound unless Impersonation::ENTITY_TYPES.include?(type)

      policy_scope(type.constantize).find(params[:entity_id])
    end
  end
end
