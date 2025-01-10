class Adm::MailCheckController < AuthenticatedNonResourceController
  def index
    authorize! :member, :edit
  end

  def admin_notify
    authorize! :member, :edit

    AdminNotifier.test_notification(current_user).deliver
  end
end
