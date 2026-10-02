# devise-passkeys does not register its devise module itself.
# Registering it adds the :passkey_authenticatable warden strategy
# to every mapping whose model uses the module (users only).
Devise.add_module :passkey_authenticatable,
                  model: "devise/passkeys/model",
                  strategy: true
