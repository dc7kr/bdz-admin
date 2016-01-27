module NotifyHelper
	def admin_notify_users
		if is_production?
    		@users = User.for_admin_notify
		else
			@users = User.with_role(:admin)
		end
	end
end
