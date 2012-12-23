module NotifyHelper
	def admin_notify_users
		if is_production?
    		@users = User.where("role like ? or role like ?", "%accounting%", "%admin%")
		else
			@users = User.where("role like ?","%admin%")
		end
	end
end
