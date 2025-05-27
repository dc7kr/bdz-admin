class NotificationBroadcastJob < ApplicationJob
  def perform(user_id, title, message)
    ActionCable.server.broadcast "notification_channel.#{user_id}", { action: "new_notification", title: title, message: message }
  end
end
