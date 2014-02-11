Sidekiq.configure_server do |config|
  config.redis = { :url => 'redis://user:***REMOVED***@***REMOVED***:6379/12', :namespace => 'bdz-'+Rails.env }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://user:***REMOVED***@***REMOVED***:6379/12', :namespace => 'bdz-'+Rails.env }
end
