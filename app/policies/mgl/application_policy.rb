# frozen_string_literal: true

module Mgl
  # Base policy for the member area. Users may only access records belonging to
  # the entity they act for (Orchestra or PersonMember): a member user's own
  # restricting entity or the entity a national user impersonates.
  #
  # user is a Mgl::MemberContext, not a User.
  class ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end

    def index?
      member_user?
    end

    def show?
      own?
    end

    def create?
      false
    end

    def new?
      create?
    end

    def update?
      false
    end

    def edit?
      update?
    end

    def destroy?
      false
    end

    private

    def member_user?
      entity.present?
    end

    def entity
      user&.entity
    end

    def orchestra
      entity if member_user? && entity.is_a?(Orchestra)
    end

    def own?
      member_user? && owned_by_entity?
    end

    # override in subclasses
    def owned_by_entity?
      false
    end

    class Scope
      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        return scope.none if user&.entity.nil?

        resolve_for(user.entity)
      end

      private

      attr_reader :user, :scope

      # override in subclasses
      def resolve_for(_entity)
        scope.none
      end
    end
  end
end
