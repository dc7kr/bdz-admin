# frozen_string_literal: true

# Member area sign in: member number and password, or a passkey.
class Members::SessionsController < Devise::SessionsController
  include Devise::Passkeys::Controllers::SessionsControllerConcern
  include WebauthnRelyingParty

  layout "mgl"
end
