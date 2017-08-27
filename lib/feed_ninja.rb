require 'feed_ninja/feed_ninja'
require 'feed_ninja/atomish'
require 'feed_ninja/extractor'
require 'logger'

def get (url, &block)
  ninja = FeedNinja.new
  ninja.instance_eval(&block)
  ninja.fetch(url)
  puts ninja.to_s
end

LOGGER = Logger.new(STDERR)
LOGGER.level = Logger::INFO
