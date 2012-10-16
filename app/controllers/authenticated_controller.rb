class AuthenticatedController < ApplicationController 
  protect_from_forgery

  before_filter :authnUser
  load_and_authorize_resource 
#  skip_authorize_resource :only => [noAuthActions]

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
    #redirect_to home_landing_page_url 
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
