class AuthenticatedController < ApplicationController 
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  load_and_authorize_resource 
end
