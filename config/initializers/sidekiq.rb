Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/schedule.yml"
    
    if File.exist?(schedule_file) && Sidekiq.server?
        Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end   
  end    
  config.redis = { :url => Rails.application.credentials.dig(:redis_url) }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => Rails.application.credentials.dig(:redis_url) }
end
