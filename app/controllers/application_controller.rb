class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionHelper

  private
      before_filter :instantiate_controller_and_action_names
     
      def instantiate_controller_and_action_names
          @current_action = action_name
          @current_controller = controller_name
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

  def render_optional_error_file(status_code)
    if status_code == :not_found
      render_404
    else
      super
    end
  end

  def render_404
    respond_to do |type| 
      type.html { render :template => "errors/error_404", :layout => 'application', :status => 404 } 
      type.all  { render :nothing => true, :status => 404 } 
    end
    true  # so we can do "render_404 and return"
  end

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
