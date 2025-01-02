# frozen_string_literal: true

if Rails.env.development? && ENV["DISCOURSE_FLUSH_REDIS"]
  puts "Flushing redis (development mode)"
  Discourse.redis.flushdb
end

begin
  puts "Connecting to Redis..."
  
  # Configure Redis with tcp_keepalive and other parameters
  Discourse.redis = Redis.new(
    url: "rediss://#{ENV['DISCOURSE_REDIS_USERNAME']}:#{ENV['DISCOURSE_REDIS_PASSWORD']}@#{ENV['DISCOURSE_REDIS_HOST']}:#{ENV['DISCOURSE_REDIS_PORT']}",
    ssl: ENV['DISCOURSE_REDIS_USE_TLS'] == 'true',
    tcp_keepalive: 60 # Add the tcp_keepalive setting here
  )
  
  redis_info = Discourse.redis.info
  puts "Redis Info: #{redis_info}"

  if Gem::Version.new(redis_info["redis_version"]) < Gem::Version.new("6.2.0")
    STDERR.puts "Discourse requires Redis 6.2.0 or up"
    exit 1
  else
    puts "Redis version: #{redis_info['redis_version']}"
  end
rescue Redis::CannotConnectError => e
  STDERR.puts "Couldn't connect to Redis: #{e.message}"
  exit 1
end
