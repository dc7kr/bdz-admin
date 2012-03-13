class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionHelper

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user, User
      store_location = session[:return_to]
      clear_stored_location
      (store_location.nil?) ? "/" : store_location.to_s
    else
      super
    end
  end

  def admin?
	session[:user].email=='karsten.richter@bdz-online.de'
  end

  helper_method :admin?

  protected
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  def choose_layout
	case action_name
    when "public"
      "public"
    else
      "application"
    end

  end


end
