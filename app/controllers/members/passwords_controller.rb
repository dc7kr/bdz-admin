# frozen_string_literal: true

# Password reset of the member area. The reset mail goes to Member#email,
# members without an address get their password from the office.
class Members::PasswordsController < Devise::PasswordsController
  layout "mgl"

  protected

  def after_resetting_password_path_for(_resource)
    mgl_root_path
  end

  def after_sending_reset_password_instructions_path_for(_resource_name)
    new_member_session_path
  end
end
