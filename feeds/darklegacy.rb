#!/usr/bin/env ruby
require 'feed_ninja'

get "http://www.darklegacycomics.com/feed.xml" do
  picture_at "/html/body/div/div[4]/img/@src"
end
