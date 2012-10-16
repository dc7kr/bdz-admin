class AboutController < ApplicationController
	include  GitHelper

	def index
		@git_info = git_info
		respond_to do |format|
			format.html # index.html.erb
		end
	end

end
