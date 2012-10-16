class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionHelper

	protected
      before_filter :instantiate_controller_and_action_names
     
      def instantiate_controller_and_action_names
        @current_action = action_name
        @current_controller = controller_name
		path = self.controller_path.split('/')
		@namespace = path.second ? path.first : nil
      end

	  def log_error(exception)
		message = "\n#{exception.class} (#{exception.message}):\n"
		Rails.logger.warn(message)
	  end



  def render_optional_error_file(status_code)
    if status_code == :not_found
      render_404
    else
      super
    end
  end


  # override static error page
  def render_optional_error_file(status_code) 
	@exception = exception
    #log_error(exception)
    respond_to do |format| 
      format.html { render :template => "/errors/error_500.html.erb", :layout => 'application', :status => 500 } 
      format.all  { render :nothing => true, :status => 500 } 
    end

  end

  def render_error(exception)
	@exception = exception
    log_error(exception)
    respond_to do |format| 
      format.html { render :template => "/errors/error_500.html.erb", :layout => 'application', :status => 500 } 
      format.all  { render :nothing => true, :status => 500 } 
    end
  end

  def render_not_found(exception)
    log_error(exception)
    respond_to do |type| 
      type.html { render :template => "/errors/error_404.html.erb", :layout => 'application', :status => 404 } 
      type.all  { render :nothing => true, :status => 404 } 
    end
    true  # so we can do "render_not_found and return"
  end

  protected
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def choose_layout
	path = request.fullpath.split('/')
	namespace = path.second if  path.first
	if namespace == "public" then
		"public"
	else 
		"application"
	end
  end

 #unless ActionController::Base.consider_all_requests_local
    rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
    rescue_from ActionController::UnknownController, :with => :render_not_found
    rescue_from ActionController::UnknownAction, :with => :render_not_found
 #end 

end
