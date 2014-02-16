require 'feed_ninja/feed_ninja'
require 'feed_ninja/atomish'
require 'feed_ninja/extractor'

def get (url, &block)
  ninja = FeedNinja.new
  ninja.instance_eval(&block)
  ninja.fetch(url)
  puts "Content-type: application/atom+xml\n\n"
  puts ninja.to_s
end
