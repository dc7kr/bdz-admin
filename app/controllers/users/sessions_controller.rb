# frozen_string_literal: true

# Password login (devise default) plus passkey login.
#
# The passkey login posts user[passkey_credential] to #create, where the
# :passkey_authenticatable warden strategy verifies it against the
# challenge issued by #new_challenge.
class Users::SessionsController < Devise::SessionsController
  include Devise::Passkeys::Controllers::SessionsControllerConcern
  include WebauthnRelyingParty
end
