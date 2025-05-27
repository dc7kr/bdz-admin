module NotifyHelper
  def admin_notify_users
    @users = if is_production?
               User.for_admin_notify
    else
               User.with_role(:admin)
    end
  end
end
