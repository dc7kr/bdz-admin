# frozen_string_literal: true

module Mgl
  # read only
  class MemberAccountBookingPolicy < ApplicationPolicy
    def download?
      own? && (record.invoice_id.present? || record.has_attachment?)
    end

    private

    def owned_by_entity?
      record.member_id == user.restricting_member&.id
    end

    class Scope < ApplicationPolicy::Scope
      private

      def resolve_for(entity)
        member = entity&.member
        member ? scope.where(member_id: member.id) : scope.none
      end
    end
  end
end
