module Mgl
  # Staff invites an orchestra or person member to the member area: the member
  # gets a mail with a link to set the password. Members without an email
  # address get a one-time link that the office hands over.
  class InvitationsController < AuthenticatedController
    # POST /mgl/invitation?entity_type=Orchestra&entity_id=1
    def create
      @entity = find_entity
      authorize @entity, :invite?

      @member = @entity.member
      unless @member&.active_for_authentication?
        redirect_to @entity, alert: t("mgl.invitation.inactive")
        return
      end

      if @member.has_email?
        @member.send_reset_password_instructions
        Rails.logger.info("User #{current_user.id} invited member #{@member.mglnr} to the member area")
        redirect_to @entity, notice: t("mgl.invitation.sent", email: @member.email)
      else
        @link = edit_member_password_url(reset_password_token: @member.member_area_invite_token)
        Rails.logger.info("User #{current_user.id} created an invitation link for member #{@member.mglnr}")
        render :show
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
