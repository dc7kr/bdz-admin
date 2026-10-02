# frozen_string_literal: true

module Mgl
  class PersonMemberPolicy < ApplicationPolicy
    def update?
      own?
    end

    private

    def owned_by_entity?
      record == entity
    end
  end
end
