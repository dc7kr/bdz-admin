module WebsiteAreaHelper

	def current_area
		if @website_area then
			@website_area
		else
			"public_data"
		end
	end
end
