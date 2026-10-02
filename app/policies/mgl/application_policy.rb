# frozen_string_literal: true

module Mgl
  # Base policy for the member area. Member level users may only access records
  # belonging to their own restricting entity (Orchestra or PersonMember).
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
      user.present? && user.member_level?
    end

    def entity
      user.restricting_entity
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
        return scope.none unless user.present? && user.member_level?

        resolve_for(user.restricting_entity)
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
