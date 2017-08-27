#!/usr/bin/env ruby
require 'feed_ninja'

get "http://feeds.feedburner.com/nerfnow/full" do
  picture_at "//div[@id='comic']//img/@src"
  text_at "//div[@class='comment']/p"
end
