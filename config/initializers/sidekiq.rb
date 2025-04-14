Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") { "" } }

  config.capsule("serialized") do |cap|
    cap.concurrency = 1
    cap.queues = %w[queue_a queue_b] # strict priority
    # cap.queues = %w[queue_a,3 queue_b,1] # weighted
  end

  config.on(:startup) do
    schedule_file = "config/schedule.yml"

    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file) && Sidekiq.server?
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") { "" } }
end
