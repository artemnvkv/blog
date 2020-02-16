require "sidekiq/web"

redis_url = if Rails.env.development?
              'redis://localhost:6379'
            elsif Rails.env.production?
              ENV['REDIS_URL']
            end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end

if Rails.env.development?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
