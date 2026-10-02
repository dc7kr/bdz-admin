# The WebAuthn relying party is derived from the current request, so
# passkeys are bound to the host name the admin interface is served from.
module WebauthnRelyingParty
  extend ActiveSupport::Concern

  protected

  def relying_party
    @relying_party ||= WebAuthn::RelyingParty.new(
      id: request.host,
      name: "BDZ Admin",
      allowed_origins: [ request.base_url ]
    )
  end
end
