# frozen_string_literal: true

# Lets a signed in user manage their own passkeys.
#
# The devise-passkeys concern assumes passwordless accounts and requires a
# passkey based reauthentication for every change. Our users have passwords,
# so adding a passkey is confirmed with the current password instead (the
# registration challenge is only issued after the password was verified).
class Users::PasskeysController < DeviseController
  include Devise::Passkeys::Controllers::PasskeysControllerConcern
  include WebauthnRelyingParty

  skip_before_action :verify_reauthentication_token
  skip_before_action :ensure_at_least_one_passkey
  before_action :verify_current_password, only: :new_create_challenge
  before_action :require_label, only: :new_create_challenge

  def index
    @passkeys = resource.passkeys.order(:created_at)
  end

  def destroy
    @passkey.destroy
    redirect_to users_passkeys_path, notice: find_message(:passkey_deleted), status: :see_other
  end

  protected

  def create_passkey(resource:)
    passkey = resource.passkeys.build(
      label: passkey_params[:label],
      public_key: @webauthn_credential.public_key,
      external_id: Base64.strict_encode64(@webauthn_credential.raw_id),
      sign_count: @webauthn_credential.sign_count,
      last_used_at: nil
    )

    if passkey.save
      flash[:notice] = find_message(:passkey_created)
      render json: { redirect_to: users_passkeys_path }
    else
      render json: { message: passkey.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def user_details_for_registration
    resource.update_column(:webauthn_id, WebAuthn.generate_user_id) if resource.webauthn_id.blank?

    { id: resource.webauthn_id, name: resource.username.presence || resource.email, display_name: resource.name }
  end

  def passkey_params
    params.require(:passkey).permit(:label, :credential, :current_password)
  end

  def verify_current_password
    return if resource.valid_password?(passkey_params[:current_password])

    render json: { message: find_message(:invalid_current_password) }, status: :unprocessable_entity
  end

  def require_label
    return if passkey_params[:label].present?

    render json: { message: find_message(:passkey_label_missing) }, status: :unprocessable_entity
  end
end
