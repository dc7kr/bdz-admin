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
end
