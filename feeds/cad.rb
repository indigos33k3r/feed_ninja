#!/usr/bin/env ruby

require "feed_ninja"

get "http://cad-comic.com/?feed=rss" do
  picture_at '//*[@id="background"]/div[2]/div[3]/article/div[2]/a[2]/img/@src'
  text_at '//*[@id="comicblog"]/div[2]'
end
