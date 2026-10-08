# frozen_string_literal: true

module Mgl
  # Pundit user of the member area: the signed in user and the entity it acts for,
  # its own restricting entity or the entity it impersonates (Mgl::Impersonation).
  MemberContext = Struct.new(:user, :entity, :impersonating, keyword_init: true) do
    def member
      entity&.member
    end

    def impersonating?
      impersonating == true
    end
  end
end
