class HomeController < ApplicationController
  before_filter :authenticate_user!#, :except => [:index]
	skip_authorization_check
#  load_and_authorize_resource
  def index
	if ( ! params[:tab] ) then
		params[:tab]='member_data'
	end
	if params[:tab] == 'public_data'
		render :action => 'public_data'
	elsif params[:tab] == 'member_data'
		render :action => 'member_data'
	else 
		render :action => 'reference_data'
	end
	
  end

end
