# frozen_string_literal: true

module Mgl
  class OrchestraContactPolicy < OrchestraDataPolicy
    def create?
      own?
    end

    def update?
      own?
    end

    def destroy?
      own?
    end
  end
end
