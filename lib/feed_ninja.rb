require 'feed_ninja/feed_ninja'
require 'feed_ninja/atomish'
require 'feed_ninja/extractor'

def get (url, &block)
  ninja = FeedNinja.new url
  ninja.instance_eval(&block)
  ninja.run
end
