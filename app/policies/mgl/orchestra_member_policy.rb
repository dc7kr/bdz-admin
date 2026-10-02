# frozen_string_literal: true

module Mgl
  class OrchestraMemberPolicy < OrchestraDataPolicy
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
