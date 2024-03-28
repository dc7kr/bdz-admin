REDIS_SETTINGS = YAML.load_file(Rails.root.join('config', 'redis.yml'))[Rails.env]

server=REDIS_SETTINGS['server']
port=REDIS_SETTINGS['port']
user=REDIS_SETTINGS['user']
password=REDIS_SETTINGS['password']



if user.nil? then
  redis_url = "redis://#{server}:#{port}/12"
else
  redis_url = "redis://#{user}:#{password}@#{server}:#{port}/12"
end

Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/schedule.yml"
    
    if File.exist?(schedule_file) && Sidekiq.server?
        Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end   
  end    
  config.redis = { :url => redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => redis_url }
end
