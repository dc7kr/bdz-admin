module Mgl
  # National and admin users may open the member area in the name of an orchestra
  # or person member. They stay signed in with their own account; only the entity
  # shown in the member area is taken from the session. Inside the member area they
  # get exactly the rights of the member (see Mgl::MemberContext).
  module Impersonation
    extend ActiveSupport::Concern

    SESSION_KEY = :mgl_impersonation
    ENTITY_TYPES = %w[Orchestra PersonMember].freeze

    included do
      helper_method :mgl_entity, :mgl_entity_name, :impersonating?
    end

    def self.allowed?(user)
      user.present? && user.admin_level? && user.national_permission?
    end

    protected

    # Orchestra or PersonMember shown in the member area: the impersonated entity
    # of a national user, or the member user's own entity
    def mgl_entity
      return @mgl_entity if defined?(@mgl_entity)

      @mgl_entity = if impersonating?
        impersonated_entity
      elsif member_signed_in?
        current_member.member_entity
      end
    end

    # "Name (mglnr)" of an orchestra or person member
    def mgl_entity_name(entity = mgl_entity)
      return if entity.nil?

      name = entity.is_a?(Orchestra) ? entity.orchName : entity.fullname
      "#{name} (#{entity.member&.mglnr})"
    end

    def impersonating?
      session[SESSION_KEY].present? && user_signed_in? && Impersonation.allowed?(current_user)
    end

    def start_impersonation(entity)
      session[SESSION_KEY] = { "type" => entity.class.name, "id" => entity.id }
      remove_instance_variable(:@mgl_entity) if defined?(@mgl_entity)
      Rails.logger.info("User #{current_user.id} impersonates #{entity.class.name} #{entity.id}")
    end

    def stop_impersonation
      data = session.delete(SESSION_KEY)
      remove_instance_variable(:@mgl_entity) if defined?(@mgl_entity)
      Rails.logger.info("User #{current_user&.id} stopped impersonating #{data.inspect}") if data
    end

    private

    def impersonated_entity
      data = session[SESSION_KEY]
      return unless data.is_a?(Hash) && ENTITY_TYPES.include?(data["type"])

      data["type"].constantize.find_by(id: data["id"])
    end
  end
end
