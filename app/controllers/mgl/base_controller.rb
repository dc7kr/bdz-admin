module Mgl
  # Base controller of the member area. Only signed in orchestra and person member
  # users (User#member_level?) and national users impersonating a member
  # (Mgl::Impersonation) get here, and everything they see is limited to that
  # entity by the policies in app/policies/mgl.
  class BaseController < ApplicationController
    layout "mgl"

    protect_from_forgery

    include Pundit::Authorization

    before_action :authenticate_user!
    before_action :require_member_level_user

    after_action :verify_pundit_authorization

    helper_method :current_entity, :current_member

    rescue_from Pundit::NotAuthorizedError do |exception|
      Rails.logger.warn(exception.message)

      flash[:error] = t("mgl.not_authorized")
      redirect_to mgl_root_path
    end

    protected

    # Orchestra or PersonMember the signed in user acts for
    def current_entity
      mgl_entity
    end

    # Member record (mglnr, contact and payment data) of the current entity
    def current_member
      current_entity.member
    end

    def current_orchestra
      current_entity if current_entity.is_a?(Orchestra)
    end

    def pundit_user
      MemberContext.new(user: current_user, entity: current_entity, impersonating: impersonating?)
    end

    # Mgl:: policies are looked up for all records
    def policy_scope(scope, **options)
      super([ :mgl, scope ], **options)
    end

    def authorize(record, query = nil, **options)
      super([ :mgl, record ], query, **options)
    end

    def verify_pundit_authorization
      if index_actions.include? action_name.to_sym
        verify_policy_scoped
      else
        verify_authorized
      end
    end

    def index_actions
      [ :index ]
    end

    private

    def require_member_level_user
      if impersonating?
        return if current_entity&.member.present?

        stop_impersonation
        redirect_to root_path, flash: { error: t("mgl.impersonation.missing_entity") }
        return
      end

      unless current_user.member_level?
        flash[:error] = t("mgl.member_users_only")
        redirect_to root_path
        return
      end
      return if current_entity&.member.present?

      # member user whose orchestra / person member is gone: the main area is
      # off limits as well, so the only way out is to sign out
      Rails.logger.warn("User #{current_user.id} references a missing #{current_user.entity_class} #{current_user.entity_id}")
      sign_out current_user
      redirect_to new_user_session_path, flash: { error: t("mgl.missing_entity") }
    end
  end
end
