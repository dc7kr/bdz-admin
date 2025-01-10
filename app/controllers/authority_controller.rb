class AuthorityController < ApplicationController
  ensure_authorization_performed except: %i[index search], if: :auditing_security?,
                                 unless: :devise_controller?

  def auditing_security?
    !Rails.env.production?
  end

  rescue_from Authority::SecurityViolation, with: ->(exception) { render_error 403, exception }
  rescue_from Authority::MissingUser, with: :goto_login_page

  # Send 'em back where they came from with a slap on the wrist
  def authority_forbidden(error)
    Authority.logger.warn(error.message)
    redirect_to request.referer.presence || root_path, alert: 'You are not authorized to complete that action.'
  end
end
