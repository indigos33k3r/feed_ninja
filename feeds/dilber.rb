#!/usr/bin/env ruby
require 'feed_ninja'

get "http://dilbert.com/feed" do
  picture_at "//img[@class='img-comic']/@src"
end

