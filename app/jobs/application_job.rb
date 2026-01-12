class ApplicationJob < ActiveJob::Base
  #include Rails.application.routes.url_helpers
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked
  #
  #
  def notify_success(message_content)
      Turbo::StreamsChannel.broadcast_render_to(
        "notifications",
        target: "notifications",
        # The action can be :append, :prepend, :replace, :update, :remove, etc.
        action: :prepend,
        # This renders a partial
        partial: "notifications/job_notification",
        locals: { message: message_content, timestamp: Time.now }
      )
  end

  def default_url_options
    {
      host: ActionMailer::Base.default_url_options[:host],
      protocol: ActionMailer::Base.default_url_options[:protocol]
    }
  end


end
