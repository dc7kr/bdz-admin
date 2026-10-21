module Mgl
  # Base controller of the member area. Only signed in orchestras and person
  # members (Member, devise scope :member) and national users impersonating a
  # member (Mgl::Impersonation) get here, and everything they see is limited to that
  # entity by the policies in app/policies/mgl.
  class BaseController < ApplicationController
    layout "mgl"

    protect_from_forgery

    include Pundit::Authorization

    before_action :authenticate_member_or_impersonating_user!
    before_action :require_active_entity

    after_action :verify_pundit_authorization

    helper_method :current_entity, :mgl_member

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

    # Member record (mglnr, contact and payment data) of the current entity.
    # Not named current_member, that is the signed in Member of devise.
    def mgl_member
      current_entity.member
    end

    def current_orchestra
      current_entity if current_entity.is_a?(Orchestra)
    end

    def pundit_user
      MemberContext.new(user: impersonating? ? current_user : current_member, entity: current_entity, impersonating: impersonating?)
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

    # members sign in with their member number, national users only get here
    # when impersonating a member
    def authenticate_member_or_impersonating_user!
      return if impersonating?

      authenticate_member!
    end

    def require_active_entity
      return if current_entity&.member.present?

      if impersonating?
        stop_impersonation
        redirect_to root_path, flash: { error: t("mgl.impersonation.missing_entity") }
        return
      end

      # member whose orchestra / person member is gone: the main area is off
      # limits as well, so the only way out is to sign out
      Rails.logger.warn("Member #{current_member.id} references a missing #{current_member.member_entity_type} #{current_member.member_entity_id}")
      sign_out current_member
      redirect_to new_member_session_path, flash: { error: t("mgl.missing_entity") }
    end
  end
end
