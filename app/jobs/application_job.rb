class ApplicationJob < ActiveJob::Base
  #include Rails.application.routes.url_helpers
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

end
