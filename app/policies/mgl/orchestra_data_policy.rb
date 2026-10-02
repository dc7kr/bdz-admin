# frozen_string_literal: true

module Mgl
  # records belonging to the user's orchestra (contacts, members, report sheets, ...)
  class OrchestraDataPolicy < ApplicationPolicy
    def index?
      orchestra.present?
    end

    private

    def owned_by_entity?
      orchestra.present? && record.orchestra_id == orchestra.id
    end

    class Scope < ApplicationPolicy::Scope
      private

      def resolve_for(entity)
        entity.is_a?(Orchestra) ? scope.where(orchestra_id: entity.id) : scope.none
      end
    end
  end
end
