require "calyx"
require "twitter"
require "logger"

tiny_woodland = Calyx::Grammar.new do
  start :field
  field (0..7).map { "{row}{br}" }.join
  row (0..12).map { "{point}" }.join
  point trees: 0.6, foliage: 0.35, flowers: 0.05
  trees "🌲", "🌳"
  foliage "🌿", "🌱"
  flowers "🌷", "🌻", "🌼"
  br "\n"
end

twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
  config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
  config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
  config.access_token_secret = ENV["TWITTER_CONSUMER_SECRET"]
end

logger = Logger.new(STDOUT)

begin
  tweet = twitter_client.update(tiny_woodland.generate)
  logger.info("Posted tweet: https://twitter.com/#{tweet.user.name}/status/#{tweet.id}")
rescue Exception => e
  logger.error(e)
end
