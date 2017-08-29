#!/usr/bin/env ruby

require "feed_ninja"

get "http://cad-comic.com/?feed=rss" do
  picture_at '//*[@class="comicpage"]/a[not(@rel)]/img/@src'
  text_at '//*[@id="comicblog"]/div[2]'
end
