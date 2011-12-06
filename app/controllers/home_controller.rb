class HomeController < ApplicationController
  before_filter :authenticate_user!#, :except => [:index]
	skip_authorization_check
#  load_and_authorize_resource
  def index
  end

end
