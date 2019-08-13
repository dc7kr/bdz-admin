class AuthenticatedController < ApplicationController 
  protect_from_forgery

  load_and_authorize_resource 

  before_filter :authnUser
  #ensure_authorization_performed :except => [:index, :search], :if => :auditing_security?, :unless => :devise_controller?

  def auditing_security?
    Rails.env != 'production'
  end

#  skip_authorize_resource :only => [noAuthActions]

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.warn(exception.message)

    msg = exception.message

    if Rails.env != 'production' then
      msg=" CANCAN: "+msg
    end
    
    flash[:error] = msg

    redirect_to root_url
    #redirect_to home_landing_page_url 
  end


  rescue_from Authority::SecurityViolation do |exception|
    flash[:error] = exception.message

    Rails.logger.error(exception.message)
    redirect_to root_url
  end



  private 
  def authnUser
    if ! noAuthActions.include?(@current_action) then
      #render :text => @current_action	
      authenticate_user!
    end
  end

  # override for CANCAN 
  def skip?
	noAuthAction.include(@current_action)
  end

  protected
  def noAuthActions
	[]
  end
end
