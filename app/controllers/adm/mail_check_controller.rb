module Adm
  class MailCheckController < AuthenticatedNonResourceController
    def index
      authorize :admin, :show?
    end

    def admin_notify
      authorize! :admin, :show?

      AdminNotifier.test_notification(current_user).deliver
    end
  end
end
