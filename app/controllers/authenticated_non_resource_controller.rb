class AuthenticatedNonResourceController < ApplicationController
  protect_from_forgery
  #rescue_from CanCan::AccessDenied do |exception|
  #  if current_user.nil?
  #    redirect_to new_user_session_url warning: exception.message
  #  else
  #    redirect_to home_landing_page_url warning: exception.message
  #  end
  #end

  #check_authorization

  include Pundit::Authorization
  after_action :verify_pundit_authorization

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError do |exception|
    Rails.logger.warn(exception.message)

    msg = exception.message

    flash[:error] = msg

    redirect_to root_url
  end

  def verify_pundit_authorization
    verify_authorized
  end

  private

  protected

end
