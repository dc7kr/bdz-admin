Sidekiq.configure_server do |config|
  redis_url = Rails.application.credentials[:redis_url]

  config.redis = { url: redis_url }

  config.capsule("serialized") do |cap|
    cap.concurrency = 1
    cap.queues = %w[queue_a queue_b] # strict priority
    # cap.queues = %w[queue_a,3 queue_b,1] # weighted
  end

end

Sidekiq::Cron.configure do |config|
end

Sidekiq.configure_client do |config|
  config.redis = { url: Rails.application.credentials[:redis_url] }
end
